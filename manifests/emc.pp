class sensucustom::emc (

$destination = '/etc/sensu/plugins',

) {

  file { "${destination}/check_emc_clariion.pl":
        ensure  => file,
        source  => 'puppet:///modules/sensucustom/sensuscripts/check_emc_clariion.pl',
        owner   => sensu,
        group   => sensu,
        mode    => 0755,
  }

}


define sensucustom::emc::check ( $ip, $entity, $username, $password  ) {

    sensu::check { "check_emc_sp_${host}":
      command     => "/etc/sensu/plugins/check_emc_clariion.pl -H ${ip} -u ${username} -p ${password} -t sp",
      subscribers => 'remote_emc',
      handlers    => ['flapjack'],
      standalone  =>  false,
      type        => 'metric',
      interval    => '1800',
      custom => {
        source => "${entity}"
      }
    }
}

