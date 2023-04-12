class PackageDeparted < RailsEventStore::Event
  def kafka_format
    { package_id: data[:package_id], location_name: data[:location].instance_of?(Hash) ? data[:location][:name] : data[:location] }
  end
end
