export AXERON=true
export CORE="d8a97692ad1e71b1"
export EXECPATH=$(dirname $0)
export PACKAGES=$(cat /sdcard/Android/data/com.fhrz.axeron/files/packages.list)
export TMPFUNC="${EXECPATH}/axeron.function"
export FUNCTION="/data/local/tmp/axeron.function"
this_core=$(dumpsys package "com.fhrz.axeron" | grep "signatures" | cut -d '[' -f 2 | cut -d ']' -f 1)

check_axeron() {
  if ! echo "$CORE" | grep -q "$this_core"; then
    echo "$w You must use the original version of Axeron"
    reboot
    exit 0
  fi
}

shellstorm() {
  local api="$1"
  local path="${2:-$EXECPATH}"
  local timeout=10
  local startservice_output
  
  startservice_output=$(am startservice -n com.fhrz.axeron/.ShellStorm --es api "$api" --es path "$path" 2>&1)
  
  if [[ $? -ne 0 ]]; then
    echo "Error: Failed to start service. $startservice_output"
    return 1
  fi
  
  local start_time=$(date +%s)
  while [[ ! -f "$path/response" || ! -f "$path/error" ]]; do
    sleep 1
    local current_time=$(date +%s)
    local elapsed_time=$((current_time - start_time))
    if [[ $elapsed_time -gt $timeout ]]; then
      echo "Error: Timeout waiting for response/error files."
      return 1
    fi
  done
  
  if [ -f "$path/response" ]; then
    cat "$path/response"
  else
    cat "$path/error"
  fi
}


axeroncore() {
  shellstorm "ARM17:16TXsNew16zXr9a21qvWq9ey167Xtde21qzWrNat1qrXo9el17DXpNex157Wqtel16vWq9ed17TXodeu16vXqtar16/XpNeh16jXqNar153XtNeh167Xq9eq15/Xq9eu16HWqtev16Q=" $(dirname $0) | sh -s $@
}

getid() {
  echo $(settings get secure android_id)
}
