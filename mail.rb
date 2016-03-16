require 'net/smtp'

message = <<MESSAGE_END
From: Private Person <test@ares-ensiie.eu>
To: A Test User <2017@ares-ensiie.eu>
Subject: SMTP e-mail test

This is a test e-mail message.
MESSAGE_END

Net::SMTP.start("localhost","2525") do |smtp|
  smtp.send_message message, 'test@ares-ensiie.eu',
                             '2017@ares-ensiie.eu'
end
