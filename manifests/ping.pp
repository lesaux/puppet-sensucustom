
define sensucustom::ping  {
  sensu::check { "check_ping_${name}":
    command     => "/etc/sensu/plugins/check-ping.rb -h ${name} -c 10 -C 0.8 -W 0.9 -i 1 -T 5",
    handlers    => ['flapjack'],
    subscribers => 'ping',
    standalone  =>  false,
    type        => 'metric',
    interval    => '180',
    custom      => {
      source => $name,
      tags   => ['pythian_oncall'],
    }
  }
}
