class UserNotifiedHandler
  def call(event)
    notification = Notification.find(event.data[:notfication_id])
    case notification.enabled
    when 'phone'
      PhoneNotification.new(track_id: notification.package.track_id, status: event.data[:status]).call
    when 'email'
      EmailNotification.new(track_id: notification.package.track_id, status: event.data[:status]).call
    end
  end
end
