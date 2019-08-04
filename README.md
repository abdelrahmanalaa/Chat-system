# Instabug challenge

  Chat application

# Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

# Prerequisites

Only docker and docker-compose should be installed on your machine.

# Ports
  - 3000 (rails server)
  - 3001 (golang server)
  - 9002 (elasticsearch)
  - 7364 (mysaql)
  - 6379 (redis)

  
# Installing

 - Clone the repo
 - open the terminal and cd the project directory
 - Run docker-compose up
 - wait until all containers are up
 - when mysql echo to the terminal that it's ready to accept connections Open new terminal and run docker-compose run rails rake db:create
 then docker-compose run rails rake db:migrate to create the database and the migrations
 - now the api is ready to be consumed
 
 
 
 # API - Documentations
 
 
 
  - Create application

      url: localhost:3000/applications
      method: POST
      content-type: application/json
      ex: body: {
          "name": "testing" 
      }
    
  - View application
      
      url: localhost:3000/applications/:token
      method: GET
      
  - Update application  
        url: localhost:3000/applications/:token
        
        method: PUT
        
        content-type: application/json
        ex: body: {
            "name": "testing" 
        }
        
  - Create chat    
        url: localhost:3001/applications/:token/chats
        
        method: POST
     
   - View chat  
        url: localhost:3000/applications/:token/chats/:chat_number
        
        method: GET
        
   - Create message
        url: localhost:3001/applications/:token/chats/:chat_number/messages
        
        method: POST
        
        content-type: json
        
        body: {
            "body": "hello there!"
        }
   
   
  - Search messages in chat

      url: localhost:3000/applications/:token/chats/:chat_number/messages/search/q=word
      
      method: get
      
      Query string: q = word to search for
      
   - View message  
   
        url: localhost:3000/applications/:token/chats/:chat_number/messages/:message_number
        
        method: get   
              
   - Update message 
   
   
        url: localhost:3000/applications/:token/chats/:chat_number/messages/:message_number
        
        method: PUT
        
        content-type: application/json
        
        body: {
            "body": "testing" 
        }
        
        
        
        
        Elasticsearch sometimes throw max virtual memory error this did the trick for me
        
          Run sysctl -w vm.max_map_count=262144
          
          
