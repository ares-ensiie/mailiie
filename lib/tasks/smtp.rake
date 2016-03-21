require "smtp/mailiie_smtp_server"
namespace :smtp do
  desc "Manage the SMTP server"
  task start: :environment do
    $stdout.puts "[SMTP] Starting SMTP server ..."
    server = MailiieSmtpServer.new(SMTP_CONFIG["smtp"]["port"], SMTP_CONFIG["smtp"]["bind"], 4)
    server.start
    $stdout.puts "[SMTP] SMTP Server listenning on #{SMTP_CONFIG["smtp"]["bind"]}:#{SMTP_CONFIG["smtp"]["port"]} !"
    server.join
  end

end
