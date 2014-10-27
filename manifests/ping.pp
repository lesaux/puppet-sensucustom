
define sensucustom::ping  {
  sensu::check { "check_ping_${name}":
    command     => "/etc/sensu/plugins/check-ping.rb -h ${name}",
    handlers    => ['flapjack'],
    subscribers => 'ping',
    standalone  =>  false,
    type        => 'metric',
    interval    => '180',
    custom      => {
      source => $name,
    }
  }
}
