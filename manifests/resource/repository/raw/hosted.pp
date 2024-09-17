# @summary
#  Resource to manage raw hosted repository
#
# @param ensure
#   Define if the resource should be created/present or deleted/absent.
# @param online
#   Whether this repository accepts incoming requests.
# @param storage_blob_store_name
#   The name of the blobstore inside of nexus repository manager to be used. We suggest to use a own blobstore for each
#   defined repository.
# @param storage_strict_content_type_validation
#   Whether to validate uploaded content's MIME type appropriate for the repository format.
# @param storage_write_policy
#   Controls if deployments of and updates to assets are allowed.
# @param component_proprietary_components
#   Components in this repository count as proprietary for namespace conflict attacks (requires Sonatype Nexus Firewall).
# @param content_disposition
#   Content Disposition
# @param cleanup_policy_names
#   Apply a list of cleanup policies to the repository. If a cleanup policy doesn't exist, nothing happens.
#
# @example
#   nexus::resource::repository::raw::hosted { 'raw-hosted': }
#
define nexus::resource::repository::raw::hosted (
  Enum['present', 'absent'] $ensure = 'present',
  Boolean $online = true,
  String[1] $storage_blob_store_name = $title,
  Boolean $storage_strict_content_type_validation = true,
  Enum['allow', 'allow_once', 'deny'] $storage_write_policy = 'allow_once',
  Boolean $component_proprietary_components = true,
  Enum['INLINE', 'ATTACHMENT'] $content_disposition = 'ATTACHMENT',
  Array[String[1]] $cleanup_policy_names = [],
) {
  nexus_repository { $title:
    ensure     => $ensure,
    format     => 'raw',
    type       => 'hosted',
    attributes => {
      'online'    => $online,
      'storage'   => {
        'blobStoreName'               => $storage_blob_store_name,
        'strictContentTypeValidation' => $storage_strict_content_type_validation,
        'writePolicy'                 => $storage_write_policy,
      },
      'cleanup'   => {
        'policyNames' => $cleanup_policy_names,
      },
      'component' => {
        'proprietaryComponents' => $component_proprietary_components,
      },
      'raw'       => {
        'contentDisposition' => $content_disposition,
      },
    },
  }
}
