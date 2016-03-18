defmodule Doom.Monitor.Job do
  alias Doom.Task
  alias Quantum.Job

  def from_task(%Task{id: id} = task) do
    %Job{
      name: "#{id}",
      schedule: "*/#{task.interval} * * * *",
      task: { Doom.Monitor.Executor, :execute },
      args: [ task ],
      overlap: false
    }
  end
end
