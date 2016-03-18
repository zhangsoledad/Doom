defmodule Doom.Mailer.Templates do
  require EEx

  EEx.function_from_file :def, :alert_html, "web/templates/mail/notify.html.eex", [:a, :b]
  EEx.function_from_file :def, :confirm_html, "web/templates/mail/confirm.html.eex", [:confirm_link]
  EEx.function_from_file :def, :reset_html, "web/templates/mail/reset.html.eex", [:reset_link]

  def alert_html([a,b]), do:  alert_html(a,b)
end
