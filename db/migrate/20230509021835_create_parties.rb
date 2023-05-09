class CreateParties < ActiveRecord::Migration[7.0]
  def change
    create_table :parties do |t|
      t.integer :host_id
      t.integer :movie_id
      t.integer :duration
      t.date :date
      t.time :start_time

      t.timestamps
    end
  end
end
