#
class profile_docker (
  Hash    $images                    = {},
  Hash    $containers                = {},
  Hash    $networks                  = {},
  Hash    $volumes                   = {},
  Hash    $registries                = {},
  String  $version                   = 'latest',
  Boolean $remove_stopped_containers = true,
  Boolean $manage_firewall_entry     = true,
) {
  class { 'docker':
    version => 'latest',
  }

  if $remove_stopped_containers {
    cron { 'remove stopped containers, unused volumes, unused networks and dangling images every hour':
      command     => 'docker system prune -f > /dev/null 2>&1',
      user        => 'root',
      hour        => '*/1',
      minute      => 42,
      environment => 'PATH=/bin:/usr/bin',
    }
  }

  docker::plugin { 'grafana/loki-docker-driver:latest':
    enabled               => true,
    grant_all_permissions => true,
    plugin_alias          => 'loki',
  }

  group { 'docker':
    ensure => present,
  }

  if $manage_firewall_entry {
    include profile_docker::firewall
  }
  create_resources('docker::images', $images)
  create_resources('docker::run', $containers)
  create_resources('docker_network', $networks)
  create_resources('docker_volume', $volumes)
  create_resources('docker::registry', $registries)
}
