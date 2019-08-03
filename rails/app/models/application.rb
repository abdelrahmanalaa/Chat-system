class Application < ApplicationRecord
    validates :name, presence: true
    validates :token, presence: true, uniqueness: true

    has_many :chats, dependent: :destroy
end