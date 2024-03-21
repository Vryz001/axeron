export AXERON=true; export CORE="d8a97692ad1e71b1"; export EXECPATH=$(dirname $0); export PACKAGES=$(cat ${EXECPATH}/packages.list)
this_core=$(dumpsys package "com.fhrz.axeron" | grep "signatures" | cut -d '[' -f 2 | cut -d ']' -f 1)
if ! echo "$CORE" | grep -q "$this_core"; then; echo "$w You must use the original version of Axeron"; exit 0; fi
!myCommands
