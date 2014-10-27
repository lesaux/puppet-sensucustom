#
# === Parameters
#
# [*admin_gui*]
# [*mail_from*]
# [*mail_to*]
# [*smtp_server*]
# [*smtp_port*]
# [*smtp_domain*]


class sensucustom::mailer (
$admin_gui = 'http://localhost:3000',
$mail_from = 'sensu@localdomain.com',
$mail_to   = 'lesaux@pythian.com',
$smtp_server = 'localhost',
$smtp_port   = '25',
$smtp_domain = 'localdomain.com' )
{
  #require sensu

  file { '/etc/sensu/conf.d/mailer.json':
        ensure  => file,
        content => template('sensucustom/mailer.json.erb'),
        owner   => sensu,
        group   => sensu,
  }

  file { '/etc/sensu/conf.d/handlers/mailer.rb':
        ensure => file,
        source => 'puppet:///modules/sensucustom/mailer.rb',
        owner  => sensu,
        group  => sensu,
        mode   => '0755',
  }

##mailer handler for ping. temporary as we will use flapjack in the future.

  sensu::handler { 'mailer_handler':
    command    => '/etc/sensu/conf.d/handlers/mailer.rb',
    type       => 'pipe',
    severities => ['critical'],
  }


}

