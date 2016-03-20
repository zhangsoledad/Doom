defmodule Doom.Monitor.Job do
  import Ecto
  import Ecto.Query
  alias Doom.{Repo ,Task}
  alias Quantum.Job

  def from_task(%Task{id: id} = task) do
    %Job{
      name: "#{id}",
      schedule: "*/#{task.interval} * * * *",
      task: { Doom.Monitor.Executor, :execute },
      args: [ id ],
      overlap: false
    }
  end

  def add(%Task{id: id} = task) do
    case Quantum.find_job("#{id}") do
      nil ->
        task
        |> from_task
        |> Quantum.add_job
      job ->
        job
    end
  end

  def init do
    tasks = Repo.all(from(t in Task, where: t.active == true))
    tasks |> Enum.map(&add(&1))
  end
end
