# Set up the multipath.conf defaults per the 'devices section' of
# multipath.conf(5)
#
# @param vendor
# @param product
# @param path_grouping_policy
# @param getuid_callout
# @param prio_callout
# @param path_checker
# @param path_selector
# @param failback
# @param rr_min_io
# @param product_blacklist
# @param blacklist
#   Whether or not to blacklist this device instead of adding it.
#
# @author Trevor Vaughan <tvaughan@onyxpoint.com>
#
define multipathd::device (
  String           $vendor,
  String           $product,
  Optional[String] $path_grouping_policy = undef,
  Optional[String] $getuid_callout       = undef,
  Optional[String] $prio_callout         = undef,
  Optional[String] $path_checker         = undef,
  Optional[String] $path_selector        = undef,
  Optional[String] $failback             = undef,
  Optional[String] $rr_min_io            = undef,
  Optional[String] $product_blacklist    = undef,
  Boolean          $blacklist            = false
) {

  if $blacklist {
    if !defined(Concat_fragment['multipath_blacklist+begin']) {
      concat_fragment {'multipath_blacklist+begin':
        content => 'blacklist {
'
      }
    }
    if !defined(Concat_fragment['multipath_blacklist+end']) {
      concat_fragment {'multipath_blacklist+end':
        content => '
}'
      }
    }
    concat_fragment { "multipath_blacklist+$name.device.blacklist":
      content => "device {\nvendor \"$vendor\"\nproduct \"$product\"\n}\n"
    }
  }
  else {
    if !defined(Concat_fragment['multipath_devices+begin']) {
      concat_fragment { 'multipath_devices+begin':
        content => 'multipaths {
'
      }
    }
    if !defined(Concat_fragment['multipath_devices+end']) {
      concat_fragment { 'multipath_devices+end':
        content => '
}'
      }
    }
    concat_fragment { "multipath_devices+$name.device":
      content => template('multipathd/device.erb')
    }
  }
}
