json.array!(@advertisements) do |advertisement|
  json.extract! advertisement, :id, :title, :web_link, :start_date, :end_date
  json.url advertisement_url(advertisement, format: :json)
end
