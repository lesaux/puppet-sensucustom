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
        owner   => sensu,
        group   => sensu,
  }

  file { '/etc/sensu/extensions/nagios_perfdata_custom.rb':
        ensure => file,
        source => 'puppet:///modules/sensucustom/nagios_perfdata_custom.rb',
        owner  => sensu,
        group  => sensu,
  }

  sensu::handler { 'graphite_custom':
    type    => 'tcp',
    mutator => ['nagios_perfdata_custom'],
    socket  => {
      host => '10.251.0.98',
      port => 2003,
    }
  }

  sensu::handler { 'graphite':
    type    => 'tcp',
    mutator => ['only_check_output'],
    socket  => {
      host => '10.251.0.98',
      port => 2003,
    }
  }


}
