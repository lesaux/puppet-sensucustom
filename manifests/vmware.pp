class sensucustom::vmware (
  $destination = '/etc/sensu/plugins',
  $username = username,
  $password = password,
) {

  ensure_packages(['libnagios-plugin-perl'])

  exec {'cpan_Time_Duration':
    command => '/usr/bin/cpan Time::Duration',
    unless  => '/usr/bin/test -f /sources/authors/id/A/AV/AVIF/Time-Duration-1.1.tar.gz',
  }

  file { "${destination}/check_vmware_esx":
    ensure => file,
    source => 'puppet:///modules/sensucustom/sensuscripts/check_vmware_esx',
    owner  => sensu,
    group  => sensu,
    mode   => '0755',
  }

  file { "${destination}/check_vmware_esx.pl":
    ensure => file,
    source => 'puppet:///modules/sensucustom/sensuscripts/check_vmware_esx.pl',
    owner  => sensu,
    group  => sensu,
    mode   => '0755',
  }

  file { "${destination}/modules":
    ensure  => directory,
    recurse => true,
    source  => 'puppet:///modules/sensucustom/sensuscripts/modules',
    owner   => sensu,
    group   => sensu,
    mode    => '0755',
  }

  file { "${destination}/check_esx3":
    ensure => file,
    source => 'puppet:///modules/sensucustom/sensuscripts/check_esx3',
    owner  => sensu,
    group  => sensu,
    mode   => '0755',
  }

  file { "${destination}/check_vmware_api.pl":
    ensure => file,
    source => 'puppet:///modules/sensucustom/sensuscripts/check_vmware_api.pl',
    owner  => sensu,
    group  => sensu,
    mode   => '0755',
  }

  file { '/var/check-vmware-esx-cache':
    ensure => directory,
    owner  => sensu,
    group  => sensu,
  }

 file { "${destination}/check_vmware_esx_authfile":
    ensure  => file,
    content => template('sensucustom/authfile.erb'),
    owner   => sensu,
    group   => sensu,
  }

}


