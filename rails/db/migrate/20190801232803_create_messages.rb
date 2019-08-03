class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.references :chat, foreign_key: true, index: true
      t.text :body
      t.decimal :message_number, index: true
      t.timestamps
    end
  end
end
