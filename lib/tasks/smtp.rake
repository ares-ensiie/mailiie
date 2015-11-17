require "smtp/stdout_smtp_server"
namespace :smtp do
  desc "Manage the SMTP server"
  task start: :environment do
    puts "[SMTP] Starting SMTP server ..."
    server = StdoutSmtpServer.new(2525, "0.0.0.0", 4)
    server.start
    puts "[SMTP] SMTP Server listenning on port 2525 !"
    server.join
  end

end
