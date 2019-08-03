class CreateApplications < ActiveRecord::Migration[5.0]
  def change
    create_table :applications do |t|
      t.string :name
      t.string :token, index: true
      t.decimal :chats_count , :default => 0
      
      t.timestamps
    end
  end
end
