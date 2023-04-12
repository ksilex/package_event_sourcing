class WebhookController < ApplicationController
  def create
    package.with_lock do
      UpdatePackage.new(webhook_params, event_store).call
    end

    head :ok
  end

  def webhook_params
    params.to_unsafe_hash.merge!(package_id: package.id)
  end

  def package
    @package ||= Package.find_by!(track_id: params[:track_id])
  end
end
