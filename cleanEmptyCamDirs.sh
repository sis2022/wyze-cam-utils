#!/bin/bash

camDir="/cams/";

cleanup() {
  for cam in "${camDir}"/wyze*/; do
    d="${cam}/$1"
    if test -d "$d"; then
      for dayDir in $(find "$d" -type d -iname "[[:digit:]][[:digit:]]" | sort); do
        rmdir --ignore-fail-on-non-empty -p "$dayDir";
      done;
    fi;
  done;
}

usage() {
  cat <<-EndOfUsage
  $0: [-a|YYYYmmdd]

  Remove empty directories in dirtree "${camDir}".

  -a            walk complete dirtree
  YYYYmmdd      walk ${camDir}/wyze*/YYYYmmdd/

Default:        walk yesterdays and todays dirtree
EndOfUsage
}

if test -n "$1"; then
  case "$1" in
  "-h"|"--help")
    usage;
  ;;
  "-a")
    date="";
    cleanup "$date";
  ;;
  *)
    date="$1";
    cleanup "$date";
  ;;
  esac;
else
  date="$(date --date=yesterday +"%Y%m%d")";
  cleanup "$date";
  date="$(date --date=today +"%Y%m%d")";
  cleanup "$date";
fi;

### EOF
### vim:tw=80:et:sts=2:st=2:sw=2:com+=b\:###:fo+=cqtrw:tags=tags:
