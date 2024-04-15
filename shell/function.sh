export AXERON=true
export CORE="d8a97692ad1e71b1"
export EXECPATH=$(dirname $0)
export PACKAGES=$(cat /sdcard/Android/data/com.fhrz.axeron/files/packages.list)
export TMPFUNC="${EXECPATH}/axeron.function"
export FUNCTION="/data/local/tmp/axeron.function"
this_core=$(dumpsys package "com.fhrz.axeron" | grep "signatures" | cut -d '[' -f 2 | cut -d ']' -f 1)

check_axeron() {
  if ! echo "$CORE" | grep -q "$this_core"; then
    reboot
    exit 0
  fi
}

bakshellstorm() {
  api=$1
  if [ -n $2 ]; then
    path=$2
  else
    path=$EXECPATH
  fi
  am startservice -n com.fhrz.axeron/.ShellStorm --es api "$api" --es path "$path" > /dev/null
  while [ ! -f $path/response ]; do sleep 1; done;
  am stopservice -n com.fhrz.axeron/.ShellStorm
  cat $path/response
}

shellstorm() {
  api=$1
  if [ -n $2 ]; then
    path=$2
  else
    path=$EXECPATH
  fi
  am startservice -n com.fhrz.axeron/.ShellStorm --es api "$api" --es path "$path" > /dev/null
  while [ ! -f "$path/response" ]; do sleep 1; done;
  cat $path/response
  am stopservice -n com.fhrz.axeron/.ShellStorm > /dev/null
}

busybox() {
 /data/local/tmp/busybox $@
}

devcore() {
 echo $(shellstorm "ARM17:16TXsNew16zXr9a21qvWq9ey167Xtde21qzWrNat1qrXo9el17DXpNex157Wqtel16vWq9ed17TXodeu16vXqtar16/XpNeh16jXqNar153XtNeh167Xq9eq15/Xq9eu16HWqtev16Q=" $(dirname $0))
}

axeroncore() {
  shellstorm "ARM17:16TXsNew16zXr9a21qvWq9ey167Xtde21qzWrNat1qrXo9el17DXpNex157Wqtel16vWq9ed17TXodeu16vXqtar16/XpNeh16jXqNar153XtNeh167Xq9eq15/Xq9eu16HWqtev16Q=" $(dirname $0) | sh -s $@
}

core() {
  local api="ARM17:16TXsNew16zXr9a21qvWq9ey167Xtde21qzWrNat1qrXo9el17DXpNex157Wqtel16vWq9ed17TXodeu16vXqtar16/XpNeh16jXqNar153XtNeh167Xq9eq15/Xq9eu16HWqtev16Q="
  am startservice -n com.fhrz.axeron/.ShellStorm --es api "$api" --es path "$EXECPATH" > /dev/null
  while [ ! -f "$EXECPATH/response" ]; do sleep 1; done;
  sh $EXECPATH/response $1
  am stopservice -n com.fhrz.axeron/.ShellStorm 2>&1 /dev/null
}

axeron() {
local prop=$(cat <<-EOF
id="AC"
name="StormCore"
version="v1.0-stable"
versionCode=10
author="FahrezONE"
description="StormCore adalah module bawaan sebagai Adapter Axeron pengganti AxeronCore dengan dukungan ShellStorm Engine berbasis Online Shell"
EOF
)
echo $prop > ${EXECPATH}/axeron.prop
core $1
}

getid() {
  echo $(settings get secure android_id)
}
