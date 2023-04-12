class NotificationRequested < RailsEventStore::Event
  def kafka_format
    { package_id: data[:package_id], notification_enabled: true, notification_mode: data[:enabled] }
    # notification_enabled is always true since no time left to fully implement
  end
end
