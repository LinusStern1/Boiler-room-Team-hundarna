# Loggstrategi – Version 1.0
**Servrar som omfattas:** elev-18, elev-23, elev-31, elev-41
**Central loggserver:** `log.sec.chas-lab.dev` (`172.20.1.58`, TCP 6514 TLS)  

>Denna filen är under konstruktion.
---

## 1. Syfte och mål med centralloggningen
*Insamling av loggar sker för att skapa och övervaka en säker digital miljö som vi kan arbeta i och lära oss av.*
- Säkerhetsloggning och analys (4 kap. 21–22 §§).
- Robust och korrekt tidssynkronisering via NTP/chrony (4 kap. 23 §).
- Krypterad överföring med TLS på port 6514 (4 kap. 25 §).

---

## 2. Loggkällekarta (Inventering)
*Inventering av lokala loggkällor på servrarna.*

| Källa | Var/hur den läses | Exempelrad | Vilken fråga den besvarar | Tidsformat |
| :--- | :--- | :--- | :--- | :--- |
| **Systemlogg (journald)** | `journalctl` / `/var/log/messages` | `Nov 24 16:25:28 elev-18 audisp-syslog[619]: type=SYSCALL...` | Vilka systemhändelser, tjänstfel eller omstarter har skett? | RFC 3164 |
| **Autentiseringslogg** | `/var/log/secure` / `journalctl -u sshd` | `Nov 22 23:24:30 elev-18 sshd-session[7424]: Accepted publickey for root from...` | Vem loggade in (lyckat/misslyckat), när och från vilken IP? | RFC 3164 |
| **Brandväggslogg** | `journalctl -k` / `/var/log/messages` (nftables/firewalld) | `Nov 19 11:06:05 elev-18 kernel: Linux version 5.14.0-687.54.1.el9_8.x86_64...` | Vilken nätverkstrafik har blockerats eller tillåtits? | RFC 3164 |
| **Audit-logg (auditd)** | `/var/log/audit/audit.log` (`ausearch`) | `type=CWD msg=audit(11/24/2026 16:42:23.842:2043) : cwd=/home/student` | Vilka privilegierade kommandon (`root`) har körts och av vilket `auid`? | Unix epoch |

---

## 3. Frågestyrt urval

### 3.1 Fem frågor som ska kunna besvaras
| Nr | Fråga (tidsspann, subjekt, vad som ska fastställas) | Källor som krävs | Går att besvara idag? (Ja/Nej + ev. åtgärd) |
| :--- | :--- | :--- | :--- |
| **1** | Vem loggade in som root på elev-XX mellan kl. 02:00 och 04:00 natten till 5 november, och från vilken IP-adress? | Autentiseringslogg (`/var/log/secure`) | Ja |
| **2** | Vilka kommandon kördes med sudo av användaren student på elev-XX under de senaste 24 timmarna? | Audit-logg (`auditd` via `audispd-plugins`) | Ja (kräver `audispd-plugins`) |
| **3** | När blockerades senast ett obehörigt anslutningsförsök mot port 22 eller 6514 på elev-XX under den senaste veckan? | Brandväggslogg (`nftables`/`firewalld`) | Ja |
| **4** | Vilka root-kommandon kördes av en inloggad användare på elev-XX den senaste veckan, och av vilket auid? | Audit-logg | Ja |
| **5** | Nådde en viss källa (t.ex. 172.20.1.10) fram till loggservern med TLS-krypterad trafik, eller gick något i klartext på port 514? | rsyslog-konfiguration & brandväggslogg | Ja |

### 3.2 Strukna källor (Skickas ej centralt)
*Källor från inventeringen som vi aktivt valt bort för att minska brus och lagringsbehov.*

| Struken källa | Varför ingen fråga behöver den |
| :--- | :--- |
| /var/log/maillog (Posthantering) | Servern agerar inte e-postserver och ingen av våra fem säkerhetsfrågor rör lokal e-post. |
| /var/log/cron (time-based job scheduler.) | Inga av våra säkerhetsfrågor rör tidslaggda jobb och fokuset ligger på aktivt skydd. |

---

## 4. Transport, flöde och verifiering
* **Tidssynkronisering:** Verifierat med `chronyc tracking` och `timedatectl` (NTP synkroniserad, tidszon UTC/Europe/Stockholm).
* **Nätverksflöde:** Utgående trafik till `172.20.1.58` på `TCP/6514` är tillåten i lokal brandvägg (`nftables`/`firewalld`).
* **Transportskydd:** Krypterad överföring via `rsyslog-gnutls` (`gtls`-driver) med serververifiering via `/etc/pki/rsyslog/ca.pem`.

### Verifieringsanteckning (Testhändelser)
*Dokumentation av att valda loggkällor faktiskt når loggservern med rätt tidsstämpel och värdnamn.*

