json.array!(@templates) do |template|
  json.extract! template, :id, :logo_position, :logo_image_type, :bg_color, :bg_image, :no_of_images
  json.url template_url(template, format: :json)
end
