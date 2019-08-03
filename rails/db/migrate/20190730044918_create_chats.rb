class CreateChats < ActiveRecord::Migration[5.0]
  def change
    create_table :chats do |t|
      t.references :application, foreign_key: true, index: true
      t.decimal :messages_count, :default => 0
      t.decimal :chat_number, index: true
      t.timestamps
    end
  end
end
