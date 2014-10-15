#Additional configs for sensu.

##cisco.pp
Adds cisco snmp check script.

##vmware.pp
Adds vmware check scripts and check resource definitions.

###example usage:
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
Adds flapjack handler for sensy

##nagiosperfdata.pp
Adds nagios_perfdata mutator for sensu

