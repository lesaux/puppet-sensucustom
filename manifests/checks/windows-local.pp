
  sensu::check { 'check_windows_graphite_process':
    command     => "/pythian/sensu/embedded/bin/ruby.exe /pythian/sensu/checks/check-process.rb -p PerfCounterMonitor.exe",
    subscribers => 'windows_local',
    standalone  =>  false,
    type        => 'metric',
  }
