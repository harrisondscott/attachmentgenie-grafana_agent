# Class to install grafana_agent.
#
# @api private
class grafana_agent::install {
  if $::grafana_agent::manage_user {
    user { 'grafana_agent':
      ensure => present,
      home   => $::grafana_agent::install_dir,
      name   => $::grafana_agent::user,
    }
    group { 'grafana_agent':
      ensure => present,
      name   => $::grafana_agent::group
    }
  }
  case $::grafana_agent::install_method {
    'package': {
      if $::grafana_agent::manage_repo {
        class { 'grafana_agent::repo': }
      }
      package { 'grafana_agent':
        ensure => $::grafana_agent::package_version,
        name   => $::grafana_agent::package_name,
      }
    }
    'archive': {
      file { 'grafana_agent install dir':
        ensure => directory,
        group  => $::grafana_agent::group,
        owner  => $::grafana_agent::user,
        path   => $::grafana_agent::install_dir,
      }
      if $::grafana_agent::manage_user {
        File[$::grafana_agent::install_dir] {
          require => [Group['grafana_agent'],User['grafana_agent']],
        }
      }

      archive { 'grafana_agent archive':
        cleanup      => true,
        creates      => "${::grafana_agent::install_dir}/grafana_agent",
        extract      => true,
        extract_path => $::grafana_agent::install_dir,
        group        => $::grafana_agent::group,
        path         => '/tmp/grafana_agent.tar.gz',
        source       => $::grafana_agent::archive_source,
        user         => $::grafana_agent::user,
        require      => File['grafana_agent install dir']
      }

    }
    default: {
      fail("Installation method ${::grafana_agent::install_method} not supported")
    }
  }
}
