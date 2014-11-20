class Institute < ActiveRecord::Base
	belongs_to :user
	
	has_many :branches, :as => :branchable, dependent: :destroy
	accepts_nested_attributes_for :branches
end
