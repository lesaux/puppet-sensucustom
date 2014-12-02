class sensucustom::http {

  case $::osfamily {
    'redhat': {
      ensure_packages('nagios-plugins-http')
      $nagios_plugins_path = "/usr/lib64/nagios/plugins" 
    }
    'debian': {
      ensure_packages('nagios-plugins')
      $nagios_plugins_path = "/usr/lib/nagios/plugins" 
    }
  }
  

}


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

define sensucustom::http::check-nagios (
  $ip         = '127.0.0.1',  #can be a hostname too if it resolves
  $entity     = localhost,
  $parameters = null, )  {
    sensu::check { "check_http_nagios_${name}":
      command     => "$nagios_plugins_path/check_http -I $ip $parameters",
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
