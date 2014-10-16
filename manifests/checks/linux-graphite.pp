class sensucustom::checks::linux-graphite (
 $graphite_host = 'graphite',
) {

  sensu::check { 'check_graphite_cpu_iowait':
    command     => "/etc/sensu/plugins/check-data.rb -a 120 -s ${graphite_host} -t servers.`hostname -s`.cpu.total.iowait -w :::params.graphite.cpu.iowait.warning|10::: -c :::params.graphite.cpu.iowait.critical|20:::",
    subscribers => 'linux_graphite',
    standalone  =>  false,
    type        => 'metric',
  }
  sensu::check { 'check_graphite_load':
    command     => "/etc/sensu/plugins/check-data.rb -a 120 -s ${graphite_host} -t servers.`hostname -s`.loadavg.01 -w :::params.graphite.cpu.load.warning|4::: -c :::params.graphite.cpu.load.critical|8:::",
    subscribers => 'linux_graphite',
    standalone  =>  false,
    type        => 'metric',
  }
  sensu::check { 'check_graphite_diskspace_bytes_free':
    command     => "/etc/sensu/plugins/check-data.rb -a 120 -s ${graphite_host} -t 'minSeries(servers.`hostname -s`.diskspace.*.byte_percentfree)' -w :::params.graphite.diskspace.bytes.free.warning|20::: -c :::params.graphite.diskspace.bytes.free.critical|10:::",
    subscribers => 'linux_graphite',
    standalone  =>  false,
    type        => 'metric',
  }
  sensu::check { 'check_graphite_diskspace_inodes_free':
    command     => "/etc/sensu/plugins/check-data.rb -a 120 -s ${graphite_host} -t 'minSeries(servers.`hostname -s`.diskspace.*.inodes_percentfree)' -w :::params.graphite.diskspace.inodes.free.warning|20::: -c :::params.graphite.diskspace.inodes.free.critical|10:::",
    subscribers => 'linux_graphite',
    standalone  =>  false,
    type        => 'metric',
  }
  sensu::check { 'check_graphite_sda_vda_disk_await':
    command     => "/etc/sensu/plugins/check-data.rb -a 120 -s ${graphite_host} -t servers.`hostname -s`.iostat.*a.await -w 800 -c 1000",
    subscribers => 'linux_graphite',
    standalone  =>  false,
    type        => 'metric',
  }
  sensu::check { 'check_graphite_sda_vda_disk_util_percentage':
    command     => "/etc/sensu/plugins/check-data.rb -a 120 -s ${graphite_host} -t servers.`hostname -s`.iostat.*a.util_percentage -w 70 -c 90",
    subscribers => 'linux_graphite',
    standalone  =>  false,
    type        => 'metric',
  }
  sensu::check { 'check_graphite_number_processes':
    command     => "/etc/sensu/plugins/check-data.rb -a 120 -s ${graphite_host} -t servers.`hostname -s`.loadavg.processes_total -w 600 -c 800",
    subscribers => 'linux_graphite',
    standalone  =>  false,
    type        => 'metric',
  }
  sensu::check { 'check_graphite_open_files':
    command     => "/etc/sensu/plugins/check-data.rb -a 120 -s ${graphite_host} -t servers.`hostname -s`.files.assigned -w 1100 -c 2000",
    subscribers => 'linux_graphite',
    standalone  =>  false,
    type        => 'metric',
  }
  sensu::check { 'check_graphite_ntpd_offset':
    command     => "/etc/sensu/plugins/check-data.rb -a 120 -s ${graphite_host} -t servers.`hostname -s`.ntpd.offset -w 2 -c 5",
    subscribers => 'linux_graphite',
    standalone  =>  false,
    type        => 'metric',
  }
  sensu::check { 'check_graphite_rebooted':
    command     => "/etc/sensu/plugins/check-data.rb -a 120 -s ${graphite_host} -t 'derivative(servers.`hostname -s`.proc.btime)' -w 2 -c 5",
    subscribers => 'linux_graphite',
    standalone  =>  false,
    type        => 'metric',
  }
  sensu::check { 'check_graphite_swapin':
    command     => "/etc/sensu/plugins/check-data.rb -a 120 -s ${graphite_host} -t servers.`hostname -s`.vmstat.pswpin -w 2 -c 5",
    subscribers => 'linux_graphite',
    standalone  =>  false,
    type        => 'metric',
  }
  sensu::check { 'check_graphite_swapout':
    command     => "/etc/sensu/plugins/check-data.rb -a 120 -s ${graphite_host} -t servers.`hostname -s`.vmstat.pswpout -w 2 -c 5",
    subscribers => 'linux_graphite',
    standalone  =>  false,
    type        => 'metric',
  }
  sensu::check { 'check_graphite_network_errors':
    command     => "/etc/sensu/plugins/check-data.rb -a 120 -s ${graphite_host} -t servers.`hostname -s`.network.*.*errors -w 1 -c 1",
    subscribers => 'linux_graphite',
    standalone  =>  false,
    type        => 'metric',
  }
  sensu::check { 'check_graphite_network_drops':
    command     => "/etc/sensu/plugins/check-data.rb -a 120 -s ${graphite_host} -t servers.`hostname -s`.network.*.*drop -w 1 -c 1",
    subscribers => 'linux_graphite',
    standalone  =>  false,
    type        => 'metric',
  }
  sensu::check { 'check_graphite_network_rxtx_min':
    command     => "/etc/sensu/plugins/check-data.rb -a 120 -s ${graphite_host} -t servers.`hostname -s`.network.eth0.*byte -b -w 20 -c 10",
    subscribers => 'linux_graphite',
    standalone  =>  false,
    type        => 'metric',
  }
  sensu::check { 'check_graphite_network_rxtx_max':
    command     => "/etc/sensu/plugins/check-data.rb -a 120 -s ${graphite_host} -t servers.`hostname -s`.network.eth0.*byte -w 1000000 -c 5000000",
    subscribers => 'linux_graphite',
    standalone  =>  false,
    type        => 'metric',
  }

}
