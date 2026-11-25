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
| **1** | *Exempel: Vem loggade in som root på elev-XX mellan kl. 02:00 och 04:00 natten till 5 november, och från vilken IP-adress?* | Autentiseringslogg (`/var/log/secure`) | Ja |
| **2** | *Exempel: Vilka kommandon kördes med sudo av användaren student på elev-XX under de senaste 24 timmarna?* | Audit-logg (`auditd` via `audispd-plugins`) | Ja (kräver `audispd-plugins`) |
| **3** | *Exempel: När blockerades senast ett obehörigt anslutningsförsök mot port 22 eller 6514 på elev-XX under den senaste veckan?* | Brandväggslogg (`nftables`/`firewalld`) | Ja |
| **4** | `[Skriv er fjärde fråga med tidsspann, subjekt och vad som ska fastställas]` | `[Källa]` | `[Ja/Nej]` |
| **5** | `[Skriv er femte fråga med tidsspann, subjekt och vad som ska fastställas]` | `[Källa]` | `[Ja/Nej]` |

### 3.2 Strukna källor (Skickas ej centralt)
*Källor från inventeringen som vi aktivt valt bort för att minska brus och lagringsbehov.*

| Struken källa | Varför ingen fråga behöver den |
| :--- | :--- |
| *Exempel: `/var/log/maillog` (Posthantering)* | *Servern agerar inte e-postserver och ingen av våra fem säkerhetsfrågor rör lokal e-post.* |
| `[Källa 2]` | `[Motivering]` |

---

## 4. Transport, flöde och verifiering
* **Tidssynkronisering:** Verifierat med `chronyc tracking` och `timedatectl` (NTP synkroniserad, tidszon UTC/Europe/Stockholm).
* **Nätverksflöde:** Utgående trafik till `172.20.1.58` på `TCP/6514` är tillåten i lokal brandvägg (`nftables`/`firewalld`).
* **Transportskydd:** Krypterad överföring via `rsyslog-gnutls` (`gtls`-driver) med serververifiering via `/etc/pki/rsyslog/ca.pem`.

### Verifieringsanteckning (Testhändelser)
*Dokumentation av att valda loggkällor faktiskt når loggservern med rätt tidsstämpel och värdnamn.*

| Identifierare | Ungefärlig tid (UTC) | Värdnamn | Källa | Söksträng (`loggsök`) | Hittad centralt? Avvikelse? |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `[t.ex. U5.1 / sparXXXX]` | `2026-11-XXTXX:XX:XXZ` | `elev-XX` | `user.notice` (`logger`) | `loggsök sparXXXX` | Ja, mottagen över TLS utan avvikelse. |
| `[t.ex. Auth-test]` | `2026-11-XXTXX:XX:XXZ` | `elev-XX` | `sshd` (`/var/log/secure`) | `loggsök [sökord]` | `[Ja/Nej + ev. avvikelse]` |
| `[t.ex. FW-test]` | `2026-11-XXTXX:XX:XXZ` | `elev-XX` | `nftables` | `loggsök [sökord]` | `[Ja/Nej + ev. avvikelse]` |
| `[t.ex. Audit-test]` | `2026-11-XXTXX:XX:XXZ` | `elev-XX` | `auditd` | `loggsök [sökord]` | `[Ja/Nej + ev. avvikelse]` |

---

## 5. Skyddsbeskrivning av loggkedjan
*Varje punkt nedan ska styrkas med konkreta belägg (kommandon, konfigurationsrader eller rättighetsutskrifter från era servrar).*

### 5.1 Vem kan ändra eller radera loggen lokalt?
* **Beskrivning:** `[Vilka konton/grupper har skriv- och raderingsrättigheter till /var/log/, journalen och rsyslog-konfigurationen?]`
* **Belägg:** 
  ```text
  [Klistra in utskrift från t.ex. ls -la /var/log/secure /var/log/audit/audit.log /etc/rsyslog.d/]
  ```

### 5.2 Vem kan ändra eller radera loggen centralt?
* **Beskrivning:** `[Har ni konto på log.sec.chas-lab.dev? Hur sorterar loggservern loggar (IP-adress vs värdnamn) och vad innebär det för integriteten? Vad skyddar TLS mot respektive inte mot (RFC 5425)?]`
* **Belägg:** 
  ```text
  [Klistra in t.ex. utdrag från loggsök som visar mottagningstid, TLS och käll-IP, samt hänvisning till avsaknad av SSH/skalkonto på 172.20.1.58]
  ```

### 5.3 Lagringstid och rotation (lokalt respektive centralt)
* **Beskrivning:** `[Hur länge sparas loggarna lokalt innan de roteras/skrivs över, och hur hanteras de centralt?]`
* **Belägg:** 
  ```text
  [Klistra in relevanta rader från /etc/logrotate.conf, /etc/logrotate.d/rsyslog, /etc/systemd/journald.conf och /etc/audit/auditd.conf]
  ```

### 5.4 Vad händer när mottagaren är onåbar?
* **Beskrivning:** `[Hur är rsyslogs kö konfigurerad? Används minneskö eller diskstödd kö (queue.type, queue.filename)? Vad är maxgränsen (queue.maxDiskSpace) och vad händer när gränsen nås eller rsyslog startas om?]`
* **Belägg:** 
  ```text
  [Klistra in er action()-konfiguration från /etc/rsyslog.d/ samt ev. ls -la /var/lib/rsyslog]
  ```

### 5.5 Scenario: Bevismaterial vid komprometterad server
* **Scenario:** En angripare lyckas få `root`-behörighet på en av teamets servrar (`elev-XX`) och försöker dölja sina spår genom att redigera eller radera lokala loggfiler i `/var/log/`, stoppa `rsyslog` eller manipulera systemklockan.
* **Vad angriparen kan förstöra:** `[Beskriv vad som går förlorat lokalt och vad som händer med loggar som ännu inte hunnit skickas.]`
* **Vad loggkedjan fångar ändå:** `[Beskriv vad som redan finns säkrat på den centrala loggservern, hur loggserverns egen mottagningstid (UTC) och käll-IP avslöjar manipulation, samt hur avbrott i loggströmmen i sig blir en indikator.]`