Ksql.configure do |config|
  config.host = 'http://ksqldb-server:8088'
end
# Ksql::Client.ksql(
#   "CREATE source stream package_location_changes
#   (
#     package_id VARCHAR,
#     location_name VARCHAR
#   )
#   with (kafka_topic = 'packages', value_format = 'json');"
# )
# Ksql::Client.ksql(
#   "CREATE source stream package_notification_changes
#   (
#     package_id VARCHAR,
#     notification_enabled BOOLEAN,
#     notification_mode VARCHAR
#   )
# with (kafka_topic = 'packages', value_format = 'json');"
# )
# Ksql::Client.ksql(
#   "CREATE table package_locations as
#   select package_id as id, latest_by_offset(location_name) as name
#   from package_location_changes group by package_id emit changes;"
# )
# Ksql::Client.ksql(
#   "CREATE table package_notification_settings as
#   select package_id as id, latest_by_offset(notification_enabled) as enabled, latest_by_offset(notification_mode) as mode
#   from package_notification_changes group by package_id emit changes;"
# )
