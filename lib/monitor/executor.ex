defmodule Doom.Monitor.Executor do
  alias Task.Supervisor, as: TaskSup
  require Logger

  alias Doom.{Task, AlertRecord, User}
  alias Doom.Repo

  def execute(task_id) do
    TaskSup.async_nolink(Doom.TasksSupervisor, Doom.Monitor.Executor, :execute_async, [task_id])
  end

  def execute_async(task_id) do
    task = Repo.get(Task, task_id) |> Repo.preload(:groups)
    process_task(task)
  end

  def process_task(task) do
    case task.active do
      true ->
         response = process_request(task.method, task.url, task.headers, task.params)
         |> process_json_body(task)
         #Logger.debug inspect(response)
      _ ->
        :ok
    end
  end

  defp process_result(true, code , body, task) when is_map(body) do
    :ok
  end

  defp process_result(false, code , body, task) when is_map(body) do
    %{task_id: task.id, reason: "not match", status_code: code, expect: task.expect, result: body}
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
    alert_record = AlertRecord.changeset(%AlertRecord{}, alert) |> Repo.insert!
    groups = Repo.all(Ecto.assoc(task, :groups))
    user_email = groups
                |> Enum.flat_map(&Repo.all(Ecto.assoc(&1, :users)))
                |> Enum.map(&(&1.email))
                |> Enum.uniq
    Doom.Mailer.send_alert(user_email, "baozha", ["yo", "as"])
  end


  defp process_json_body(body, task) do
    case body do
      {:ok, %HTTPoison.Response{status_code: code, body: body }} ->
        json_body = body |> Poison.decode!
        tbody = json_body |> Map.take(Map.keys(task.expect))
        process_result( Map.equal?(tbody ,task.expect), code , json_body, task)
      {:ok, %HTTPoison.Response{status_code: code}} ->
        process_result(false, code , "No body return", task)
      {:error, %HTTPoison.Error{reason: reason}} ->
        process_result(false, reason, task)
      _ ->
       process_result(false, task)
    end
  end

  defp process_request("get", url, headers, params) do
    HTTPoison.get(url, Map.to_list(headers || %{}), params: params)
  end

  defp process_request("post", url, headers, params) do
    HTTPoison.post(url, params, Map.to_list(headers))
  end

  defp process_request("patch", url, headers, params) do
    HTTPoison.patch(url, params, Map.to_list(headers))
  end

  defp process_request("put", url, headers, params) do
    HTTPoison.put(url, params, Map.to_list(headers))
  end

  defp process_request("options", url, headers, params) do
    HTTPoison.options(url, params, Map.to_list(headers))
  end
end
