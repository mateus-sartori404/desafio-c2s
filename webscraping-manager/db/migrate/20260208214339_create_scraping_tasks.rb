class CreateScrapingTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :scraping_tasks do |t|
      t.int :status, null: false, default: 0
      t.string :url
      t.string :title
      t.string :description
      t.string :result
      t.string :result_model
      t.string :result_price
      t.string :error_message
      t.datetime :completed_at


      t.timestamps
    end
  end
end
