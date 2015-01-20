define sensucustom::subscriptions::linux-graphite ( $graphite_host, $graphite_prefix, $subscription ) {

## $graphite_host: address of the graphite host
## $graphite_prefix: graphite prefix folder in which the host will show
## $subscribtion: name of the subscription


  sensu::check { "check_graphite_cpu_iowait_${subscription}":
    command     => "/etc/sensu/plugins/check-data.rb -a 120 -s ${graphite_host} -t $graphite_prefix.`hostname -s`.cpu.total.iowait -w :::params.graphite.cpu.iowait.warning|10::: -c :::params.graphite.cpu.iowait.critical|20:::",
    subscribers => $subscription,
    standalone  =>  false,
    type        => 'metric',
    handlers    => ['flapjack'],
  }
  sensu::check { "check_graphite_load_${subscription}":
    command     => "/etc/sensu/plugins/check-data.rb -a 120 -s ${graphite_host} -t $graphite_prefix.`hostname -s`.loadavg.01 -w :::params.graphite.cpu.load.warning|8::: -c :::params.graphite.cpu.load.critical|10:::",
    subscribers => $subscription,
    standalone  =>  false,
    type        => 'metric',
    handlers    => ['flapjack'],
  }
  sensu::check { "check_graphite_diskspace_bytes_free_${subscription}":
    command     => "/etc/sensu/plugins/check-data.rb -a 120 -s ${graphite_host} -t 'minSeries($graphite_prefix.`hostname -s`.diskspace.*.byte_percentfree)' -w :::params.graphite.diskspace.bytes.free.warning|20::: -c :::params.graphite.diskspace.bytes.free.critical|10:::",
    subscribers => $subscription,
    standalone  =>  false,
    type        => 'metric',
    handlers    => ['flapjack'],
  }
  sensu::check { "check_graphite_diskspace_inodes_free_${subscription}":
    command     => "/etc/sensu/plugins/check-data.rb -a 120 -s ${graphite_host} -t 'minSeries($graphite_prefix.`hostname -s`.diskspace.*.inodes_percentfree)' -w :::params.graphite.diskspace.inodes.free.warning|20::: -c :::params.graphite.diskspace.inodes.free.critical|10:::",
    subscribers => $subscription,
    standalone  =>  false,
    type        => 'metric',
    handlers    => ['flapjack'],
  }
  sensu::check { "check_graphite_sda_vda_disk_await_${subscription}":
    command     => "/etc/sensu/plugins/check-data.rb -a 120 -s ${graphite_host} -t $graphite_prefix.`hostname -s`.iostat.*a.await -w 800 -c 1000",
    subscribers => $subscription,
    standalone  =>  false,
    type        => 'metric',
    handlers    => ['flapjack'],
  }
  sensu::check { "check_graphite_sda_vda_disk_util_percentage_${subscription}":
    command     => "/etc/sensu/plugins/check-data.rb -a 120 -s ${graphite_host} -t $graphite_prefix.`hostname -s`.iostat.*a.util_percentage -w 70 -c 90",
    subscribers => $subscription,
    standalone  =>  false,
    type        => 'metric',
    handlers    => ['flapjack'],
  }
  sensu::check { "check_graphite_number_processes_${subscription}":
    command     => "/etc/sensu/plugins/check-data.rb -a 120 -s ${graphite_host} -t $graphite_prefix.`hostname -s`.loadavg.processes_total -w 600 -c 800",
    subscribers => $subscription,
    standalone  =>  false,
    type        => 'metric',
    handlers    => ['flapjack'],
  }
  sensu::check { "check_graphite_open_files_${subscription}":
    command     => "/etc/sensu/plugins/check-data.rb -a 120 -s ${graphite_host} -t $graphite_prefix.`hostname -s`.files.assigned -w 1100 -c 2000",
    subscribers => $subscription,
    standalone  =>  false,
    type        => 'metric',
    handlers    => ['flapjack'],
  }
  sensu::check { "check_graphite_ntpd_offset_${subscription}":
    command     => "/etc/sensu/plugins/check-data.rb -a 120 -s ${graphite_host} -t $graphite_prefix.`hostname -s`.ntpd.offset -w 2 -c 5",
    subscribers => $subscription,
    standalone  =>  false,
    type        => 'metric',
    handlers    => ['flapjack'],
  }
  sensu::check { "check_graphite_rebooted_${subscription}":
    command     => "/etc/sensu/plugins/check-data.rb -a 120 -s ${graphite_host} -t 'derivative($graphite_prefix.`hostname -s`.proc.btime)' -w 2 -c 5",
    subscribers => $subscription,
    standalone  =>  false,
    type        => 'metric',
    handlers    => ['flapjack'],
  }
  sensu::check { "check_graphite_swapin_${subscription}":
    command     => "/etc/sensu/plugins/check-data.rb -a 120 -s ${graphite_host} -t $graphite_prefix.`hostname -s`.vmstat.pswpin -w 2 -c 5",
    subscribers => $subscription,
    standalone  =>  false,
    type        => 'metric',
    handlers    => ['flapjack'],
  }
  sensu::check { "check_graphite_swapout_${subscription}":
    command     => "/etc/sensu/plugins/check-data.rb -a 120 -s ${graphite_host} -t $graphite_prefix.`hostname -s`.vmstat.pswpout -w 2 -c 5",
    subscribers => $subscription,
    standalone  =>  false,
    type        => 'metric',
    handlers    => ['flapjack'],
  }
  sensu::check { "check_graphite_network_errors_${subscription}":
    command     => "/etc/sensu/plugins/check-data.rb -a 120 -s ${graphite_host} -t $graphite_prefix.`hostname -s`.network.*.*errors -w 1 -c 1",
    subscribers => $subscription,
    standalone  =>  false,
    type        => 'metric',
    handlers    => ['flapjack'],
  }
  sensu::check { "check_graphite_network_drops_${subscription}":
    command     => "/etc/sensu/plugins/check-data.rb -a 120 -s ${graphite_host} -t $graphite_prefix.`hostname -s`.network.*.*drop -w 1 -c 1",
    subscribers => $subscription,
    standalone  =>  false,
    type        => 'metric',
    handlers    => ['flapjack'],
  }
  sensu::check { "check_graphite_network_rxtx_min_${subscription}":
    command     => "/etc/sensu/plugins/check-data.rb -a 120 -s ${graphite_host} -t $graphite_prefix.`hostname -s`.network.eth0.*byte -b -w 20 -c 10",
    subscribers => $subscription,
    standalone  =>  false,
    type        => 'metric',
    handlers    => ['flapjack'],
  }
  sensu::check { "check_graphite_network_rxtx_max_${subscription}":
    command     => "/etc/sensu/plugins/check-data.rb -a 120 -s ${graphite_host} -t $graphite_prefix.`hostname -s`.network.eth0.*byte -w 5000000 -c 10000000",
    subscribers => $subscription,
    standalone  =>  false,
    type        => 'metric',
    handlers    => ['flapjack'],
  }

}
