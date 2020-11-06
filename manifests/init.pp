#
class profile_docker (
  Hash    $registries                = {},
  Boolean $remove_stopped_containers = true,
) {
  class { 'docker': }

  create_resources('docker::registry', $registries)

  if $remove_stopped_containers {
    cron { 'remove stopped containers, unused volumes, unused networks and dangling images every hour':
      command     => 'docker system prune -f > /dev/null 2>&1',
      user        => 'root',
      hour        => '*/1',
      minute      => 42,
      environment => 'PATH=/bin:/usr/bin',
    }
  }
}
