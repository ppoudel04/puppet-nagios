class nagios::check::mysql_health (
  $args                     = undef,
  $check_period             = undef,
  $first_notification_delay = undef,
  $notification_period      = undef,
  $modes_enabled            = [],
  $modes_disabled           = [],
  $pkg                      = true,
  $ensure                   = undef,
  # Modes
  $args_connection_time          = undef,
  $args_uptime                   = undef,
  $args_threads_connected        = undef,
  $args_threadcache_hitrate      = undef,
  $args_querycache_hitrate       = undef,
  $args_querycache_lowmem_prunes = undef,
  $args_keycache_hitrate         = undef,
  $args_bufferpool_hitrate       = undef,
  $args_bufferpool_wait_free     = undef,
  $args_log_waits                = undef,
  $args_tablecache_hitrate       = undef,
  $args_table_lock_contention    = undef,
  $args_index_usage              = undef,
  $args_tmp_disk_tables          = undef,
  $args_slow_queries             = undef,
  $args_slave_lag                = undef,
  $args_slave_io_running         = undef,
  $args_slave_sql_running        = undef,
  $args_open_files               = undef,
) {

  # Generic overrides
  if $check_period {
    Nagios_service { check_period => $facts['nagios_check_mysql_health_check_period'] }
  }
  if $first_notification_delay {
    Nagios_service { first_notification_delay => $facts['nagios_check_mysql_health_first_notification_delay'] }
  }
  if $notification_period {
    Nagios_service { notification_period => $facts['nagios_check_mysql_health_notification_period'] }
  }

  # Optional package containing the script
  if $pkg {
    $pkgname = $facts['os']['name'] ? {
      'Gentoo' => 'net-analyzer/nagios-check_mysql_health',
      default  => 'nagios-plugins-mysql_health',
    }
    $pkgensure = $ensure ? {
      'absent' => 'absent',
      default  => 'installed',
    }
    package { $pkgname: ensure => $pkgensure }
  }

  Package <| tag == 'nagios-plugins-perl' |>

  nagios::check::mysql_health::mode { [
      'connection-time',
      'uptime',
      'threads-connected',
      'threadcache-hitrate',
      'querycache-hitrate',
      'querycache-lowmem-prunes',
      'keycache-hitrate',
      'bufferpool-hitrate',
      'bufferpool-wait-free',
      'log-waits',
      'tablecache-hitrate',
      'table-lock-contention',
      'index-usage',
      'tmp-disk-tables',
      'slow-queries',
      'slave-lag',
      'slave-io-running',
      'slave-sql-running',
      'open-files',
    ]:
  }

}

