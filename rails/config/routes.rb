Rails.application.routes.draw do
  post '/applications', to: 'applications#create'
  get '/applications/:token', to: 'applications#show'
  put '/applications/:token', to: 'applications#update'
  get '/applications/:token/chats/:number', to: 'chats#show'
  get '/applications/:token/chats/:chat_number/messages/search', to: 'messages#search'
  get '/applications/:token/chats/:chat_number/messages/:message_number', to: 'messages#show'
  put '/applications/:token/chats/:chat_number/messages/:message_number', to: 'messages#update'
end
