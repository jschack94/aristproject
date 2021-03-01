class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.integer :device_id
      t.text :sender
      t.text :message

      t.timestamps
    end
  end
end
