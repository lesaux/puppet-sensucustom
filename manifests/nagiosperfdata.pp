class sensucustom::nagiosperfdata (
  $graphite_ip   = 'localhost',
  $graphite_port = 2213,
) {

  #require sensu

  #file { '/etc/sensu/conf.d/nagios.json':
  #      ensure   => file,
  #      content  => template('sensucustom/nagios.json.erb'),
  #      owner    => sensu,
  #      group    => sensu,
  #}

  file { '/etc/sensu/extensions/nagios_perfdata.rb':
        ensure  => file,
        source  => 'puppet:///modules/sensucustom/sensuhandlers/nagios_perfdata.rb',
        owner   => sensu,
        group   => sensu,
  }

  file { '/etc/sensu/extensions/nagios_perfdata_custom.rb':
        ensure => file,
        source => 'puppet:///modules/sensucustom/sensuhandlers/nagios_perfdata_custom.rb',
        owner  => sensu,
        group  => sensu,
  }

  sensu::handler { 'graphite_custom':
    type    => 'tcp',
    mutator => ['nagios_perfdata_custom'],
    socket  => {
      host => $graphite_ip,
      port => $graphite_port,
    }
  }

  sensu::handler { 'graphite':
    type    => 'tcp',
    mutator => ['only_check_output'],
    socket  => {
      host => $graphite_ip,
      port => $graphite_port,
    }
  }


}
