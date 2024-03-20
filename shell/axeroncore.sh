#!/system/bin/sh
#FahrezONE Dev

w="[ ! ]" #warn
i="[ ? ]" #info
p="[ • ]" #process
s="[ ✓ ]" #success
parent_app="$1"
dev_sign="$2"
brevent="me.piebridge.brevent"
axeron="com.fhrz.axeron"
termux="com.termux"
shizuku="moe.shizuku.privileged.api"
host="vryz001.github.io"
host_path="/axeron/Core2401.txt"
id_path="/axeron/id_1.txt"
log_path="/sdcard/Android/data/${axeron}/files"
log_file="${log_path}/log.txt"
this_core=$(dumpsys package ${axeron} | grep "signatures" | cut -d '[' -f 2 | cut -d ']' -f 1)
echo $(cd $(pwd) && cat axeron.prop)
axeron_core=$(cd $(pwd) && cat axeron.prop)
dev=$(echo "$axeron_core" | grep -o 'key:dev=".*";' | cut -d '"' -f2)
axeron_core=${axeron_core//\$pkg/$1}
vCode=4001
vName="Auto Update"
vAxeron=10240121
androidId=$(settings get secure android_id)

core_info=$(cat <<-EOF
Optione {
  key:versionCode=${vCode};
  key:versionAxeron=${vAxeron};
  key:androidId="$androidId";
  key:host="$host";
  key:hostPath="$host_path";
  key:idPath="$id_path";
  key:versionName="$vName";
  key:axeronSupport=${vAxeron};
}
EOF
)

join_channel() {
  sleep 1
  link="https://t.me/fahrezone_ch"
  am start -a android.intent.action.VIEW -d "$link" > /dev/null 2>&1
}

c_exit() {
  echo ""
  core_path="/sdcard/Android/data/${axeron}/files/core.sh"
  [ -f "$core_path" ] && rm -f "$core_path" > /dev/null 2>&1
  exit 0
}

optimize_app() {
  for package in $(echo $PACKAGES | cut -d ":" -f 2); do
      if [ "$package" = "$brevent" ] || [ "$package" = "$axeron" ] || [ "$package" = "$termux" ] || [ "$package" = "$shizuku" ] || [ "$package" = "$parent_app" ]; then
        continue
      else
        cache_path="/sdcard/Android/data/${package}/cache"
        [ -e "$cache_path" ] && rm -rf "$cache_path" > /dev/null 2>&1
        am force-stop "$package" > /dev/null 2>&1
      fi
  done
}

echo ""
if [ ! "$AXERON" ]; then
    echo "$w This Core only can Executed in Axeron"
    c_exit
fi

if ! echo "$CORE" | grep -q "$this_core"; then
    echo "$w You must use the original version of Axeron"
    join_channel
    c_exit
fi

if [ ! "$dev" == "$dev_sign" ]; then
    echo "$w Developer signature is invalid"
    c_exit
fi

if [ -n "$parent_app" ]; then
  if echo $PACKAGES | grep -qw "$parent_app"; then
    sleep 1
  else
    echo "$w PackageName is not detected or installed" && c_exit
  fi
else
  echo "$w PackageName is empty" && c_exit
fi

mkdir -p "$log_path"

current_time=$(date +%s%3N)
last_time=$(cat "$log_file") > /dev/null 2>&1
time_diff=$((current_time - last_time))

check_optimize() {
  if [ "$1" -ge 3600000 ] || [ ! -e "$log_file" ]; then
    echo "$p Optimizing AxeronCore"
    optimize_app
    echo -n "$current_time" > "$log_file"
  fi
}

check_optimize $time_diff

if command -v am > /dev/null && command -v pm > /dev/null; then
  echo "$p Executing AxeronCore [${vName}(${vCode})]" && sleep 1
else
  echo "$w ActivityManager & PackageManager not Permitted" && c_exit
fi

if echo $PACKAGES | grep -qw "$axeron"; then
  echo "$s Axeron is detected [Fast Connect]" && sleep 1
else
  echo "$w Axeron not Installed"
  echo "$i Please download Axeron app from FahrezONE officially"
  join_channel
  c_exit
fi

sleep 1 && am start -a android.intent.action.VIEW -d "axeron:adaptor" -n "com.fhrz.axeron/.Process" --es AXERON "$axeron_core" --es CORE "$core_info" > /dev/null 2>&1 || echo "$w Failed to open Axeron"
c_exit
