# Class: profile::mapr::configure_r_ot_eskey
#
# This module runs configure.sh -R -OT -genESKeys
#

class profile::mapr::configure_r_ot_eskey (
) {

  include profile::mapr::cluster

  exec { 'Run configure.sh -R -OT -genESKeys':
    command     => "/opt/mapr/server/configure.sh -R -ES $profile::mapr::cluster::elastic_node -OT $profile::mapr::cluster::opentsdb_node -EPelasticsearch -genESKeys",
    logoutput   => on_failure,
    refreshonly => true,
    notify      => Class['profile::mapr::warden_restart2']
  }

}
