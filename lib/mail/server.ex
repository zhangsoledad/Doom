defmodule Doom.Mailer.Server do
  use GenServer

  @smtp_config Map.merge(
                  %Mailman.SmtpConfig{},
                  Enum.into(
                    Application.get_env(:doom, :mailer),
                    %{auth: :always, tls: :always}
                  )
               )

  @mailer_config %Mailman.Context{ config: @smtp_config }

  @name Doom.GenMailer

  ## Client API
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: @name])
  end

  def deliver(email) do
    GenServer.call(@name, {:email, email})
  end

   ## Server Callbacks
  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:email, email} , _from, stats) do
    Task.Supervisor.async_nolink(Doom.TasksSupervisor, Mailman, :deliver, [email, @mailer_config])
    {:reply, :ok, stats}
  end
end
