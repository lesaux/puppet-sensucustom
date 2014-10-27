class sensucustom::checks::linux-local {

  sensu::check { 'check_cpu':
    command     => '/etc/sensu/plugins/check-cpu.rb',
    interval    => 60,
    subscribers => 'linux_local',
    standalone  =>  false,
    type        => 'metric',
  }
  sensu::check { 'check_cpu_iowait':
    command     => '/etc/sensu/plugins/check-cpu.rb --iowait',
    interval    => 60,
    subscribers => 'linux_local',
    standalone  =>  false,
    type        => 'metric',
  }
  sensu::check { 'check_cpu_steal':
    command     => '/etc/sensu/plugins/check-cpu.rb --steal',
    interval    => 60,
    subscribers => 'linux_local',
    standalone  =>  false,
    type        => 'metric',
  }
  sensu::check { 'check_load':
    command     => '/etc/sensu/plugins/check-load.rb',
    interval    => 60,
    subscribers => 'linux_local',
    standalone  =>  false,
    type        => 'metric',
  }
  sensu::check { 'check_disk':
    command     => '/etc/sensu/plugins/check-disk.rb',
    interval    => 60,
    subscribers => 'linux_local',
    standalone  =>  false,
    type        => 'metric',
  }
  sensu::check { 'check_fstab':
    command     => '/etc/sensu/plugins/check-fstab-mounts.rb',
    interval    => 60,
    subscribers => 'linux_local',
    standalone  =>  false,
    type        => 'metric',
  }
  sensu::check { 'check_ntp':
    command     => '/etc/sensu/plugins/check-ntp.rb',
    interval    => 60,
    subscribers => 'linux_local',
    standalone  =>  false,
    type        => 'metric',
  }
  sensu::check { 'check_swap_percentage':
    command     => '/etc/sensu/plugins/check-swap-percentage.sh -w 5 -c 15',
    interval    => 60,
    subscribers => 'linux_local',
    standalone  =>  false,
    type        => 'metric',
  }
  sensu::check { 'check_memory_percentage':
    command     => '/etc/sensu/plugins/check-memory-pcnt.sh -w 90 -c 95',
    interval    => 60,
    subscribers => 'linux_local',
    standalone  =>  false,
    type        => 'metric',
  }
  sensu::check { 'check_socket_state_metrics':
    command     => '/etc/sensu/plugins/check-netstat-tcp.rb --states ESTABLISHED,CLOSE_WAIT --warning 500,60 --critical 1000,60',
    interval    => 60,
    subscribers => 'linux_local',
    standalone  =>  false,
    type        => 'metric',
  }

}
