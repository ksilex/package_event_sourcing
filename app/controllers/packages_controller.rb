class PackagesController < ApplicationController
  def create
    current_user.with_lock do
      track_ids = params[:_json]
      track_ids.each do |track_id|
        event_store.publish(PackageRegistered.new(data: { track_id:, user_id: current_user.id }), stream_name: track_id)
      end
    end
  end

  def index
    render json: current_user.packages
  end

  def show
    render json: package.as_json.merge!(events:)
  end

  private

  def events
    event_store.read.stream(package.track_id).to_a
               .reject { |e| e.class.in?([NotificationRequested, UserNotified]) }
               .map { |e| e.as_json.slice('event_id', 'data').merge!(type: e.class.to_s) }
  end

  def package
    @package ||= Package.find(params[:id])
  end
end
