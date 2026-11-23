
# Härdningsrapport



| Nr | Åtgärd | Motivering | Förväntad effekt | Hur verifierad | Skript? |
|----|--------|------------|------------------|----------------|---------|
| 1 | SELinux står i Enforcing, nu och efter omstart | I permissive loggas överträdelser men stoppas inte. `setenforce` gäller bara tills nästa omstart, så läget måste också stå i `/etc/selinux/config`. | Policyn stoppar överträdelser, även efter omstart. | `getenforce` ger `Enforcing`. `grep ^SELINUX= /etc/selinux/config` ger `SELINUX=enforcing`. | Ja, två kontroller i `verifiera-hardning` |
| 2 | zonvakt körs under en egen tvingande policy (`zonvakt_t`) | Utan policy kör tjänsten som root i `unconfined_service_t` och får skriva i `/etc`, eftersom DAC inte stoppar root. MAC begränsar den till det den behöver. | `overtrad` nekas och ingen fil skapas i `/etc`. | `ps -eZ` visar `zonvakt_t`. `semanage permissive -l` listar inte `zonvakt_t`. `ausearch` visar nekandet med `permissive=0`. | Delvis: `ps`-kontrollen finns i skriptet |
| 3 | `/srv/zonwebb` har en bestående filkontext (`semanage fcontext` + `restorecon`) | `chcon` försvinner vid relabel. En regel med `semanage` tål den. | httpd kan läsa katalogen även efter en relabel. | `ls -dZ /srv/zonwebb` visar `httpd_sys_content_t`. `semanage fcontext -l -C` visar regeln. | Ja, `ls -dZ`-kontrollen finns i skriptet |
