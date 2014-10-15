class sensucustom::nagiosperfdata {

  #require sensu

  #file { '/etc/sensu/conf.d/nagios.json':
  #      ensure   => file,
  #      content  => template('sensucustom/nagios.json.erb'),
  #      owner    => sensu,
  #      group    => sensu,
  #}

  file { '/etc/sensu/extensions/nagios_perfdata.rb':
        ensure  => file,
        source  => 'puppet:///modules/sensucustom/nagios_perfdata.rb',
        owner    => sensu,
        group    => sensu,
  }

  file { '/etc/sensu/extensions/nagios_perfdata_custom.rb':
        ensure  => file,
        source  => 'puppet:///modules/sensucustom/nagios_perfdata_custom.rb',
        owner    => sensu,
        group    => sensu,
  }

  sensu::handler { 'graphite_custom':
    type    => 'tcp',
    socket  => {
      host => '192.168.0.84',
      port => 2003,
    },
    mutator => ['nagios_perfdata_custom']    
  }

  sensu::handler { 'graphite':
    type    => 'tcp',
    socket  => {
      host => '192.168.0.84',
      port => 2003,
    },
    mutator => ['only_check_output']    
  }


}
