module Api
  module V1
    ##
    # This class has several helper function to be used in retrieving data in Controllers
    class Helper

      def get_app(token)
        unless Application.__elasticsearch__.index_exists?
          Application.__elasticsearch__.create_index!
        end
        (Application.search query: { bool: {
          filter: { term: { token: { value: token } } }
        } }).results
      end

      def get_chat(app_id, chat_number)
        unless Chat.__elasticsearch__.index_exists?
          Chat.__elasticsearch__.create_index!
        end
        (Chat.search query: { bool: {
          filter: [{ term: { number: { value: chat_number } } }, { term: { app_id: { value: app_id } } }]
        } }).results
      end

      def get_message(chat_id, msg_number)
        unless Message.__elasticsearch__.index_exists?
          Message.__elasticsearch__.create_index!
        end
        (Message.search query: { bool: {
          filter: [{ term: { number: { value: msg_number } } }, { term: { chat_id: { value: chat_id } } }]
        } }).results
      end

    end

  end
end
