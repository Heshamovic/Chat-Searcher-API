Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :applications
      resources :chats
      resources :messages
      resources :chat_search
    end
  end
end
