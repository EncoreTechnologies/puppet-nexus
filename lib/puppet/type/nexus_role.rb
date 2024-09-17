# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'nexus_role',
  docs: <<~EOS,
        @summary Manage nexus repository roles
        ```puppet
        nexus_role { 'rolename':
          ensure      => 'present',
          id          => 'reader',
          description => 'read access to raw repository',
          privileges  => ['nx-repository-view-raw-*-read'],
          roles       => '',
        }
        ```
  EOS
  features: [],
  attributes: {
    ensure: {
      type: 'Enum[present, absent]',
      desc: 'Whether this resource should be present or absent on the target system.',
      default: 'present'
    },
    id: {
      type: 'String',
      desc: 'The id of the role',
      behaviour: :namevar
    },
    source: {
      type: 'Optional[String]',
      desc: 'The source of the role. Like local or LDAP'
    },
    name: {
      type: 'Optional[String]',
      desc: 'The name of the role which will be the same like id.',
    },
    description: {
      type: 'Optional[String]',
      desc: 'The description of the role.'
    },
    read_only: {
      type: 'Optional[Boolean]',
      desc: 'Define as read only.'
    },
    privileges: {
      type: 'Optional[Array[String]]',
      desc: 'The privileges the role should have'
    },
    roles: {
      type: 'Optional[Array[String]]',
      desc: 'Other roles the new role should have'
    }
  },
)