define sensucustom::vmware::esx-checks ( $vcenter, $esxhost, $entity, $graphite_prefix, $graphite_folder ) {

## you are expected to have a flapjack handler and a nagios perfdata to graphite metrics handler
## $vcenter: ip address or resolvable hostname of the vcenter
## $esxhost: ESX hostname as it shows in vcenter
## $esxip: ESX host ip address in case it is not resolvable
## $entity: name of the server as it should show up in flapjack
## $graphite_prefix: graphite prefix folder in which the host will show
## $graphite_folder: graphite folder of the host

  sensu::check { "check_esx_ping_${entity}":
    command     => "/etc/sensu/plugins/check-ping.rb -h ${esxhost} -c 10 -C 0.8 -W 0.9 -i 1 -T 5",
    handlers    => ['flapjack'],
    subscribers => ['esx'],
    standalone  =>  false,
    type        => 'metric',
    interval    => 30,
    custom      => {
      source => $entity,
      tags   => ['pythian_oncall'],
    }
  }
##HARDWARE CHECKS
  #sensu::check { "check_esx_hardware_health_${entity}":
  #  command     => "/etc/sensu/plugins/check_vmware_esx -f /etc/sensu/plugins/check_vmware_esx_authfile -H ${esxhost} -S runtime -s health",
  #  #handlers    => ['flapjack'],
  #  subscribers => 'esx',
  #  standalone  =>  false,
  #  type        => 'metric',
  #  interval    => '120',
  #  custom => {
  #    source => "${entity}"
  #  }
  #}
##CPU CHECKS
  sensu::check { "check_esx_cpu_percent_${entity}":
    #command     => "/etc/sensu/plugins/check_vmware_api.pl --sessionfile /tmp/vmware-api-session -f /etc/sensu/plugins/check_vmware_esx_authfile -D ${vcenter} -H ${esxhost} -l CPU -s usage",
    command     => "/etc/sensu/plugins/check_vmware_esx.pl -f /etc/sensu/plugins/check_vmware_esx_authfile -D ${vcenter} -H ${esxhost} --select=cpu",
    handlers    => ['flapjack','graphite_custom'],
    subscribers => 'esx',
    standalone  =>  false,
    type        => 'metric',
    interval    => '30',
    custom      => {
      source               => $entity,
      graphite_metric_path => "${graphite_prefix}.${graphite_folder}.cpu"
    }
  }
  #sensu::check { "check_esx_cpu_mhz_${entity}":
  #  command     => "/etc/sensu/plugins/check_vmware_api.pl --sessionfile /tmp/vmware-api-session -f /etc/sensu/plugins/check_vmware_esx_authfile -D ${vcenter} -H ${esxhost} -l CPU -s usagemhz",
  #  handlers    => ['flapjack','graphite_custom'],
  #  subscribers => 'esx',
  #  standalone  =>  false,
  #  type        => 'metric',
  #  interval    => '120',
  #  custom      => {
  #    source               => "${entity}",
  #    graphite_metric_path => "${graphite_prefix}.${graphite_folder}.cpu"
  #  }
  #}
##MEMORY CHECKS
  sensu::check { "check_esx_mem_percent_${entity}":
    #command     => "/etc/sensu/plugins/check_vmware_api.pl --sessionfile /tmp/vmware-api-session -f /etc/sensu/plugins/check_vmware_esx_authfile -D ${vcenter} -H ${esxhost} -l MEM -s usage",
    command     => "/etc/sensu/plugins/check_vmware_esx.pl -f /etc/sensu/plugins/check_vmware_esx_authfile -D ${vcenter} -H ${esxhost} --select=mem",
    handlers    => ['flapjack','graphite_custom'],
    subscribers => 'esx',
    standalone  =>  false,
    type        => 'metric',
    interval    => '30',
    custom      => {
      source               => "${entity}",
      graphite_metric_path => "${graphite_prefix}.${graphite_folder}.mem"
    }
  }
  #sensu::check { "check_esx_mem_MB_${entity}":
  #  command     => "/etc/sensu/plugins/check_vmware_api.pl --sessionfile /tmp/vmware-api-session -f /etc/sensu/plugins/check_vmware_esx_authfile -D ${vcenter} -H ${esxhost} -l MEM -s usagemb",
  #  handlers    => ['flapjack','graphite_custom'],
  #  subscribers => 'esx',
  #  standalone  =>  false,
  #  type        => 'metric',
  #  interval    => '120',
  #  custom      => {
  #    source               => "${entity}",
  #    graphite_metric_path => "${graphite_prefix}.${graphite_folder}.mem"
  #  }
  #}
  #sensu::check { "check_esx_mem_swap_${entity}":
  #  command     => "/etc/sensu/plugins/check_vmware_api.pl --sessionfile /tmp/vmware-api-session -f /etc/sensu/plugins/check_vmware_esx_authfile -D ${vcenter} -H ${esxhost} -l MEM -s swap",
  #  handlers    => ['flapjack','graphite_custom'],
  #  subscribers => 'esx',
  #  standalone  =>  false,
  #  type        => 'metric',
  #  interval    => '120',
  #  custom      => {
  #    source               => "${entity}",
  #    graphite_metric_path => "${graphite_prefix}.${graphite_folder}.mem"
  #  }
  #}
  #sensu::check { "check_esx_mem_overhead_${entity}":
  #  command     => "/etc/sensu/plugins/check_vmware_api.pl --sessionfile /tmp/vmware-api-session -f /etc/sensu/plugins/check_vmware_esx_authfile -D ${vcenter} -H ${esxhost} -l MEM -s overhead",
  #  handlers    => ['flapjack','graphite_custom'],
  #  subscribers => 'esx',
  #  standalone  =>  false,
  #  type        => 'metric',
  #  interval    => '120',
  #  custom      => {
  #    source               => "${entity}",
  #    graphite_metric_path => "${graphite_prefix}.${graphite_folder}.mem"
  #  }
  #}
##NETWORK CHECKS
  sensu::check { "check_esx_net_overall_${entity}":
    #command     => "/etc/sensu/plugins/check_vmware_api.pl --sessionfile /tmp/vmware-api-session -f /etc/sensu/plugins/check_vmware_esx_authfile -D ${vcenter} -H ${esxhost} -l NET -s usage",
    command     => "/etc/sensu/plugins/check_vmware_esx.pl -f /etc/sensu/plugins/check_vmware_esx_authfile -D ${vcenter} -H ${esxhost} --select=net",
    handlers    => ['flapjack','graphite_custom'],
    subscribers => 'esx',
    standalone  =>  false,
    type        => 'metric',
    interval    => '30',
    custom      => {
      source               => "${entity}",
      graphite_metric_path => "${graphite_prefix}.${graphite_folder}.net"
    }
  }
  #sensu::check { "check_esx_net_receive_${entity}":
  #  command     => "/etc/sensu/plugins/check_vmware_api.pl --sessionfile /tmp/vmware-api-session -f /etc/sensu/plugins/check_vmware_esx_authfile -D ${vcenter} -H ${esxhost} -l NET -s receive",
  #  handlers    => ['flapjack','graphite_custom'],
  #  subscribers => 'esx',
  #  standalone  =>  false,
  #  type        => 'metric',
  #  interval    => '120',
  #  custom      => {
  #    source               => "${entity}",
  #    graphite_metric_path => "${graphite_prefix}.${graphite_folder}.net"
  #  }
  #}
  #sensu::check { "check_esx_net_send_${entity}":
  #  command     => "/etc/sensu/plugins/check_vmware_api.pl --sessionfile /tmp/vmware-api-session -f /etc/sensu/plugins/check_vmware_esx_authfile -D ${vcenter} -H ${esxhost} -l NET -s send",
  #  handlers    => ['flapjack','graphite_custom'],
  #  subscribers => 'esx',
  #  standalone  =>  false,
  #  type        => 'metric',
  #  interval    => '120',
  #  custom      => {
  #    source               => "${entity}",
  #    graphite_metric_path => "${graphite_prefix}.${graphite_folder}.net"
  #  }
  #}
##IO CHECKS
  sensu::check { "check_esx_io_read_${entity}":
    #command     => "/etc/sensu/plugins/check_vmware_api.pl --sessionfile /tmp/vmware-api-session -f /etc/sensu/plugins/check_vmware_esx_authfile -D ${vcenter} -H ${esxhost} -l IO -s read",
    command     => "/etc/sensu/plugins/check_vmware_esx.pl -f /etc/sensu/plugins/check_vmware_esx_authfile -D ${vcenter} -H ${esxhost} --select=io",
    handlers    => ['flapjack','graphite_custom'],
    subscribers => 'esx',
    standalone  =>  false,
    type        => 'metric',
    interval    => '30',
    custom      => {
      source               => "${entity}",
      graphite_metric_path => "${graphite_prefix}.${graphite_folder}.io"
    }
  }
  #sensu::check { "check_esx_io_write_${entity}":
  #  command     => "/etc/sensu/plugins/check_vmware_api.pl --sessionfile /tmp/vmware-api-session -f /etc/sensu/plugins/check_vmware_esx_authfile -D ${vcenter} -H ${esxhost} -l IO -s write",
  #  handlers    => ['flapjack','graphite_custom'],
  #  subscribers => 'esx',
  #  standalone  =>  false,
  #  type        => 'metric',
  #  interval    => '120',
  #  custom      => {
  #    source               => "${entity}",
  #    graphite_metric_path => "${graphite_prefix}.${graphite_folder}.io"
  #  }
  #}

}

define sensucustom::vmware::datastore-checks ( $vcenter, $entity, $graphite_prefix, $graphite_folder ) {
  sensu::check { "check_vcenter_datastores_$entity":
    #command     => "/etc/sensu/plugins/check_vmware_esx -f /etc/sensu/plugins/check_vmware_esx_authfile -D ${vcenter} -S volumes",
    command     => "/etc/sensu/plugins/check_vmware_esx.pl -f /etc/sensu/plugins/check_vmware_esx_authfile -D ${vcenter} --select=volumes",
    handlers    => ['flapjack','graphite_custom'],
    subscribers => 'esx',
    standalone  =>  false,
    type        => 'metric',
    interval    => '30',
    custom      => {
      source               => "${entity}",
      graphite_metric_path => "${graphite_prefix}.${graphite_folder}.datastores"
    }
  }
}
