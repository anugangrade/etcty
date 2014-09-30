class SaleType < ActiveRecord::Base
	has_many :sale_connects
	has_many :sales, :through => :sale_connects
end
