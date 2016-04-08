defmodule Doom.Monitor.Executor do
  alias Task.Supervisor, as: TaskSup

  alias Doom.{Task, AlertRecord}
  alias Doom.Repo

  def execute(task_id) do
    TaskSup.async_nolink(Doom.TasksSupervisor, Doom.Monitor.Executor, :execute_async, [task_id])
  end

  def execute_async(task_id) do
    task = Repo.get(Task, task_id) |> Repo.preload(:groups)
    process_task(task)
  end

  def process_task(task) do
    with {:ok, _massege} <- validate_task(task),
         {:ok, _massege} <- validate_task_silent(task.silence_at) do
      case (task |> process_request) do
        {:ok, %HTTPoison.Response{status_code: code, body: body }} ->
          case analyze_body(body, task) do
            {:ok, _massege} ->
              :ok
            {:error, reason, result}->
              do_alert(task, reason, code, result)
          end
        {:ok, %HTTPoison.Response{status_code: code}} ->
          do_alert(task, "no body return", code , nil)
        {:error, %HTTPoison.Error{reason: reason}} ->
          do_alert(task, reason, nil , nil)
        _ ->
          do_alert(task, "unkown", nil , nil)
      end
    end
  end

  defp validate_task(task) do
    case task.active do
      true ->
        {:ok, "task is active"}
      _ ->
        {:ignore, "task is inactive"}
    end
  end

  defp validate_task_silent(silence_at) do
    case silence_at do
      nil ->
        {:ok, "task is not silence"}
      _ ->
        if Calendar.DateTime.now_utc |> Calendar.DateTime.after?(silence_at) do
          {:ok, "task is not silence"}
        else
          {:ignore, "task is silence"}
        end
    end
  end

  def do_alert(task, reason, code, result) when is_binary(reason) do
    %{task_id: task.id, reason: reason, status_code: code, expect: task.expect, result: result}
    |> send_alert(task)
  end

  def do_alert(task, reason, code , result) when is_atom(reason) do
    reason_string = reason |> Atom.to_string
    do_alert(task, reason_string, code , result)
  end

  defp send_alert(alert, task) do
    {:ok, new_silence_at} = Calendar.DateTime.now_utc |> Calendar.DateTime.add(task.silent * 60)

    {:ok, alert_record} = Repo.transaction fn ->
      Ecto.Changeset.change(task, silence_at: new_silence_at) |> Repo.update!
      AlertRecord.changeset(%AlertRecord{}, alert) |> Repo.insert!
    end

    groups = Repo.all(Ecto.assoc(task, :groups))
    user_email = groups
                |> Enum.flat_map(&Repo.all(Ecto.assoc(&1, :users)))
                |> Enum.map(&(&1.email))
                |> Enum.uniq
    Doom.Mailer.send_alert(user_email, alert_record, task)
  end

  defp analyze_body(body, %Task{type: "json", expect: expect}) do
    case (body |> Poison.decode) do
      {:ok, json} when is_map(json) ->
        keys = Map.keys(expect)
        result = json |> Map.take(keys)
        case Map.equal?(result ,expect) do
          true -> {:ok, :match}
          false -> {:error, "not match", result}
        end
      {:ok, body } ->
        {:error, "invaild json body", body }
      {:error, _ } ->
        {:error, "invaild json body", nil }
    end
  end

  defp analyze_body(body, %Task{type: "html", expect: expect}) do
    result =  expect
    |> Enum.map(fn {k, _} -> { k, Floki.find(body, k) |> Floki.raw_html } end)
    |> Enum.into(%{})
    case Map.equal?(result ,expect) do
      true -> {:ok, :match}
      false -> {:error, "not match", result}
    end
  end

  defp analyze_body(_body, _task) do
    {:error, "invaild task type", nil }
  end

  defp process_request(%Task{ method: "get", url: url, headers: headers, params: params}) do
    HTTPoison.get(url, headers, params: params)
  end

  defp process_request(%Task{ method: "post", url: url, headers: headers, params: params}) do
    HTTPoison.post(url, do_request_body(params), headers)
  end

  defp process_request(%Task{ method: "patch", url: url, headers: headers, params: params}) do
    HTTPoison.patch(url, do_request_body(params), headers)
  end

  defp process_request(%Task{ method: "put", url: url, headers: headers, params: params}) do
    HTTPoison.put(url, params, headers)
  end

  defp process_request(%Task{ method: "options", url: url, headers: headers}) do
    HTTPoison.options(url, headers)
  end

  defp do_request_body(nil) do
    ""
  end

  defp do_request_body(%{}) do
    ""
  end

  defp do_request_body(body) do
    Poison.encode! body
  end
end
