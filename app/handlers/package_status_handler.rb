class PackageStatusHandler
  def call(event)
    package = Package.find_by!(track_id: event.data[:track_id])

    notfication = package.notification
    return unless notfication

    Rails.configuration.event_store.publish(
      UserNotified.new(data: { status: event.data[:status], notfication_id: notfication.id }),
      stream_name: event.data[:track_id]
    )
  end
end