| Identifierare | Ungefärlig tid (UTC) | Värdnamn | Källa | Söksträng (`loggsök`) | Hittad centralt? Avvikelse? |
| :--- | :--- | :--- | :--- | :--- | :--- |
| U5.1 / sparXXXX | 2026-11-25T10:29:39.017Z | elev-18 | logger | loggsök spar4... | Ja, mottagen över TLS utan avvikelse. |
| Auth-test | 2026-11-25T07:52:58.203Z | elev-18 | elev-18 sshd-session[11003] | loggsök giltigTest12 | Ja + T1110 Test |
| Brandvägg | 2026-11-25T09:18:09.705Z | elev-18 | ZON-IN-DROP, nftables | loggsök ZON-IN-DROP | Ja, mottagen över TLS utan avvikelse. |
| Audit-test | 2026-11-25T10:16:49.170Z | elev-18 | auditd | loggsök logtest-elev18 | Ja, mottagen över TLS utan avvikelse. |

---

## 5. Skyddsbeskrivning av loggkedjan
*Varje punkt nedan ska styrkas med konkreta belägg (kommandon, konfigurationsrader eller rättighetsutskrifter från era servrar).*

### 5.1 Vem kan ändra eller radera loggen lokalt?
* **Beskrivning:** Vilka konton/grupper har skriv och raderingsrättigheter till /var/log/, journalen och rsyslog-konfigurationen?
* **Belägg elev-XX server:** `sudo ls -la /var/log/audit/audit.log`
  ```text
  -rw-------. 1 root root 6260016 Nov 25 09:26 /var/log/audit/audit.log
  ```

### 5.2 Vem kan ändra eller radera loggen centralt?
* **Beskrivning:** Vi har inget konto på `log.sec.chas-lab.dev` och kan därför inte logga in på servern. Vår enda åtkomst är läsning av våra egna rader via `loggsök` på jump-servern. Vi vet inte vilka administratörskonton som finns på loggservern eller vem av kursens personal som kan ändra/radera data där det ligger utanför vår synlighet.
* **Belägg:** `ssh log.sec.chas-lab.dev`,`logger -p user.notice -t sparbarhet "jag-later-som-elev-99 test-sortering-elev18"`
  ```text
  Host key verification failed.
  mottaget 2026-11-25T10:23:33.205Z TLS      | 2026-11-25T10:23:32.942629+00:00 172.20.1.118 elev-18 sparbarhet[11157] jag-later-som-elev-99 test-sortering-elev18
  ```

### 5.3 Lagringstid och rotation (lokalt respektive centralt)
* **Beskrivning:** Hur länge sparas loggarna lokalt innan de roteras/skrivs över, och hur hanteras de centralt?
* **Belägg:** 
  ```bash
  $ cat /etc/logrotate.d/rsyslog
  $ grep -i storage /etc/systemd/journald.conf
  $ sudo grep -i max_log_file /etc/audit/auditd.conf
  ```

  ```text
  # rsyslog
  /var/log/cron
  /var/log/maillog
  /var/log/messages
  /var/log/secure
  /var/log/spooler
  {
    missingok
    sharedscripts
    postrotate
        /usr/bin/systemctl -s HUP kill rsyslog.service >/dev/null 2>&1 || true
    endscript
  }
  # grep -i storage
  #Storage=auto

  # sudo grep i- max_log_file
  max_log_file = 8
  max_log_file_action = ROTATE
  ```

### 5.4 Vad händer när mottagaren är onåbar?
* **Beskrivning:** Hur är rsyslogs kö konfigurerad? Används minneskö eller diskstödd kö (queue.type, queue.filename)? Vad är maxgränsen (queue.maxDiskSpace) och vad händer när gränsen nås eller rsyslog startas om?
* **Belägg:** `cat /etc/rsyslog.d/90-logg.conf`,`sudo ls -la /var/lib/rsyslog`
  ```text
  # 90-logg.conf
  global(DefaultNetstreamDriverCAFile="/etc/pki/rsyslog/ca.pem")
  action(type="omfwd" target="172.20.1.58" port="6514" protocol="tcp"
        template="RSYSLOG_SyslogProtocol23Format"
        StreamDriver="gtls" StreamDriverMode="1" StreamDriverAuthMode="x509/name"
        StreamDriverPermittedPeers="log.sec.chas-lab.dev"
        queue.type="LinkedList" queue.filename="fwd" queue.saveOnShutdown="on"
        action.resumeRetryCount="-1")
  
  # rsyslog
  total 744
  drwx------.  2 root root   4096 Nov 25 09:58 .
  drwxr-xr-x. 30 root root   4096 Nov 17 10:58 ..
  -rw-------.  1 root root 747631 Nov 19 11:08 fwd.00000001
  -rw-------.  1 root root    124 Nov 25 09:58 imjournal.state
  ```

### 5.5 Scenario: Bevismaterial vid komprometterad server
* **Scenario:** En angripare lyckas få `root`-behörighet på en av teamets servrar (`elev-XX`) och försöker dölja sina spår genom att redigera eller radera lokala loggfiler i `/var/log/`, stoppa `rsyslog` eller manipulera systemklockan.
* **Vad angriparen kan förstöra:** Angriparen kan ta bort och ändra lokala filer men datan som skickas över TLS till centrala loggsevern kan inte ändras.
* **Vad loggkedjan fångar ändå:** Om angriparen stoppar loggar från att komma över till den centrala loggserven så märks det av både på servern och Wazuh. Trafiken försvinner och ett larm kan skapas.