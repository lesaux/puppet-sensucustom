class sensucustom::checks::windows-graphite (
 $graphite_host = 'graphite',
) {

  sensu::check { 'check_windows_graphite_process':
    command     => "/pythian/sensu/embedded/bin/ruby.exe /pythian/sensu/checks/check-process.rb -p PerfCounterMonitor.exe",
    subscribers => 'windows_graphite',
    standalone  =>  false,
    type        => 'metric',
    handlers    => ['flapjack'],
  }
  sensu::check { 'check_graphite_windows_disk_percent_free_space':
    command     => "/pythian/sensu/checks/check-data.bat ${graphite_host} disk.percent_free_space_* \":::params.graphite.windows.disk.percent.free.warning|10:::\" \":::params.graphite.windows.disk.percent.free.critical|5:::\" -b",
    subscribers => 'windows_graphite',
    standalone  =>  false,
    type        => 'metric',
    handlers    => ['flapjack'],
    custom      => {
      occurrences         => 10,
      low_flap_threshold  => 5,
      high_flap_threshold => 25,
    },
  }
  sensu::check { 'check_graphite_windows_network_packets_discarded':
    command     => "/pythian/sensu/checks/check-data.bat ${graphite_host} network.packets_*_discarded \":::params.graphite.windows.network.packets.discarded.warning|1:::\" \":::params.graphite.raphite.windows.network.packets.discarded..critical|1:::\"",
    subscribers => 'windows_graphite',
    standalone  =>  false,
    type        => 'metric',
    handlers    => ['flapjack'],
  }
  sensu::check { 'check_graphite_windows_network_packets_errors':
    command     => "/pythian/sensu/checks/check-data.bat ${graphite_host} network.packets_*_errors \":::params.graphite.windows.network.packets.discarded.warning|1:::\" \":::params.graphite.windows.network.packets.discarded.critical|1:::\"",
    subscribers => 'windows_graphite',
    standalone  =>  false,
    type        => 'metric',
    handlers    => ['flapjack'],
  }
  sensu::check { 'check_graphite_windows_threads':
    command     => "/pythian/sensu/checks/check-data.bat ${graphite_host} system.threads \":::params.graphite.windows.system.threads.warning|3000:::\" \":::params.graphite.windows.system.threads.critical|4000:::\"",
    subscribers => 'windows_graphite',
    standalone  =>  false,
    type        => 'metric',
    handlers    => ['flapjack'],
  }
  sensu::check { 'check_graphite_windows_processor_queue_length':
    command     => "/pythian/sensu/checks/check-data.bat ${graphite_host} system.processor_queue_length \":::params.graphite.windows.system.processor.queue.length.warning|40:::\" \":::params.graphite.windows.system.processor.queue.length.critical|50:::\"",
    subscribers => 'windows_graphite',
    standalone  =>  false,
    type        => 'metric',
    handlers    => ['flapjack'],
  }
  sensu::check { 'check_graphite_windows_processes':
    command     => "/pythian/sensu/checks/check-data.bat ${graphite_host} system.processes \":::params.graphite.windows.system.processes.warning|700:::\" \":::params.graphite.windows.system.processes.critical|1000:::\"",
    subscribers => 'windows_graphite',
    standalone  =>  false,
    type        => 'metric',
    handlers    => ['flapjack'],
  }
  sensu::check { 'check_graphite_windows_file_data_ops':
    command     => "/pythian/sensu/checks/check-data.bat ${graphite_host} system.file_data_ops_sec \":::params.graphite.windows.system.file.data.ops.warning|5000:::\" \":::params.graphite.windows.system.file.data.ops.critical|6000:::\"",
    subscribers => 'windows_graphite',
    standalone  =>  false,
    type        => 'metric',
    handlers    => ['flapjack'],
  }
  sensu::check { 'check_graphite_windows_processor_interrupts':
    command     => "/pythian/sensu/checks/check-data.bat ${graphite_host} processor.interrupts_sec \":::params.graphite.windows.processor.interrupts.warning|15000:::\" \":::params.graphite.windows.processor.interrupts.critical|20000:::\"",
    subscribers => 'windows_graphite',
    standalone  =>  false,
    type        => 'metric',
    handlers    => ['flapjack'],
  }
  sensu::check { 'check_graphite_windows_cpu_load':
    command     => "/pythian/sensu/embedded/bin/ruby.exe /pythian/sensu/checks/check-windows-cpu-load.rb",
    subscribers => 'windows_graphite',
    standalone  =>  false,
    type        => 'metric',
    handlers    => ['flapjack'],
    custom      => {
      occurrences => 10,
      low_flap_threshold  => 5,
      high_flap_threshold => 25,
    },
  }

}
