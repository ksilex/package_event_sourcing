class NotificationModelHandler
  def call(event)
    Notification.create(event.data)
  end
end
