class WebhookController < ApplicationController
  def create
    Package.find_by!(track_id: webhook_params[:track_id]).with_lock do
      UpdatePackage.new(webhook_params, event_store).call
    end

    head :ok
  end

  def webhook_params
    params.to_unsafe_hash
  end
end

# { location: data[:location], time: data[:time], weight: data[:weight][:value], unit: data[:weight][:unit] }
