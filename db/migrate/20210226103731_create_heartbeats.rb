class CreateHeartbeats < ActiveRecord::Migration[6.0]
  def change
    create_table :heartbeats do |t|
      t.integer :device_id

      t.timestamps
    end
  end
end
