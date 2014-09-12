class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username, :uniqueness =>  true

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>", :tiny=>"50x50>" }, :default_url => "missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  has_many :stores
  has_many :advertisements
  has_many :deals
  has_many :banners
end
