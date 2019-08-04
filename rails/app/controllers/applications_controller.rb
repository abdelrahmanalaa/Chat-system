class ApplicationsController < ApplicationController
    def create
        application = Application.new(application_params)
        token = generate_token() 
        application["token"] = token
        if application.save
            render json: {status: "Application created successfully!", data: {
                token: token,
                name: application["name"],
            }}, status: :ok
        else
            render json: {status: "Application creation failed!", data: application.errors}, status: :unprocessable_entity
        end
    end

    def show
        
        application = Application.where(token: params[:token]).first
        
        if application == nil
            render json: {status: "resource not found"}, :status => :bad_request
            return
        end
        
        render json: {status: "SUCCESS", data: {
            token: application["token"],
            name: application["name"],
            chat_count: application["chats_count"],
        }}, status: :ok
    end

    def update
        application = Application.where(token: params[:token]).first

        if application == nil
            render json: {status: "resource not found"}, :status => :bad_request
            return
        end

        if application.update_attributes(application_params)
            render json: {status: "Application updated successfully!"}, status: :ok
        else
            render json: {status: "Application update failed!", data: application.errors}, status: :unprocessable_entity
        end
    end

    private

        def application_params
            params.permit(:name)
        end

        def generate_token
            SecureRandom.urlsafe_base64
        end
end

    
