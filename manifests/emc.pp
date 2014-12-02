class sensucustom::emc ( 
  $destination = '/etc/sensu/plugins',
  $username    = 'username',
  $password    = 'password',
  $scope       = 1,
) {

  file { "${destination}/check_emc_clariion.pl":
        ensure  => file,
        source  => 'puppet:///modules/sensucustom/sensuscripts/check_emc_clariion.pl',
        owner   => sensu,
        group   => sensu,
        mode    => 0755,
  }->

  file { "${destination}/check_emc_clariion_security_files":
    ensure  => directory,
    owner   => sensu,
    group   => sensu,
    mode    => '0600',
  }->

  exec {'emc_security_file':
    command => "/opt/Navisphere/bin/naviseccli -secfilepath ${destination}/check_emc_clariion_security_files -User ${username} -Password ${password} -Scope ${scope} -AddUserSecurity",
    unless  => "/usr/bin/test -f ${destination}/check_emc_clariion_security_files/SecuredCLISecurityFile.xml",
  }

}


define sensucustom::emc::check ( $ip, $entity, $username, $password  ) {

    sensu::check { "check_emc_faults_${host}":
      command     => "/etc/sensu/plugins/check_emc_clariion.pl -H ${ip} -u ${username} -p ${password} -t faults",
      subscribers => 'remote_emc',
      handlers    => ['flapjack'],
      standalone  =>  false,
      type        => 'metric',
      interval    => '1800',
      custom => {
        source => "${entity}"
      }
    }

    sensu::check { "check_emc_disks_${host}":
      command     => "/etc/sensu/plugins/check_emc_clariion.pl -H ${ip} -u ${username} -p ${password} -t disk",
      subscribers => 'remote_emc',
      handlers    => ['flapjack'],
      standalone  =>  false,
      type        => 'metric',
      interval    => '1800',
      custom => {
        source => "${entity}"
      }
    }

    sensu::check { "check_emc_cache_${host}":
      command     => "/etc/sensu/plugins/check_emc_clariion.pl -H ${ip} -u ${username} -p ${password} -t cache",
      subscribers => 'remote_emc',
      handlers    => ['flapjack'],
      standalone  =>  false,
      type        => 'metric',
      interval    => '1800',
      custom => {
        source => "${entity}"
      }
    }

    sensu::check { "check_emc_cache_${host}":
      command     => "/etc/sensu/plugins/check_emc_clariion.pl -H ${ip} -u ${username} -p ${password} -t cache_pdp",
      subscribers => 'remote_emc',
      handlers    => ['flapjack'],
      standalone  =>  false,
      type        => 'metric',
      interval    => '1800',
      custom => {
        source => "${entity}"
      }
    }


    sensu::check { "check_emc_spA_${host}":
      command     => "/etc/sensu/plugins/check_emc_clariion.pl -H ${ip} -u ${username} -p ${password} -t sp --sp A",
      subscribers => 'remote_emc',
      handlers    => ['flapjack'],
      standalone  =>  false,
      type        => 'metric',
      interval    => '1800',
      custom => {
        source => "${entity}"
      }
    }

    sensu::check { "check_emc_spB_${host}":
      command     => "/etc/sensu/plugins/check_emc_clariion.pl -H ${ip} -u ${username} -p ${password} -t sp --sp B",
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

