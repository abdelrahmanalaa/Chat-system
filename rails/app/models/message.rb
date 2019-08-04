class Message < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  

  validates :body, presence: true
  validates :message_number, presence: true, uniqueness: true
  
  belongs_to :chat, counter_cache: :messages_count

  def as_indexed_json(options = nil)
    self.as_json( only: [:body, :message_number, :chat_id] )
  end

  def self.search(query, chatID)
   response = __elasticsearch__.search(
   {
    _source: ['body', 'message_number'],
     query: {
        bool: {
          must: {
            multi_match: {
              query: query,
              fields: ['body']
            },
          },
          filter: {
            term: {chat_id: chatID}
          }
        },
     },
     
   })

   response.results.map { |r| {body: r._source.body, message_number: r._source.message_number} }

 end

end
Message.__elasticsearch__.create_index!
Message.import
