defmodule Doom.Monitor.Executor do
  import Ecto
  import Ecto.Query
  alias Doom.{Task, AlertRecord, User}
  alias Doom.Repo

  def execute(%Task{} = task) do
    Task.Supervisor.async_nolink(Doom.TasksSupervisor, Doom.Monitor.Executor, :execute_async, [task])
  end

  def execute_async(%Task{url: url, params: params, headers: headers} = task) do
    response = process_request(task.method, url, headers, params)
    |> process_json_body(task)
  end

  defp process_result(true, code , body, task) when is_map(body) do
    :ok
  end

  defp process_result(false, code , body, task) when is_map(body) do
    %{task_id: task.id, reason: 'not match', status_code: code, expect: task.expect, result: body}
    |> send_alert(task)
  end

  defp process_result(false, code , reason, task) when is_binary(reason)  do
    %{task_id: task.id, reason: reason, status_code: code, expect: task.expect}
    |> send_alert(task)
  end

  defp process_result(false, reason, task) when is_binary(reason)  do
    %{task_id: task.id, reason: reason, expect: task.expect}
    |> send_alert(task)
  end

  defp process_result(false, task)  do
    %{task_id: task.id, reason: "unknown", expect: task.expect}
    |> send_alert(task)
  end

  defp send_alert(alert, task) do
    alert_record = AlertRecord.changeset(%AlertRecord{}, alert) |> Repo.insert
    groups = Repo.all(Ecto.assoc(task, :groups))
    user_email = groups
                |> Enum.map(&Repo.all(Ecto.assoc(&1, :groups)))
                |> List.flatten
                |> Enum.map(&(&1.email))
                |> Enum.uniq
    Doom.Mailer.send_alert(user_email, "baozha", ["yo"])
  end


  defp process_json_body(body, task) do
    case body do
      {:ok, %HTTPoison.Response{status_code: code, body: body }} ->
        tbody = body |> Map.take(Map.keys(task.expect))
        process_result( Map.equal?(tbody ,task.expect), code , body, task)
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
    HTTPoison.post(url, params, headers)
  end

  defp process_request("patch", url, headers, params) do
    HTTPoison.patch(url, params, headers)
  end

  defp process_request("put", url, headers, params) do
    HTTPoison.put(url, params, headers)
  end

  defp process_request("options", url, headers, params) do
    HTTPoison.options(url, params, headers)
  end
end
