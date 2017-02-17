# Set up the multipath.conf defaults per the 'defaults section' of
# multipath.conf(5)
#
# @param udev_dir
# @param polling_interval
# @param selector
# @param path_grouping_policy
# @param getuid_callout
# @param prio_callout
# @param path_checker
# @param rr_min_io
# @param max_fds
# @param rr_weight
# @param failback
# @param no_path_retry
# @param user_friendly_names
# @param bindings_file
#
class multipathd::defaults (
  Stblib::AbsolutePath $udev_dir             = '/dev',
  Integer              $polling_interval     = 10,
  String               $selector             = 'round-robin 0',
  String               $path_grouping_policy = 'multibus',
  String               $getuid_callout       = '/sbin/scsi_id -g -u -s /block/%n',
  String               $prio_callout         = '/bin/true',
  String               $path_checker         = 'readsector0',
  Integer              $rr_min_io            = 100,
  Integer              $max_fds              = 8192,
  String               $rr_weight            = 'priorities',
  String               $failback             = 'immediate',
  Optional[String]     $no_path_retry        = undef,
  Boolean              $user_friendly_names  = 'no',
  OPtional[String]     $bindings_file        = undef
) {
  concat_fragment { 'multipath_conf+defaults.conf':
    content => template('multipathd/defaults.erb'),
  }
}
