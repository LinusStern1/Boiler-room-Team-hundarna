#!/usr/bin/env bash

# Kör de rader i testfall.csv där kalla = den här servern.
fil="${1:-testfall.csv}"
me=$(hostname -s)
echo "id,forvantat,faktiskt,resultat"
tr -d '\r' < "$fil" | tail -n +2 | while IFS=, read -r id kalla dest port proto riktn forv _; do
  [ "$kalla" = "$me" ] || continue
  timeout 3 bash -c "exec 3<>/dev/tcp/$dest/$port" 2>/dev/null
  rc=$?
  case $rc in
    0)   utfall=oppen ;;
    124) utfall=tyst ;;
    *)   utfall=avvisad ;;
  esac
  [ "$utfall" = "$forv" ] && res=PASS || res=FAIL
  echo "$id,$forv,$utfall,$res"
done