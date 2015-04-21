class sensucustom::hpilo (
  $destination = '/etc/sensu/plugins',
) {

case $::osfamily {
  'redhat': {
    ensure_packages(['nagios-plugins-perl']),
    ensure_packages(['perl-XML-Simple']),
    ensure_packages(['perl-IO-Socket-SSL']),
  }
  'debian': {
    ensure_packages(['libnagios-plugin-perl']),
    ensure_packages(['libxml-simple-perl']),
    ensure_packages(['libio-socket-ssl-perl']),
  }
}

  file { "${destination}/check_ilo2_health.pl":
    ensure => file,
    source => 'puppet:///modules/sensucustom/sensuscripts/check_ilo2_health.pl',
    owner  => sensu,
    group  => sensu,
    mode   => '0755',
  }

}

define sensucustom::hpilo::ilocheck ($host, $username, $password, $timeout) {
  sensu::check { "check_hp_ilo_${entity}":
    command     => "/etc/sensu/plugins/check_ilo2_health.pl -3 -t ${timeout} \
                   -H ${host} -u ${username} -p ${password}",
    handlers    => ['flapjack'],
    subscribers => ['remote_ilo'],
    standalone  =>  false,
    interval    => 180,
    custom      => {
      source => $entity,
      tags   => ['pythian_oncall'],
    }
  }
}
