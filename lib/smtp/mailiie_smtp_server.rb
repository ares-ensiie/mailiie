class MailiieSmtpServer < MiniSmtpServer

  def new_message_event(message_hash)
    puts "# New email received:"
    puts "-- From: #{message_hash[:from]}"
    puts "-- To:   #{message_hash[:to]}"
    puts "--"
    puts "-- " + message_hash[:data].gsub(/\r\n/, "\r\n-- ")
    puts
    puts message_hash.to_json

    Message.create({from: message_hash[:from], body: message_hash[:data]})
  end

end
