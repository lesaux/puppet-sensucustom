
define sensucustom::ping  {
  sensu::check { "check_ping_${name}":
    command     => "/etc/sensu/plugins/check-ping.rb -h ${name} -c 10 -C 0.7 -W 0.8 -i 1 -T 5",
    handlers    => ['flapjack'],
    subscribers => 'remote_ping',
    standalone  =>  false,
    type        => 'metric',
    interval    => '180',
    custom      => {
      source => $name,
      tags   => ['pythian_oncall'],
    }
  }
}
