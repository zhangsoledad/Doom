defmodule Doom.Mailer do
  alias Doom.Mailer.{Templates, Server}

  @from Application.get_env(:doom, :mailer)[:username]

  # send_alert(["787953403@qq.com"], alert, task)
  def send_alert(to, alert, task) do
    html = Templates.alert_html(alert, task)
    %Mailman.Email{
      subject: "[Doom]Alert Info",
      from: @from,
      to: to,
      html: html }
    |> Server.deliver
  end

  def ask_confirm(to, link) do
    confirm_url = "#{Doom.Endpoint.url}/confirm?#{link}"
    html = Templates.confirm_html(confirm_url)
    %Mailman.Email{
      subject: "[Doom]Confirm your email",
      from: @from,
      to: to,
      html: html }
    |> Server.deliver
  end

  def ask_reset(to, link) do
    reset_link = "#{Doom.Endpoint.url}/reset?#{link}"
    html = Templates.reset_html(reset_link)
    %Mailman.Email{
      subject: "[Doom]Reset password",
      from: @from,
      to: to,
      html: html }
    |> Server.deliver
  end
end

