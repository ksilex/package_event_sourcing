require 'rails_event_store'
require 'aggregate_root'
require 'arkency/command_bus'

class PackageEventStore < RailsEventStore::JSONClient
  def publish(events, stream_name: GLOBAL_STREAM, expected_version: :any, topic: 'packages')
    enriched_events = enrich_events_metadata(events)
    records = transform(enriched_events)
    append_records_to_stream(records, stream_name:, expected_version:)
    enriched_events.zip(records) do |event, record|
      with_metadata(correlation_id: event.metadata.fetch(:correlation_id), causation_id: event.event_id) do
        broker.call(event, record)
        next unless event.respond_to?(:kafka_format)

        Karafka.producer.produce_sync(topic:, payload: event.kafka_format&.to_json)
      end
    end
    self
  end
end

Rails.configuration.to_prepare do
  Rails.configuration.event_store = PackageEventStore.new
  Rails.configuration.command_bus = Arkency::CommandBus.new

  AggregateRoot.configure do |config|
    config.default_event_store = Rails.configuration.event_store
  end

  # Subscribe event handlers below
  Rails.configuration.event_store.tap do |store|
    store.subscribe(PackageModelHandler, to: [PackageRegistered, PackageArrived, PackageDelivered, PackageDeparted, PackageDeliveryFailed])
    store.subscribe(NotificationModelHandler, to: [NotificationRequested])
    store.subscribe(PackageStatusHandler, to: [PackageArrived, PackageDelivered, PackageDeparted, PackageDeliveryFailed])
    store.subscribe(UserNotifiedHandler, to: [UserNotified])
    # store.subscribe(InvoiceReadModel.new, to: [InvoicePrinted])
    # store.subscribe(lambda { |event| SendOrderConfirmation.new.call(event) }, to: [OrderSubmitted])
    # store.subscribe_to_all_events(lambda { |event| Rails.logger.info(event.event_type) })

    store.subscribe_to_all_events(RailsEventStore::LinkByEventType.new)
    store.subscribe_to_all_events(RailsEventStore::LinkByCorrelationId.new)
    store.subscribe_to_all_events(RailsEventStore::LinkByCausationId.new)
  end

  # Register command handlers below
  # Rails.configuration.command_bus.tap do |bus|
  #   bus.register(PrintInvoice, Invoicing::OnPrint.new)
  #   bus.register(SubmitOrder, ->(cmd) { Ordering::OnSubmitOrder.new.call(cmd) })
  # end
end
