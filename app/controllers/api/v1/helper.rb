module Api
  module V1
    ##
    # This class has several helper function to be used in retrieving data in Controllers
    class Helper

      def get_app(token)
        (Application.search query: { bool: {
          filter: { term: { token: { value: token } } }
        } }).results
      end

      def get_chat(app_id, chat_number)
        (Chat.search query: { bool: {
          filter: [{ term: { number: { value: chat_number } } }, { term: { app_id: { value: app_id } } }]
        } }).results
      end

      def get_message(chat_id, msg_number)
        (Message.search query: { bool: {
          filter: [{ term: { number: { value: msg_number } } }, { term: { chat_id: { value: chat_id } } }]
        } }).results
      end

    end

  end
end
