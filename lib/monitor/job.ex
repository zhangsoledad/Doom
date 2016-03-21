defmodule Doom.Monitor.Job do
  import Ecto
  import Ecto.Query
  alias Doom.{Repo ,Task}
  alias Quantum.Job

  def from_task(%Task{id: id} = task) do
    %Job{
      schedule: "*/#{task.interval} * * * *",
      task: { Doom.Monitor.Executor, :execute },
      args: [ id ],
      overlap: false
    }
  end

  def add(%Task{id: id} = task) do
    case Quantum.find_job("#{id}") do
      nil ->
        job = from_task task
        Quantum.add_job("#{id}", job)
      job ->
        job
    end
  end

  def remove(%Task{id: id} = task) do
    Quantum.delete_job("#{id}")
  end

  def fresh(%Task{id: id} = task) do
    remove(task)
    add(task)
  end

  def init do
    tasks = Repo.all(from(t in Task, where: t.active == true))
    tasks |> Enum.map(&add(&1))
  end
end
