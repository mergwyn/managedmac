# @summary
#   Module initializer.
#
# @example
#  include managedmac
#
#  class { managedmac: }
#
class managedmac {

  if $::osfamily != 'Darwin' {
    fail("unsupported osfamily: ${::osfamily}")
  }

  $min_os_version = '10.9'

  if version_compare($::macosx_productversion_major, $min_os_version) < 0 {
    fail("unsupported product version: ${::macosx_productversion_major}")
  }

  include managedmac::ntp
  include managedmac::activedirectory
  include managedmac::security
  include managedmac::desktop
  include managedmac::mcx
  include managedmac::filevault
  include managedmac::loginwindow
  include managedmac::softwareupdate
  include managedmac::energysaver
  include managedmac::portablehomes
  include managedmac::mounts
  include managedmac::loginhook
  include managedmac::logouthook
  include managedmac::sshd
  include managedmac::remotemanagement
  include managedmac::screensharing
  include managedmac::mobileconfigs
  include managedmac::propertylists
  include managedmac::execs
  include managedmac::files
  include managedmac::users
  include managedmac::groups
  include managedmac::cron

}
