defmodule Doom.Mailer.Templates do
  require EEx

  EEx.function_from_file :def, :notify_html, "web/templates/mail/notify.html.eex", [:a, :b]
  EEx.function_from_file :def, :confirm_html, "web/templates/mail/confirm.html.eex", [:confirm_link]
  EEx.function_from_file :def, :reset_html, "web/templates/mail/reset.html.eex", [:reset_link]

  def notify_html([a,b]), do:  notify_html(a,b)
end
