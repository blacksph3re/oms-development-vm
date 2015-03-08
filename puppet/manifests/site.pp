file { '/etc/ldap/schema/aegee.schema':
  ensure => file,
  mode   => 644,
  owner  => 'root',
  group  => 'root',
  source => '/vagrant/aegee.schema',
  before => Class['ldap::server::master'],
}

class { 'ldap::server::master':
  suffix      => 'dc=aegee,dc=org',
  rootpw      => '{SSHA}o55pAdS3VSTvfd1RPSIEnHM2MvBlQdOt',
  schema_inc  => [ 'aegee' ],
}

class { 'ldap::client':
  uri  => 'ldap://localhost',
  base => 'dc=aegee,dc=org'
}

class { 'phpldapadmin':
  ldap_host      => 'localhost',
  ldap_suffix    => 'dc=aegee,dc=org',
  ldap_bind_id   => 'cn=admin,dc=aegee,dc=org',
  ldap_bind_pass => 'aegee', # TODO: not sure what this means
  require        => Class['ldap::server::master'],
}

include ldap, phpldapadmin