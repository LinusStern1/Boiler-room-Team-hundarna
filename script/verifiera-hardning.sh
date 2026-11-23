#!/usr/bin/env bash
fel=0
elevnummer=$(hostname | awk -F - '{print $2}')
kolla() {
  if eval "$2" >/dev/null 2>&1; then
    echo "GÄLLER $1"
  else
    echo "GÄLLER INTE $1"
    fel=1
  fi
}

kolla "SELinux körs i enforcing nu" '[ "$(getenforce)" = "Enforcing" ]'
kolla "SELinux är enforcing efter omstart (config)" 'grep -q "^SELINUX=enforcing" /etc/selinux/config'
kolla "zonvakt kör i domänen zonvakt_t" 'ps -eZ | grep -q "zonvakt_t.*zonvakt"'
kolla "zonvakt startar vid boot (enabled)" '[ "$(systemctl is-enabled zonvakt)" = "enabled" ]'
kolla "zonvakt lyssnar på tcp/75$elevnummer" 'ss -tln | grep -q ":75${elevnummer}"'
kolla "/srv/zonwebb har kontexten httpd_sys_content_t" 'ls -dZ /srv/zonwebb | grep -q httpd_sys_content_t'

exit $fel
