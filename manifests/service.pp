# @summary
#   Maintains the Nexus service
#
# @api private
#
class nexus::service {
  assert_private()

  $install_dir     = "${nexus::install_root}/nexus-${nexus::version}"

  file { '/lib/systemd/system/nexus.service':
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('nexus/nexus.systemd.erb'),
  }
  -> service { 'nexus':
    ensure => running,
    name   => 'nexus',
    enable => true,
  }
}
