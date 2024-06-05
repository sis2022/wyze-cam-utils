#!/bin/bash

m=( "$@" )
#res="320";
res="640";
xres="$res";
yres="$res";
thumbBase="${HOME}/NAS";
camDir="/cams";
declare -a younglings;
td="";

genTargetD() {
  local path="";
  if test -d "$1"; then
    path="$1";
  elif [[ "$1" =~ .*/$ ]]; then
    path="$1";
  elif test -f "$1" -a -s "$1"; then
    path="$(dirname "$1")";
  fi;

  td="${thumbBase}$path";
  td="${td/cams/$res/cams}";
}

genThumb() {
  genTargetD "$1";
  local tf;
  tf="$(basename "$1")";
  local t="${td}/${tf%%.mp4}_thumb.jpg";

  test ! -d "$td" && mkdir -p "$td";
  test -f "$t" && return;
  test -L "$t" && return;
  ffmpeg -ss 00:00:01.00 -i "$1" \
    -vf "scale=${xres}:${yres}:force_original_aspect_ratio=decrease" \
    -vframes 1 "$t";
}

getLatest() {
  for i in "${m[@]}"; do
    genTargetD "$i";
    for d in $(find "$td" -type d | sort | tail -1); do
      find "$d" -type f -iname "*.jpg" | sort | tail -1;
      while IFS='' read -r line; do younglings+=("$line"); done < <(find "$d" -type f -iname "*.jpg" | sort | tail -1;)
     done;
  done;
}


### MAIN
walkTree() {
  for cam in "${camDir}"/wyze*/; do
    d="${cam}/$1"
    if test -d "$d"; then
      for f in $(find "$d" -type f -iname "*.mp4" | sort); do
        genThumb "$f";
      done;
    fi;
  done;
}

usage() {
  cat <<-EndOfUsage
  $0: [-a|YYYYmmdd]

  Generate thumbnails in dirtree "${camDir}".

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
    walkTree "$date";
  ;;
  *)
    date="$1";
    walkTree "$date";
  ;;
  esac;
else
  date="$(date --date=yesterday +"%Y%m%d")";
  walkTree "$date";
  date="$(date --date=today +"%Y%m%d")";
  walkTree "$date";
fi;

### EOF
### vim:tw=80:et:sts=2:st=2:sw=2:com+=b\:###:fo+=cqtrw:tags=tags:
