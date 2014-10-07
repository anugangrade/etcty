ActiveAdmin.register User do


  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :email, :encrypted_password, :name, :username, :address, :city, :state, :country, :zip, :facebook_link,:twitter_link, :linkedin_link,:avatar
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end

  index do
    column "Avatar" do |user|
      image_tag user.avatar.url(:tiny), style: 'height:50px;width:50px;'
    end
    column :email
    column :name
    column :username
    column :address
    column :city
    column :state
    column :country
    column :zip
    column :facebook_link
    column :twitter_link
    column :linkedin_link
    actions
  end


end
