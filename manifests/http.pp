define sensucustom::http::check (
$url = "http://localhost/whatever"
$source = localhost )  {
  sensu::check { "check_http_${name}":
    command     => "/etc/sensu/plugins/check-http.rb -u $url -q ctl00",
    handlers    => ['flapjack'],
    subscribers => "remote_http",
    standalone  =>  false,
    type        => 'metric',
    interval    => '60',
    custom      => {
      source => $source
    }
  }
}
