#
#
#
class profile_docker::firewall {
  firewallchain { 'DOCKER-USER:filter:IPv4':
    purge => false,
  }
  firewallchain { 'DOCKER:filter:IPv4':
    purge => false,
  }
  firewallchain { 'DOCKER-ISOLATION-STAGE-1:filter:IPv4':
    purge => false,
  }
  firewallchain { 'DOCKER-ISOLATION-STAGE-2:filter:IPv4':
    purge => false,
  }
  firewallchain { 'DOCKER:nat:IPv4':
    purge => false,
  }
}
