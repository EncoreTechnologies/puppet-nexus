# frozen_string_literal: true

require 'puppet/resource_api/simple_provider'
require 'puppet/util/network_device/config'

# Implementation for the nexus_role type using the Resource API.
class Puppet::Provider::NexusRole::NexusRole < Puppet::ResourceApi::SimpleProvider
  # Init connection to the rest api
  def initialize
    super
    local_device = Puppet::Util::NetworkDevice::Config.devices['localhost_nexus_rest_api']
    config_file = local_device['url'] unless local_device.nil?
    Puppet::ResourceApi::Transport.inject_device('nexus_rest_api', config_file) unless File.exist?(config_file)
  end

  # convert keys of the given hash to snake_case
  def keys_to_snake_case(hash)
    hash.transform_keys do |key|
      key.gsub(%r{([A-Z]+)([A-Z][a-z])}, '\1_\2')
         .gsub(%r{([a-z\d])([A-Z])}, '\1_\2')
         .downcase
         .to_sym
    end
  end

  # convert keys of the given hash to camelCase
  def keys_to_camelcase(hash)
    hash.transform_keys do |key|
      key.to_s
         .gsub(%r{(?:_+)([a-z])}) { Regexp.last_match(1).upcase }
         .gsub(%r{(\A|\s)([A-Z])}) { Regexp.last_match(1) + Regexp.last_match(2).downcase }
         .to_sym
    end
  end

  # Return all existing roles as resources
  def get(context)
    res = context.transport.get_request(context, 'security/roles')
    context.err(res.body) unless res.success?
    Puppet::Util::Json.load(res.body).map do |role|
      keys_to_snake_case(role.merge({ 'ensure' => 'present' }))
    end
  end

  # Creates new role if they not exist yet
  def create(context, name, should)
    should[:name] = name
    res = context.transport.post_request(context, 'security/roles', should)
    context.err(name, res.body) unless res.success?
  end

  # Update already existing role
  def update(context, name, should)
    should[:name] = name
    should[:id] = name
    res = context.transport.put_request(context, "security/roles/#{name}", keys_to_camelcase(should))
    context.err(name, res.body) unless res.success?
  end

  # Delete existing role if they set to absent
  def delete(context, name)
    res = context.transport.delete_request(context, "security/roles/#{name}")
    context.err(name, res.body) unless res.success?
  end
end
