defmodule Doom.Mailer do
  alias Doom.Mailer.{Templates, Server}

  @from Application.get_env(:doom, :mailer)[:username]

  # send_alert(["787953403@qq.com"], "baozha", ["yo"])
  def send_alert(to, subject, data , cc \\ [], bcc \\ []) do
    html = Templates.send_alert(data)
    %Mailman.Email{
      subject: subject,
      from: @from,
      cc: cc,
      to: to,
      bcc: bcc,
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

