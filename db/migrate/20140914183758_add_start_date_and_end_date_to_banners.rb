class AddStartDateAndEndDateToBanners < ActiveRecord::Migration
  def change
    add_column :banners, :start_date, :date
    add_column :banners, :end_date, :date
  end
end
