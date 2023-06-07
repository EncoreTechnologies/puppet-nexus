# @summary Manage the nexus repository manager administrator account
#
# @param username
#   The username of the administrator.
# @param first_name
#   The first name of the administrator.
# @param last_name
#   The last name of the administrator.
# @param email_address
#   The email address of the administrator.
# @param roles
#   The assigned roles of the administrator. It should include 'nx-admin'.
# @param password
#   The password of the administrator. If not given there will be generated a random password.
#
# @example
#   include nexus::config::admin
#
class nexus::config::admin (
  String[1]                                          $username      = $nexus::admin_username,
  String[1]                                          $first_name    = $nexus::admin_firstname,
  String[1]                                          $last_name     = $nexus::admin_lastname,
  String[1]                                          $email_address = $nexus::admin_email,
  Array[String[1]]                                   $roles         = $nexus::admin_roles,
  Optional[Variant[String[1], Sensitive[String[1]]]] $password      = $nexus::admin_password,
) {
  if $password {
    $real_password = $password
  } else {
    $real_password = extlib::cache_data('nexus_cache_data', 'admin_password', extlib::random_password(16))
  }

  nexus_user { $username:
    ensure        => 'present',
    first_name    => $first_name,
    last_name     => $last_name,
    password      => $real_password,
    email_address => $email_address,
    roles         => $roles,
  }
}
