class MailiieSmtpServer < MiniSmtpServer

  def new_message_event(message_hash)
    mail = Mail.read_from_string(message_hash[:data])
    from = message_hash[:from][1..-2]
    to = message_hash[:to][1..-2]
    body = mail.body
    subject = mail.subject

    puts "[SMTP] New mail from : #{from} to #{to}"
    m = Mailing.find_by_mail(to)
    if m then
      m.inscriptions.each do | inscription |
        if inscription.valide
          mail = inscription.user().ldap()[:mail][0]
          send_mail(m.mail, mail, subject, body)
        end
      end
    else
      send_mail("ares@ares-ensiie.eu",from, "Unkonwn mailing list", "Unkonwn mailing list")
    end
  end


  def send_mail(from, to, subject, body)
    message = <<MESSAGE_END
From: #{from}
To: #{to}
Subject: #{subject}

#{body}
MESSAGE_END
    Net::SMTP.start(SMTP_CONFIG["send"]["host"], SMTP_CONFIG["send"]["port"]) do |smtp|
      smtp.send_message message, from, to
    end
  end
end
