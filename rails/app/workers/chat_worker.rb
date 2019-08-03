class ChatWorker
  include Sidekiq::Worker

  def perform(*args)
    applicationToken = args[0]
    chatNumber = args[1].to_i
  
    application = Application.where(token: applicationToken).first

    if application == nil
      puts "resource not found"
      return 
    end

    application.chats.create({
      chat_number: chatNumber
    })
    
  end
 end