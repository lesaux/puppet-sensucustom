#
# === Parameters
#
# [*redis_host*]
#   redis host. Default: localhost
# [*redis_port*]
#   redis instance port
# [*redis_db*]. Default: 6379
#   redis database. Default: 0

class sensucustom::flapjack (
$redis_host = 'localhost',
$redis_port = '6379',
$redis_db   = '0', )
{
  require sensu
  
  file { '/etc/sensu/conf.d/flapjack.json':
        ensure   => file,
        content  => template('sensucustom/flapjack.json.erb'),
        owner    => sensu,
        group    => sensu,
  }

  file { '/etc/sensu/extensions/flapjack.rb':
        ensure  => file,
        source  => 'puppet:///modules/sensucustom/flapjack.rb',
        owner    => sensu,
        group    => sensu,
  }


}
