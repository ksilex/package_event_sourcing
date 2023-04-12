class NotificationsController < ApplicationController
  def create
    package.with_lock do
      event_store.publish(
        NotificationRequested.new(
          data: notification_params.merge!(package_id: package.id)
        ),
        stream_name: package.track_id
      )
    end
  end

  def index
    render json: package.notification
  end

  def package
    @package ||= Package.find_by(track_id: params[:package_id])
  end

  def notification_params
    params.permit(:phone, :email, :enabled).to_h
  end
end
