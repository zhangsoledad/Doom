defmodule Doom.Mailer.Templates do
  require EEx

  EEx.function_from_file :def, :alert_html, "web/templates/mail/alert.html.eex", [:alert, :task]
  EEx.function_from_file :def, :confirm_html, "web/templates/mail/confirm.html.eex", [:confirm_link]
  EEx.function_from_file :def, :reset_html, "web/templates/mail/reset.html.eex", [:reset_link]
end
