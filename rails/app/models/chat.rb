class Chat < ApplicationRecord
  validates :chat_number, presence: true, uniqueness: true
  validates :messages_count, presence: true
  
  belongs_to :application , counter_cache: :chats_count
  has_many :messages, dependent: :destroy

end
