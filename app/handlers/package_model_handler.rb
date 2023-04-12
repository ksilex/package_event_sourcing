class PackageModelHandler
  def call(event)
    package = Package.find_by(track_id: event.data[:track_id])
    return Package.create(event.data) unless package

    package.assign_attributes(format_attributes(event.data))
    package.save!
  end

  private

  def format_attributes(data)
    result = case data[:company]
             when 'fast_delivery'
               format_fast_delivery(data)
             when 'happy_package'
               format_happy_package(data)
             end
    result.merge!(status: data[:status], company: data[:company])
  end

  def format_fast_delivery(data)
    case data[:status]
    when 'arrived', 'departed'
      { location: data[:location], time: data[:time], weight: data[:weight][:value], unit: data[:weight][:unit] }
    when 'delivery_failed', 'delivered'
      { time: data[:time] }
    end
  end

  def format_happy_package(data)
    case data[:status]
    when 'arrived', 'departed'
      { location: { name: data[:location] }, time: data[:time], weight: data[:weight] }
    when 'delivery_failed', 'delivered'
      { time: data[:time] }
    end
  end
end
