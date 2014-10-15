#!/usr/bin/perl -w
# ============================================================================
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; either version 2, or (at your option) any
# later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
#
# ============================================================================
# Portions Copyright (C) R3dL!GhT 2007.
# Modifications Copyright (C) 2008 Martin Fuerstenau, mf_at_maerber.de
#
# Purpose:
# SNMP check for cisco devices (routers/switches) returning state of different interfaces.
#
# Changes:
# 
# - 18.5.2009 - Martin Fuerstenau
#   Bugfix - The cachefile was not generated when the original one was deleted
# - 25.7.2008 - Martin Fuerstenau (JeanLuc)
#   On bigger switches the plugin was too slow due to the fact that it did multiple snmpwalks
#   On a switch with over 350 ports that caused a timeout in Nagios.
#
#   Problem was solved by implementing a cache mechanism. This was done in the following manner.
#
#   You need a directory for the cache files. It is best to do it with a tmpfs because a tmpfs is
#   opposite to a ramdisk swapable.
#
#   Sample entry from /etc/fstab:
#
#   tmpfs                    /var/nagios_plugin_cache       tmpfs   defaults        0 0
#
#   Please change variable $CachePath for a different location
#
#   Unforunately I use some systemcalls for executing system commands. This is a little bit dirty
#   but every snmp call in this script was done be a system call instead of using perl. A complete
#   rewrite was too much work for the time I had to solve my problems.
#
#   The function snmpwalkgrep, snmpwalk and some lines of code were kicked out because they were
#   no longer necessary
#
#   The script does a find in the cache directory for the cache file. If it is too old (-mtime) or
#   not existent it will be generated. OIDs, interface names and descriptions are store in the cache
#   That means the double walk will be done only every 2 days instead of every run
#
# Synopsis:
# 
# check_cisco_snmp -H ip -C community -I interface -S state (optional)
#
# ============================================================================


###################Setting up some parameters#########################

use strict;
use Getopt::Long;

my $UNKNOW = -1;
my $OK = 0;
my $WARNING = 1;
my $CRITICAL = 2;
my $state = "up";
my $host = "";
my $HELP = "";
my $community = "public";
my $warning = "1000";
my $critical = "2000";
my $interface = "";
my $MIBifDescr="IF-MIB::ifDescr";
my $MIBifOper="IF-MIB::ifOperStatus";
my $MIBifName="IF-MIB::ifName";
my $MIBifLastChange="IF-MIB::ifLastChange";
my $MIBTrafficIn="IF-MIB::ifInOctets";
my $MIBTrafficOut="IF-MIB::ifOutOctets";
my $MIBDescription="IF-MIB::ifAlias";

my $CachePath="/var/nagios_plugin_cache/";
my $GENERATE_IT=0;
my $Cache_Valid="";

sub wanted;

###################Getting options##############################

Getopt::Long::Configure('bundling');

GetOptions(
        "host|H=s" => \$host,
        "community|C=s"  => \$community,
	"interface|I=s"   => \$interface,
	"help"    => \$HELP,
	"h"    => \$HELP,
	"state|S=s"	=>\$state
);
chomp($host);
chomp($community);
chomp($interface);
chomp($state);

################### Check input ##############################################

if (!$host)
    {
    print "\nHostname/address not specified\n\n";
    print_usage();
    exit 2;
    }

if (!$interface)
    {
    print "\nInterface not specified\n\n";
    print_usage();
    exit 2;
    }

if ($HELP)
   {
   print_help();
   exit 0;
   }

################### Setting up the cache ##############################################

my $CacheFile=$CachePath.$host."_cache";
my $CacheFileTmp=$CachePath.$host."_cache.tmp";

# Unfortunately some system calls

# If find has a hit the cache is too old

$Cache_Valid = `find $CacheFile -mtime +99 2>/dev/null`;
chomp($Cache_Valid);

if ( $Cache_Valid eq $CacheFile)
   {
   `snmpwalk -c $community -v 2c $host IF-MIB::ifDescr | awk -F: '{print \$3,\$4'} | sed 's\/ifDescr.\/\/' | awk '{print \$1,\$4}' > $CacheFile`;
   `snmpwalk -c $community -v 2c $host IF-MIB::ifName | awk -F: '{print \$3,\$4'} | sed 's\/ifName.\/\/' | awk '{print \$1,\$4}'  >> $CacheFile`;
   `sort $CacheFile > $CacheFileTmp`;
   `mv $CacheFileTmp $CacheFile`;
   }

# If find has now a hit everything is fine. Otherwise the cache is missing and must be generated

$Cache_Valid = `find $CacheFile 2>/dev/null`;
chomp($Cache_Valid);

