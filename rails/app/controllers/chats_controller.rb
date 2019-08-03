class ChatsController < ApplicationController

    def show
        chat = Chat.joins(:application).merge(Application.where(token: params[:token])).where(chat_number: params[:number]).first

        if chat == nil
            render json: {status: "resource not found"}, :status => :bad_request
            return
        end
        
        render json: {status: "SUCCESS", data: {
            chat_number: chat["chat_number"],
            messages_count: chat["messages_count"],
        }}, status: :ok
    end

end