ActiveAdmin.register Banner do


  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :web_link, :image, :user_id, :title, :start_date, :end_date
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end

  form do |f|
    f.inputs "New Banner" do
      f.input :user_id, :label => 'User', :as => :select, :collection => User.all.map{|u| ["#{u.username}", u.id]}
      f.input :title
      f.input :web_link
      f.input :start_date, :as => :datepicker
      f.input :end_date, :as => :datepicker
      f.input :image, :required => true, :as => :file
      # Will preview the image when the object is edited
    end
    f.actions
   end


end
