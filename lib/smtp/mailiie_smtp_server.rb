class MailiieSmtpServer < MiniSmtpServer

  def new_message_event(message_hash)
    mail = Mail.read_from_string(message_hash[:data])
    from = message_hash[:from][1..-2]
    to = message_hash[:to][1..-2]
    body = mail.body
    subject = mail.subject

    puts "[SMTP] New mail from : #{from} to #{to}"

    header = message_hash[:data].split("\n\n")[0]
    body = message_hash[:data].split("\n\n")[1..-1].join("\n\n")

    m = CustomMailing.find_by_mail(to)
    if m then
      m.users().each do | user |
        header += <<END_HEADER
List-Post: <mailto:#{m.mail}>
END_HEADER
        send_mail(m.mail, user[:mail][0], subject, [header,body].join("\n\n"))
      end
    else
      m = Mailing.find_by_mail(to)
      if m then
        m.inscriptions.each do | inscription |
          if inscription.valide
            mail = inscription.user().ldap()[:mail][0]
            header += <<END_HEADER
List-Post: <mailto:#{m.mail}>
END_HEADER
            send_mail(m.mail, mail, [header,body].join("\n\n"))
          end
        end
      else
        message = construct_message("ares@ares-ensiie.eu",from, "Unkonwn mailing list", "Unkonwn mailing list")
        send_mail("ares@ares-ensiie.eu", from, message)
      end
    end
  end


  def construct_message(from, to, subject, body)
    message = <<MESSAGE_END
From: #{from}
To: #{to}
Subject: #{subject}

#{body}
MESSAGE_END
    return message
  end

  def send_mail(from, to, body)
    Net::SMTP.start(SMTP_CONFIG["send"]["host"], SMTP_CONFIG["send"]["port"]) do |smtp|
      smtp.send_message body, from, to
    end
  end
end
