json.array!(@mailings) do |mailing|
  json.extract! mailing, :id, :nom, :mail, :type_mailing
  json.url mailing_url(mailing, format: :json)
end
