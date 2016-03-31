defmodule Doom.Monitor.Executor do
  alias Task.Supervisor, as: TaskSup
  require Logger

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
         {:ok, _massege} <- validate_task_silent(task.silence_at),
         do:  process_request(task.method, task.url, task.headers, task.params)
              |> process_json_body(task)
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

  defp process_result(true, _code , body, _task) when is_map(body) do
    :ok
  end

  defp process_result(false, code , body, task) when is_map(body) do
    %{task_id: task.id, reason: "not match", status_code: code, expect: task.expect, result: body}
    |> send_alert(task)
  end

  defp process_result(false, code , body, task) when is_binary(body) do
    %{task_id: task.id, reason: "not match", status_code: code, expect: task.expect, result: %{result: body}}
    |> send_alert(task)
  end

  defp process_result(false, code , reason, task) when is_binary(reason)  do
    %{task_id: task.id, reason: reason, status_code: code, expect: task.expect}
    |> send_alert(task)
  end

  defp process_result(false, reason, task) when is_binary(reason) do
    %{task_id: task.id, reason: reason, expect: task.expect}
    |> send_alert(task)
  end

  defp process_result(false, reason, task) when is_atom(reason) do
    reason_string = reason |> Atom.to_string
    process_result(false, reason_string, task)
  end

  defp process_result(false, task)  do
    %{task_id: task.id, reason: "unknown", expect: task.expect}
    |> send_alert(task)
  end

  defp send_alert(alert, task) do
    alert_record = AlertRecord.changeset(%AlertRecord{}, alert) |> Repo.insert!

    {:ok, new_silence_at} = Calendar.DateTime.now_utc |> Calendar.DateTime.add(task.silent * 60)
    Ecto.Changeset.change(task, silence_at: new_silence_at) |> Repo.update

    groups = Repo.all(Ecto.assoc(task, :groups))
    user_email = groups
                |> Enum.flat_map(&Repo.all(Ecto.assoc(&1, :users)))
                |> Enum.map(&(&1.email))
                |> Enum.uniq
    Doom.Mailer.send_alert(user_email, alert_record, task)
  end


  defp process_json_body(body, task) do
    case body do
      {:ok, %HTTPoison.Response{status_code: code, body: body }} ->
        case body |> Poison.decode do
          {:ok, json_body}->
            tbody = json_body |> Map.take(Map.keys(task.expect))
            process_result( Map.equal?(tbody ,task.expect), code , tbody, task)
          {:error, _}->
            process_result( false, code , body, task)
        end
      {:ok, %HTTPoison.Response{status_code: code}} ->
        process_result(false, code , "No body return", task)
      {:error, %HTTPoison.Error{reason: reason}} ->
        process_result(false, reason, task)
      _ ->
       process_result(false, task)
    end
  end

  defp process_request("get", url, headers, params) do
    HTTPoison.get(url, headers, params: params)
  end

  defp process_request("post", url, headers, params) do
    HTTPoison.post(url, do_process_body(params), headers)
  end

  defp process_request("patch", url, headers, params) do
    HTTPoison.patch(url, do_process_body(params), headers)
  end

  defp process_request("put", url, headers, params) do
    HTTPoison.put(url, params, headers)
  end

  defp process_request("options", url, headers, _params) do
    HTTPoison.options(url, headers)
  end

  defp do_process_body(nil) do
    ""
  end

  defp do_process_body(%{}) do
    ""
  end

  defp do_process_body(body) do
    Poison.encode! body
  end
end
