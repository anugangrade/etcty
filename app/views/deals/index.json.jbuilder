json.array!(@deals) do |deal|
  json.extract! deal, :id, :title, :description, :web_link, :user_id, :start_date, :end_date, :image
  json.url deal_url(deal, format: :json)
end
