#Additional configs and "remote" checks for sensu. A few linux subscriptions are also included.
Remote checks are run from a dedicated sensu-client.
the source field is overriden by the remote hostname.
the entity field (when event are forwarded to flapjack) is also overriden by the remote hostname.

##cisco.pp
Adds cisco snmp check script.

subscription: remote_cisco

####example usage:
todo

##emc.pp
Adds EMC Clariion and VNX remote health checks.
You will need to have navisphere client installed. This can be done with the puppet-navisphere module.

subscription: remote_emc

####example usage:
todo


##http.pp
Adds remote http checks capability. Both check-http.rb from sensu community plugins, and check_http from nagios plugins are supplied.

subscriptions: remote_http

####example usage:
todo

##ping.pp
Adds remote ping checks capabilty. Then entity field in flapjack is overriden by the remote hostname.

subscription: remote_ping

##vmware.pp
Adds VMware ESX/vCenter remote health checks. Performance data is shipped to a graphite host.
You will need to have the vmware-perl-sdk installed. This can be done with the puppet-vmware-perl-sdk module.

subscription: remote_vmware

####example usage:
```
$esx_hosts = {
  'esx-node1' => {   vcenter         => '192.168.0.200',
                     esxhost         => 'esx-node1.your.domnain.com', #hostname as it shows in vcenter
                     entity          => 'esx-node1', #as the host should show up in flapjack
                     graphite_prefix => 'esx', #graphite folder
                     graphite_folder => 'esx-node1', } #graphite folder
}

$datastores = {
  'vcenter' => { vcenter => '192.168.0.200',
                 entity => vcenter, #as the host should show up in flapjack
                 graphite_prefix => esx, #graphite folder
                 graphite_folder => vcenter, #graphite folder
  }
}

create_resources( sensucustom::vmware::esx-checks, $esx_hosts)
create_resources( sensucustom::vmware::datastore-checks, $datastores )
```

##mailer.pp
Adds mailer handler for sensu

#flapjack.pp
Adds flapjack handler for sensu

##nagiosperfdata.pp
Adds nagios_perfdata mutator for sensu

##subscriptions

linux-graphite.pp

several linux checks via graphite

linux-local.pp

a place to collect linux local checks (running processes etc...)

windows-graphite.pp

several windows checks via graphite

windows-local.pp

a place to collect windows local checks (running services etc...)
