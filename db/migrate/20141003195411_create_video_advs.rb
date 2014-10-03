class CreateVideoAdvs < ActiveRecord::Migration
  def change
    create_table :video_advs do |t|
      t.string :title
      t.string :youtube_url
      t.date :start_date
      t.date :end_date
      t.integer :user_id

      t.timestamps
    end
  end
end
