module Api
  module V1
    class MessagesController < ApplicationController
      def index
        all_info = Message.order('number, chat_id')
        msgs = []
        all_info.each { |x| msgs.append({ number: x['number'], message: x['body'] }) }
        render json: { status: 'SUCCESS', messages: msgs}, status: :ok
      end

      def show
        return render json: { status: 'ERROR', error: 'Provide app token' }, status: :unprocessable_entity if params[:app_token].blank?

        return render json: { status: 'ERROR', error: 'Provide chat number' }, status: :unprocessable_entity if params[:chat_number].blank?

        helper = Helper.new
        app = helper.get_app(params[:app_token])
        return render json: { status: 'ERROR', error: 'Application doesn\'t exist' }, status: :not_found if app.blank?

        chat = helper.get_chat(app[0].id, params[:chat_number])
        return render json: { status: 'ERROR', error: 'Chat doesn\'t exist' }, status: :not_found if chat.blank?

        msg = helper.get_message(chat[0].id, params[:id])
        return render json: { status: 'ERROR', error: 'Message doesn\'t exist' }, status: :not_found if msg.blank?

        render json: { status: 'SUCCESS', message: msg[0].body }, status: :ok
      end

      def create
        if params[:app_token].blank?
          return render json: { status: 'ERROR', error: 'Provide app_token' }, status: :unprocessable_entity
        end

        if params[:chat_number].blank?
          return render json: { status: 'ERROR', error: 'Provide chat_number' }, status: :unprocessable_entity
        end

        msg = Message.new
        helper = Helper.new
        app = helper.get_app(params[:app_token])
        return render json: { status: 'ERROR', error: 'Application doesn\'t exist' }, status: :not_found if app.blank?


        chat = Chat.where(number: params[:chat_number], app_id: app[0].id).first
        return render json: { status: 'ERROR', error: 'Chat doesn\'t exist' }, status: :not_found if chat.blank?

        chat.with_lock do

          msg.number = chat.messages_count + 1
          msg.chat_id = chat.id
          msg.body = params[:body]
          if msg.save
            chat.update_column('messages_count', chat.messages_count + 1)
            ActiveRecord::Base.connection.execute('UNLOCK TABLES')
            return render json: { status: 'SUCCESS', message: 'Message Created Successfully', message_number: msg.number }, status: :created
          end
          ActiveRecord::Base.connection.execute('UNLOCK TABLES')
          render json: { status: 'ERROR', message: 'Message not Created', error: msg.errors }, status: :unprocessable_entity
        end
      end

      def update
        return render json: { status: 'ERROR', error: 'Provide app token' }, status: :unprocessable_entity if params[:app_token].blank?

        return render json: { status: 'ERROR', error: 'Provide chat number' }, status: :unprocessable_entity if params[:chat_number].blank?

        helper = Helper.new
        app = helper.get_app params[:app_token]
        return render json: { status: 'ERROR', error: 'Application doesn\'t exist' }, status: :not_found if app.blank?

        chat = helper.get_chat(app[0].id, params[:chat_number])
        return render json: { status: 'ERROR', error: 'Chat doesn\'t exist' }, status: :not_found if chat.blank?

        msg = Message.where(chat_id: chat[0].id, number: params[:id]).first
        return render json: { status: 'ERROR', error: 'Message doesn\'t exist' }, status: :not_found if msg.blank?

        msg.body = params[:body]
        return render json: { status: 'SUCCESS', message: 'Message Updated Successfully' }, status: :ok if msg.save

        render json: { status: 'ERROR', message: 'Message not Updated', error: msg.errors }, status: :unprocessable_entity

      end

    end
  end
end
