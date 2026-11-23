
# Härdningsrapport

**Beskrivning:** Detta skriptet och Härdningen är en sammanfattning av våra arbeten eftersom mycket av våra checks är liknande, Därför skulle våra egna beskrivningar bli samma. Skriptet är modifierat för att fungera på allas servrar.

[Script: /script/verifiera-hardning.sh](../script/verifiera-hardning.sh)
```bash
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
```

| Åtgärd | Motivering | Förväntad effekt | Hur verifierad | Skript? |
|--------|------------|------------------|----------------|---------|
| SELinux står i Enforcing, nu och efter omstart | I permissive loggas överträdelser men stoppas inte. `setenforce` gäller bara tills nästa omstart, så läget måste också stå i `/etc/selinux/config`. | Policyn stoppar överträdelser, även efter omstart. | `getenforce` ger `Enforcing`. `grep ^SELINUX= /etc/selinux/config` ger `SELINUX=enforcing`. | Ja, två kontroller i `verifiera-hardning` |
| zonvakt körs under en egen tvingande policy (`zonvakt_t`) | Utan policy kör tjänsten som root i `unconfined_service_t` och får skriva i `/etc`, eftersom DAC inte stoppar root. MAC begränsar den till det den behöver. | `overtrad` nekas och ingen fil skapas i `/etc`. | `ps -eZ` visar `zonvakt_t`. `semanage permissive -l` listar inte `zonvakt_t`. `ausearch` visar nekandet med `permissive=0`. | ja |
| `/srv/zonwebb` har en bestående filkontext (`semanage fcontext` + `restorecon`) | `chcon` försvinner vid relabel. En regel med `semanage` tål den. | httpd kan läsa katalogen även efter en relabel. | `ls -dZ /srv/zonwebb` visar `httpd_sys_content_t`. `semanage fcontext -l -C` visar regeln. | Ja, `ls -dZ`-kontrollen finns i skriptet |
