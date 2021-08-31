# Class to install and configure grafana_agent.
#
# Use this module to install and configure grafana_agent.
#
# @example Declaring the class
#   include ::grafana_agent
#
# @param archive_source Location of grafana_agent binary release.
# @param group Group that owns grafana_agent files.
# @param install_dir Location of grafana_agent binary release.
# @param install_method How to install grafana_agent.
# @param manage_repo Manage the grafana_agent repo.
# @param manage_service Manage the grafana_agent service.
# @param manage_user Manage grafana_agent user and group.
# @param package_name Name of package to install.
# @param package_version Version of grafana_agent to install.
# @param service_name Name of service to manage.
# @param service_provider Init system that is used.
# @param service_ensure The state of the service.
# @param user User that owns grafana_agent files.
class grafana_agent (
  String[1] $group,
  Stdlib::Absolutepath $install_dir,
  Enum['archive','package'] $install_method ,
  Boolean $manage_repo,
  Boolean $manage_service,
  Boolean $manage_user,
  String[1] $package_name,
  String[1] $package_version,
  String[1] $service_name,
  String[1] $service_provider,
  Enum['running','stopped'] $service_ensure,
  String[1] $user,
  Optional[Stdlib::HTTPUrl] $archive_source = undef,
) {
  anchor { 'grafana_agent::begin': }
  -> class{ '::grafana_agent::install': }
  -> class{ '::grafana_agent::config': }
  ~> class{ '::grafana_agent::service': }
  -> anchor { 'grafana_agent::end': }
}
