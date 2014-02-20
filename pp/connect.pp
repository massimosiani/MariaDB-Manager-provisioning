package { 'sudo':
ensure => installed,
}

package { 'augeas':
ensure => installed,
}

user { 'skysqlagent':
ensure     => present,
comment => 'The SkySQL agent',
managehome => false,
password => skysql,
}

file { "/etc/sudoers":
owner   => "root",
group   => "root",
mode    => "440",
}

augeas { "addtosudoers":
context => "/files/etc/sudoers",
changes => [
"set spec[user = 'skysqlagent']/user skysqlagent",
"set spec[user = 'skysqlagent']/host_group/host ALL",
"set spec[user = 'skysqlagent']/host_group/command ALL",
"set spec[user = 'skysqlagent']/host_group/command/runas_user ALL",
],
}    
