define sensucustom::http::check (
  $url        = "http://localhost/whatever",
  $entity     = localhost,
  $parameters = null, )  {
    sensu::check { "check_http_${name}":
      command     => "/etc/sensu/plugins/check-http.rb -u $url $parameters",
      handlers    => ['flapjack'],
      subscribers => "remote_http",
      standalone  =>  false,
      type        => 'metric',
      interval    => '60',
      custom      => {
        source => $entity
      }
    }
}
