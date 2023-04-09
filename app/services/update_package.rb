class UpdatePackage
  def initialize(params, event_store)
    @params = params
    @event_store = event_store
  end

  def call
    event = case params[:company]
            when 'fast_delivery'
              determine_fast_delivery_event
            when 'happy_package'
              determine_happy_package_event
            end

    status = event == PackageDeliveryFailed ? 'delivery_failed' : params[:status]
    event_store.publish(event.new(data: params.merge!(status:)), stream_name: params[:track_id])
  end

  private

  attr_reader :params, :event_store

  def determine_fast_delivery_event
    case params[:status]
    when 'arrived'
      PackageArrived
    when 'departed'
      PackageDeparted
    when 'delivered'
      params[:state] == 'successful' ? PackageDelivered : PackageDeliveryFailed
    end
  end

  def determine_happy_package_event
    case params[:status]
    when 'arrived'
      PackageArrived
    when 'departed'
      PackageDeparted
    when 'delivered'
      params[:success] ? PackageDelivered : PackageDeliveryFailed
    end
  end
end
