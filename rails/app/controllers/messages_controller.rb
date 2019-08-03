class MessagesController < ApplicationController
    def show
        message = Message.joins(:chat => :application).where(chats: {
            chat_number: params[:chat_number],
            applications: {
                token: params[:token]
            }
        }).where(message_number: params[:message_number]).first

        if message == nil
            render json: {status: "resource not found"}, :status => :bad_request
            return
        end
        render json: {status: "SUCCESS", data: {
            body: message["body"],
        }}, status: :ok
    end

    def update
        message = Message.joins(:chat => :application).where(chats: {
            chat_number: params[:chat_number],
            applications: {
                token: params[:token]
            }
        }).where(message_number: params[:message_number]).first

        if message == nil
            render json: {status: "resource not found"}, :status => :bad_request
            return
        end

        if message.update_attributes(message_params)
            render json: {status: "Message updated successfully!"}, status: :ok
        else
            render json: {status: "Message update failed!", data: message.errors}, status: :unprocessable_entity
        end
    end

    def search
        chat = Chat.joins(:application).where(
            applications: {
                token: params[:token]
            }
        ).where(chat_number: params[:chat_number]).first

        if chat == nil
            render json: {status: "resource not found"}, :status => :bad_request
            return
        end

        chatID = chat["id"]

        messages = params[:q].nil? ? [] : Message.search(params[:q], chatID)

        render json: {status: "Search result!", data: messages}, status: :ok
   end

    private

        def message_params
            params.permit(:body)
        end

end