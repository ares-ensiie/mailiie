class MailiieSmtpServer < MiniSmtpServer

  def new_message_event(message_hash)
    mail = Mail.read_from_string(message_hash[:data])
    from = message_hash[:from]
    to = message_hash[:to]
    body = mail.body
    subject = mail.subject


    puts "--- START ---"
    puts "From : "+from
    puts "To : "+to
    puts "Subject : "+subject
    puts body
    puts "--- END ---"

    Message.create({from: from, body: body})
  end

end
