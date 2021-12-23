module Api
  module V1
    class ApplicationsController < ApplicationController
      def show
        app = Application.where(token: params[:id]).first
        return render json: { status: 'ERROR', error: 'Application doesn\'t exist' }, status: :not_found if app.blank?

        render json: { status: 'SUCCESS', application: { name: app.name, chats_count: app.chats_count } }, status: :ok
      end

      def create
        return render json: { status: 'ERROR', error: 'Provide Application name' }, status: :unprocessable_entity if params[:name].blank?

        app = Application.new
        app.token = Digest::MD5.hexdigest(params[:name] + Time.now.getutc.to_s)
        app.name = params[:name]
        return render json: {status: 'SUCCESS', message: 'Application Created Successfully', app_token: app.token}, status: :created if app.save

        render json: {status: 'ERROR', message: 'Application not Created', data: app.errors }, status: :unprocessable_entity
      end

      def update
        return render json: { status: 'ERROR', error: 'Provide Application name' }, status: :unprocessable_entity if params[:name].blank?

        app = Application.where(token: params[:id]).first
        return render json: { status: 'ERROR', error: 'Application doesn\'t exist' }, status: :not_found if app.blank?

        app.name = params[:name]
        return render json: { status: 'SUCCESS', message: 'Application Updated Successfully' }, status: :reset_content if app.save

        render json: { status: 'ERROR', message: 'Application not Updated', error: msg.errors }, status: :unprocessable_entity
      end

    end
  end
end