if ( $Cache_Valid eq "" || !$Cache_Valid)
   {
   `snmpwalk -c $community -v 2c $host IF-MIB::ifDescr | awk -F: '{print \$3,\$4'} | sed 's\/ifDescr.\/\/' | awk '{print \$1,\$4}' > $CacheFile`;
   `snmpwalk -c $community -v 2c $host IF-MIB::ifName | awk -F: '{print \$3,\$4'} | sed 's\/ifName.\/\/' | awk '{print \$1,\$4}'  >> $CacheFile`;
   `sort $CacheFile > $CacheFileTmp`;
   `mv $CacheFileTmp $CacheFile`;
    }
   			
my $oid =  `grep \" \"$interface\$ $CacheFile | awk '{print \$1}'`;
chomp($oid);

my $tree="IF-MIB::ifOperStatus.$oid";
my $return=snmpget($host, $community, $tree);
      
if ($return =~ /up/ && $state eq "up")
   {
   my $LastChange= snmpget($host, $community, "$MIBifLastChange"."\.".$oid);
   my $Alias= snmpget($host, $community, "$MIBDescription"."\.".$oid);
   my $TrafficIn =snmpget($host, $community, "$MIBTrafficIn"."\.".$oid);
   my $TrafficOut=snmpget($host, $community, "$MIBTrafficOut"."\.".$oid);
   my $LastChangeCleaned=CleanMe($LastChange); 
   my $AliasCleaned=CleanMe($Alias);
   my $TrafficInCleaned=CleanMe($TrafficIn);
   my $TrafficOutCleaned=CleanMe($TrafficOut);
   print "$interface up: $AliasCleaned, LastChanges: $LastChangeCleaned, Traffic in : $TrafficInCleaned octets, out: $TrafficOutCleaned octets\n";
   exit $OK;
   }
       
if ($return =~ /down/ && $state eq "up")
   {
   print "$interface is down\n";
   exit $CRITICAL;
   }
       
if ($return =~ /down/ && $state eq "down")
   {
   print "$interface down : ok\n";
   exit $OK;
   }
    
if ($return =~ /up/ && $state eq "down")
   {
   print "$interface should not be up\n";
   exit $CRITICAL;
   }
       
if ($return =~ /dormant/ && $state eq "down" || $return =~ /dormant/ && $state eq "up")
   {
   print "Error : $interface is sleeping\n";
   exit $CRITICAL;
   }
       
if ($return =~ /dormant/ && $state eq "dormant")
   {
   print "$interface is sleeping : ok\n";
   exit $OK
   }
       
if ($return =~ /up/ && $state eq "dormant")
   {
   print "$interface is up and should be sleeping\n";
   exit $CRITICAL;
   }
else
   {
   print "Unknown state for $interface : check your -s state syntax\n";
   exit $UNKNOW;
   }

sub CleanMe
    {
    my $input=$_[0];
    if ($input =~ /: (.*)/)
       {
       my $return=$1;
       chomp($return);
       return $return;
       }
    }

sub snmpget
    {
    my ($host, $community, $tree)=@_;
    my $get = `snmpget -v 1 -c $community $host $tree`;
    chomp($get);
    return $get;
    }

sub print_usage
    {
    print "\nUsage: check_cisco_snmp -H ip -C community -I interface -S state (optional)\n\n";
    print "or\n";
    print "\nUsage: check_cisco_snmp -h for help.\n\n";
    }

sub print_help
    {
    print "Copyright (c) 2008 Martin Fuerstenau\n";
    print "Portions Copyright (C) R3dL!GhT 2007\n";
    print "SNMP check for cisco devices (routers/switches) returning state of different interfaces";
    print_usage();
    print "       -H or --host        Set here the ip of your host\n";
    print "       -C or --community   Set here your own community\n\n";
    print "       -I or --interface   Set here the interface u want to check (Use the same syntax as\n";
    print "                           for cisco devices, for exemple FastEthernet1/0/1, Fa2/0/3 or Fa0)\n\n";
    print "       -S or --state       Set the state of your interface. Options are : up/down/dormant\n\n";
    print "       -h, --help          Short help message\n\n";
    print "Example\n\n";
    print "Wanna check Fa2/0/1 is up on your switch ?\n";
    print "./check_cisco_snmp -H 192.168.0.1 -C public -I Fa2/0/1\n";
    print "or\n";
    print "./check_cisco_snmp -H 192.168.0.1 -C public -I FastEthernet2/0/1\n";
    print "To check your FastEthernet0 is down on your router :\n";
    print "./check_cisco_snmp -H 192.168.0.1 -C MyCommunity -I FastEthernet0 (or Fa0) -S down\n";
    print "To check your Backup RNIS BRIO:1 is dormant on your router:\n";
    print "./check_cisco_snmp -H 192.168.0.1 -C MyCommunity -I BRI0:1 -S down\n";
    print "State option are : up (-S up), down (-S down), dormant (-S dormant). State is set to up if not defined.\n\n";
    print "This plugin uses the 'snmpget' command included with the NET-SNMP package.\n";
    print "If you don't have the package installed, you will need to download it from\n";
    print "http://net-snmp.sourceforge.net before you can use this plugin.\n\n";
    print "\n";
    }
