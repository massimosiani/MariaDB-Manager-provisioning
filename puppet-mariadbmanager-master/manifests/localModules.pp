class mariadbmanager::localInstall (

  $puppet_modulepath,
  $source_dir

) {

  define puppetLocalModule {
    file { "puppet-${title}":
      ensure  => directory,
      force   => true,
      path    => "${puppet_modulepath}/${title}",
      purge   => true,
      recurse => true,
      replace => true,
      source  => "${source_dir}/puppet-${title}-master",
    }

  }
