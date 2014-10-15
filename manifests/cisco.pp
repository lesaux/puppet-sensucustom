class sensucustom::cisco (

$destination = '/etc/sensu/plugins',

) {

  ensure_packages(['snmp-mibs-downloader','snmp'])


  file { "${destination}/check_snmp_cisco.pl":
        ensure  => file,
        source  => 'puppet:///modules/sensucustom/check_snmp_cisco.pl',
        owner   => sensu,
        group   => sensu,
        mode    => 0755,
  }

  file { '/var/nagios_plugin_cache':
        ensure  => directory,
        mode    => 0777,
  }


}


define sensucustom::cisco::check-interface ( $community, $ip, $interface, $interfacename, $host ) {
    sensu::check { "check_cisco_interfaces_${host}_${interfacename}":
    command     => "/etc/sensu/plugins/check_snmp_cisco.pl -H ${ip} -C ${community} -I ${interface}",
    subscribers => 'cisco',
    standalone  =>  false,
    type        => 'metric',
    interval    => '180',
    custom => {
      source => "${host}"
    }
  }
}
