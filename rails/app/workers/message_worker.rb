class MessageWorker
  include Sidekiq::Worker
  
  def perform(*args)
    applicationToken = args[0]
    chatNumber = args[1].to_i
    messageNumber = args[2].to_i
    body = args[3]
    
    chat = Chat.joins(:application).merge(Application.where(token: applicationToken)).where(chat_number: chatNumber).first

    if chat == nil
      puts "resource not found"
      return
    end
    
    chat.messages.create({
      message_number: messageNumber,
      body: body
    })

  end
 end