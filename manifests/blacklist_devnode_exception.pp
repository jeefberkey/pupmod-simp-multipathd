# Add a blacklist exception for a devnode per the 'blacklist_exceptions
# section' of multipath.conf(5)
#
# Put your pattern in single (') quotes.
#
# @param pattern
#
# @author Trevor Vaughan <tvaughan@onyxpoint.com>
#
define multipathd::blacklist_devnode_exception (
  String $pattern
) {
  concat_fragment { "multipath_blacklist_exception+$name.devnode.exception":
    content => "devnode $pattern\n",
  }
  if !defined(Concat_fragment['multipath_blacklist_exception+begin']) {
    concat_fragment {'multipath_blacklist_exception+begin':
      content => 'blacklist_exceptions {
'
    }
  }
  if !defined(Concat_fragment['multipath_blacklist_exception+end']) {
    concat_fragment {'multipath_blacklist_exception+end':
      content => '
}'
    }
  }
}
