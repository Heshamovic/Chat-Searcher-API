module Api
  module V1
    class ChatSearchController < ApplicationController
      def index
        helper = Helper.new
        app = helper.get_app(params[:app_token])
        return render json: { status: 'ERROR', message: 'Application Not Found' }, status: :not_found if app.blank?

        chat = helper.get_chat(app[0].id, params[:chat_number])
        return render json: { status: 'ERROR', message: 'Chat Not Found' }, status: :not_found if chat.blank?

        msgs_found = (Message.search query: {
          bool: {
            must: {
              match_phrase: {
                body: params[:search_text]
              }
            },
            filter: {
              term: { chat_id: chat[0].id }
            }
          }
        }, fields: %w[chat_id body number]).results

        return render json: { status: 'SUCCESS', message: 'No Messages matched'}, status: :not_found if msgs_found.blank?

        render json: { status: 'SUCCESS', msgs_found: Hash[ *msgs_found.collect { |v| [v.number, v.body] }.flatten] }, status: :ok
      end
    end
  end
end
