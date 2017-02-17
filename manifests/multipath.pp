# Set up the multipath.conf defaults per the 'defaults section' of
# multipath.conf(5)
#
# @param name
#   $alias will be set to $name!
#
# @param wwid
# @param path_grouping_policy
# @param path_selector
# @param failback
# @param rr_min_io
# @param fstype
# @param fsoptions
#
# @author Trevor Vaughan <tvaughan@onyxpoint.com>
#
define multipathd::multipath (
  $wwid,
  $path_grouping_policy = 'nil',
  $path_selector = 'nil',
  $failback = 'nil',
  $rr_min_io = 'nil',
  $fstype = 'ext3',
  $fsoptions = '-O dir_index,sparse_super'
) {
  if !defined(Concat_fragment['multipath+begin']) {
    concat_fragment { 'multipath+begin':
      content => 'multipaths {
'
    }
  }
  if !defined(Concat_fragment['multipath+end']) {
    concat_fragment { 'multipath+end':
      content => '
}'
    }
  }

  concat_fragment { "multipath+$name.multipath":
    content => template('multipathd/multipath.erb')
  }

  file { "/$name":
    ensure => 'directory',
    owner  => 'root',
    group  => 'root'
  }

  mount { "/$name":
    ensure   => 'mounted',
    device   => "/dev/mpath/$name",
    dump     => '1',
    fstype   => $fstype,
    options  => 'defaults',
    pass     => '2',
    remounts => true,
    require  => [ File["/$name"], Exec["format_$name"] ]
  }

  exec { "format_$name":
    command =>
      "/sbin/mkfs.$fstype $fsoptions -L $name /dev/mpath/`/usr/bin/readlink /dev/mpath/$name`",
    onlyif  =>
      "/usr/bin/file -s /dev/mpath/`/usr/bin/readlink /dev/mpath/$name` | /bin/grep -qv $fstype",
    timeout => '1200',
    require => Service['multipathd']
  }
}
