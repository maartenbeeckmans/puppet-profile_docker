#
#
#
class profile_docker::firewall {
  Firewallchain {
    ensure => 'present',
    purge  => false,
  }

  firewallchain { 'DOCKER:filter:IPv4': }
  firewallchain { 'DOCKER-ISOLATION:filter:IPv4': }
  firewallchain { 'DOCKER:nat:IPv4': }

  Firewall {
    ensure => 'present',
    proto  => 'all',
    chain  => 'FORWARD',
  }

  firewall { '00000 docker isolation':
    jump => 'DOCKER-ISOLATION',
  }

  firewall { '00001 docker chain':
    jump     => 'DOCKER',
    outiface => 'docker0',
  }

  firewall { '00002 related established':
    ctstate  => [
      'RELATED',
      'ESTABLISHED',
    ],
    action   => 'accept',
    outiface => 'docker0',
  }

  firewall { '00003 docker outgoing':
    iniface  => 'docker0',
    outiface => '! docker0',
    action   => 'accept',
  }

  firewall { '00004 docker intervm':
    iniface  => 'docker0',
    outiface => 'docker0',
    action   => 'accept',
  }

  firewall { '00000 docker isolation return':
    chain => 'DOCKER-ISOLATION',
    jump  => 'RETURN',
  }

  firewall { '00000 docker nat return':
    chain => 'DOCKER',
    table => 'nat',
    jump  => 'RETURN',
  }

  firewall { '00000 docker preroute match':
    chain    => 'PREROUTING',
    table    => 'nat',
    dst_type => 'LOCAL',
    jump     => 'DOCKER',
  }

  firewall { '00000 docker output match':
    chain       => 'OUTPUT',
    table       => 'nat',
    destination => '! 127.0.0.0/8',
    dst_type    => 'LOCAL',
    jump        => 'DOCKER',
  }

  firewall { '00000 docker masquerade':
    chain    => 'POSTROUTING',
    table    => 'nat',
    source   => '172.17.0.0/16',
    outiface => '! docker0',
    jump     => 'MASQUERADE',
  }

}
