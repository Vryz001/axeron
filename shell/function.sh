export AXERON=true
export CORE="d8a97692ad1e71b1"
export EXECPATH=$(dirname $0)
export PACKAGES=$(cat /sdcard/Android/data/com.fhrz.axeron/files/packages.list)
this_core=$(dumpsys package "com.fhrz.axeron" | grep "signatures" | cut -d '[' -f 2 | cut -d ']' -f 1)

check_axeron() {
  if ! echo "$CORE" | grep -q "$this_core"; then
    echo "$w You must use the original version of Axeron"
    exit 0
  fi
}

shellstorm() {
api=$1
path=$2
am startservice -n com.fhrz.axeron/.ShellStorm --es api $api --es path $path > /dev/null
while [ ! -f $path/response ]; do :; done;
cat $path/response
}
