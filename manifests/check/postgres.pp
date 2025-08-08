class nagios::check::postgres (
  $args                     = undef,
  $check_period             = undef,
  $first_notification_delay = undef,
  $notification_period      = undef,
  $modes_enabled            = [],
  $modes_disabled           = [],
  $pkg                      = true,
  $ensure                   = undef,
  $standby_mode             = false,
  $privileged_user          = 'postgres',
  $plugin                   = 'check_postgres',
  $custom_queries           = {},
  # Modes
  $args_archive_ready       = undef,
  $args_autovac_freeze      = undef,
  $args_backends            = undef,
  $args_bloat               = undef,
  $args_checkpoint          = '-w 300',
  $args_cluster_id          = undef,
  $args_commitratio         = undef,
  $args_connection          = undef,
  $args_database_size       = '-w 1t',
  $args_disabled_triggers   = undef,
  $args_disk_space          = undef,
  $args_fsm_pages           = undef,
  $args_fsm_relations       = undef,
  $args_hitratio            = undef,
  $args_hot_standby_delay   = '-w 10m',
  $args_last_analyze        = undef,
  $args_last_vacuum         = undef,
  $args_last_autoanalyze    = undef,
  $args_last_autovacuum     = undef,
  $args_listener            = undef,
  $args_locks               = undef,
  $args_logfile             = undef,
  $args_new_version_bc      = undef,
  $args_new_version_box     = undef,
  $args_new_version_tnm     = undef,
  $args_pgb_pool_cl_active  = '--port=6432',
  $args_pgb_pool_cl_waiting = '--port=6432',
  $args_pgb_pool_sv_active  = '--port=6432',
  $args_pgb_pool_sv_idle    = '--port=6432',
  $args_pgb_pool_sv_used    = '--port=6432',
  $args_pgb_pool_sv_tested  = '--port=6432',
  $args_pgb_pool_sv_login   = '--port=6432',
  $args_pgb_pool_maxwait    = '--port=6432',
  $args_pgbouncer_backends  = '--port=6432',
  $args_pgbouncer_checksum  = undef,
  $args_pgagent_jobs        = undef,
  $args_prepared_txns       = undef,
  $args_query_time          = '-w 2m',
  $args_same_schema         = undef,
  $args_sequence            = undef,
  $args_settings_checksum   = undef,
  $args_slony_status        = undef,
  $args_txn_idle            = '-w 15s -c 1m',
  $args_txn_time            = '-w 5m -c 10m',
  $args_txn_wraparound      = undef,
  $args_version             = undef,
  $args_wal_files           = undef,
) {

  # Generic overrides
  if $check_period {
    Nagios_service { check_period => $facts['nagios_check_postgres_period'] }
  }
  if $first_notification_delay {
    Nagios_service { first_notification_delay => $facts['nagios_check_postgres_first_notification_delay'] }
  }
  if $notification_period {
    Nagios_service { notification_period => $facts['nagios_check_postgres_notification_period'] }
  }

  # Disable pgbouncer modes when pgboucer is not detected
  if $modes_enabled == [] and ! getvar('::nagios_postgres_pgbouncer') {
    $modes_pgbouncer = [
      'pgb_pool_cl_active',
      'pgb_pool_cl_waiting',
      'pgb_pool_sv_active',
      'pgb_pool_sv_idle',
      'pgb_pool_sv_used',
      'pgb_pool_sv_tested',
      'pgb_pool_sv_login',
      'pgb_pool_maxwait',
      'pgbouncer_backends',
      'pgbouncer_checksum',
    ]
    $modes_disabled_final = concat($modes_disabled, $modes_pgbouncer)
  } else {
    $modes_disabled_final = $modes_disabled
  }

  # The check is being executed via sudo
  file { '/etc/sudoers.d/nagios_check_postgres':
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    # We customize the user, the nagios plugin dir and few other things
    content => template('nagios/plugins/check_postgres-sudoers.erb'),
  }

  # Optional package containing the script
  if $pkg {
    $pkgname = 'nagios-plugins-postgres'
    $pkgensure = $ensure ? {
      'absent' => 'absent',
      default  => 'installed',
    }
    package { $pkgname: ensure => $pkgensure }
  }

  Package <| tag == 'nagios-plugins-perl' |>

  # Modes-specific definition
  nagios::check::postgres::mode { [
      'archive_ready',
      'autovac_freeze',
      'backends',
      'bloat',
      'checkpoint',
      'cluster_id',
      'commitratio',
      'connection',
      'database_size',
      'disabled_triggers',
      'disk_space',
      'fsm_pages',
      'fsm_relations',
      'hitratio',
      'hot_standby_delay',
      'last_analyze',
      'last_vacuum',
      'last_autoanalyze',
      'last_autovacuum',
      'listener',
      'locks',
      'logfile',
      'new_version_bc',
      'new_version_box',
      'new_version_cp',
      'new_version_pg',
      'new_version_tnm',
      'pgb_pool_cl_active',
      'pgb_pool_cl_waiting',
      'pgb_pool_sv_active',
      'pgb_pool_sv_idle',
      'pgb_pool_sv_used',
      'pgb_pool_sv_tested',
      'pgb_pool_sv_login',
      'pgb_pool_maxwait',
      'pgbouncer_backends',
      'pgbouncer_checksum',
      'pgagent_jobs',
      'prepared_txns',
      'query_time',
      'same_schema',
      'sequence',
      'settings_checksum',
      'slony_status',
      'txn_idle',
      'txn_time',
      'txn_wraparound',
      'version',
      'wal_files',
    ]:
  }

  # Custom queries
  $allkeys = keys($custom_queries)
  nagios::check::postgres::custom_query { $allkeys: }
}

