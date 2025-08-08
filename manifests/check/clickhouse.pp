#
# Class to enable ClickHouse monitoring
#
class nagios::check::clickhouse (
  Variant[String,Undef] $ensure                   = undef,
  Variant[String,Undef] $args                     = undef,
  Variant[String,Undef] $check_period             = undef,
  Variant[String,Undef] $first_notification_delay = undef,
  Variant[String,Undef] $notification_period      = undef,
  Array[String]         $modes_enabled            = [],
  Array[String]         $modes_disabled           = [],
  String                $plugin                   = 'check_clickhouse',
  # Modes
  String $args_replication_future_parts           = undef,
  String $args_replication_inserts_in_queue       = undef,
  String $args_replication_is_readonly            = undef,
  String $args_replication_is_session_expired     = undef,
  String $args_replication_log_delay              = undef,
  String $args_replication_parts_to_check         = undef,
  String $args_replication_queue_size             = undef,
  String $args_replication_total_replicas         = undef,
  String $args_replication_active_replicas        = undef,
) {

  # Generic overrides
  if $check_period {
    Nagios_service { check_period => $facts['nagios_check_clickhouse_period'] }
  }
  if $first_notification_delay {
    Nagios_service { first_notification_delay => $facts['nagios_check_clickhouse_first_notification_delay'] }
  }
  if $notification_period {
    Nagios_service { notification_period => $facts['nagios_check_clickhouse_notification_period'] }
  }

  nagios::client::nrpe_plugin { 'check_clickhouse':
    ensure => $ensure,
  }

  # Modes-specific definition
  nagios::check::clickhouse::mode { [
      'replication_future_parts',
      'replication_inserts_in_queue',
      'replication_is_readonly',
      'replication_is_session_expired',
      'replication_log_delay',
      'replication_parts_to_check',
      'replication_queue_size',
      'replication_total_replicas',
      'replication_active_replicas',
    ]:
  }

}

