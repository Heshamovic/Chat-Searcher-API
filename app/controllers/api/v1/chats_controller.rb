module Api
  module V1
    class ChatsController < ApplicationController
      def show
        return render json: { status: 'ERROR', error: 'Provide app token' }, status: :unprocessable_entity if params[:app_token].blank?

        helper = Helper.new
        app = helper.get_app(params[:app_token])
        return render json: { status: 'ERROR', error: 'Application doesn\'t exist' }, status: :not_found if app.blank?

        chat = Chat.where(number: params[:id], app_id: app[0].id).first
        return render json: { status: 'ERROR', error: 'Chat doesn\'t exist' }, status: :not_found if chat.blank?

        render json: { status: 'SUCCESS', chat: {number: chat.number, messages_count: chat.messages_count} }, status: :ok
      end

      def create
        return render json: { status: 'ERROR', error: 'Provide app_token' }, status: :unprocessable_entity if params[:app_token].blank?

        app = Application.where(token: params[:app_token]).first
        return render json: { status: 'ERROR', error: 'Application doesn\'t exist' }, status: :not_found if app.blank?

        app.with_lock do
          chat = Chat.new
          chat.number = app.chats_count + 1
          chat.app_id = app.id
          if chat.save
            app.update_column('chats_count', app.chats_count + 1)
            return render json: { status: 'SUCCESS', message: 'Chat Created Successfully', chat_number: chat.number }, status: :created
          end
          render json: { status: 'ERROR', message: 'Chat not Created', error: chat.errors }, status: :unprocessable_entity
        end
      end

    end
  end
end
