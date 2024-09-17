# @summary Manage the nexus postgresql datastore settings
#
# Only available in Sonatype Nexus Repository Pro
#
class nexus::config::postgresql_datastore {
  assert_private()

  $nexus_store_properties_file = "${nexus::install_root}/nexus-${nexus::version}/etc/fabric/nexus-store.properties"

  # Nexus >=3.x do no necesarily have a properties file in place to
  # modify. Make sure that there is at least a minmal file there
  file { $nexus_store_properties_file:
    ensure => file,
  }

  file_line { 'nexus-postgresql-username':
    path  => $nexus_store_properties_file,
    match => '^username=',
    line  => "username=${nexus::postgresql_username}",
  }

  file_line { 'nexus-postgresql-password':
    path  => $nexus_store_properties_file,
    match => '^password=',
    line  => "password=${nexus::postgresql_password}",
  }

  file_line { 'nexus-postgresql-jdbcurl':
    path  => $nexus_store_properties_file,
    match => '^jdbcUrl=',
    line  => "jdbcUrl=${nexus::postgresql_jdbcurl}",
  }
}
