# Adressplan för 10.40.0.0/16

## Förutsättningar
- Uppdragsgivarens adressutrymme: 10.40.0.0/16 (RFC 1918)
- Planen omfattar endast IPv4. IPv6 är avstängt på labbservrarna.
- Antalet har räknats upp med ca 25 % tillväxt innan prefix valdes.
- Nät är sorterade i storleksordning (störst först) så att de kan summeras.
- Ingen rad utan uträkning. Alla rader är kontrollerade med `ipcalc --all`.

## Tabell över adressplan

| Prefix | Syfte | Adressintervall (första–sista) | Ansvarig tjänst | Reserverat utrymme | Kommentar / Uträkning |
|---|---|---|---|---|---|
| 10.40.0.0/24 | Klienter | 10.40.0.1 – 10.40.0.254 | DHCP | Nej | **Uträkning:** 120 idag + 25 % = 150. 150 + nät + broadcast = 152 -> 256. 32 − 24 = 8 värdbitar. 2⁸ = 256 adresser (254 användbara). Nätverk: 10.40.0.0, Broadcast: 10.40.0.255. |
| 10.40.1.0/26 | Gäst och besök | 10.40.1.1 – 10.40.1.62 | DHCP (gästnät) | Nej | **Uträkning:** 40 + 25 % = 50. 52 -> 64. 32 − 26 = 6 värdbitar. 2⁶ = 64 adresser (62 användbara). Nätverk: 10.40.1.0, Broadcast: 10.40.1.63. |
| 10.40.1.64/27 | Servrar | 10.40.1.65 – 10.40.1.94 | Applikationsservrar | Nej | **Uträkning:** 14 + 25 % = 18. 20 -> 32. 32 − 27 = 5 värdbitar. 2⁵ = 32 adresser (30 användbara). Nätverk: 10.40.1.64, Broadcast: 10.40.1.95. |
| 10.40.1.96/28 | Drift och administration | 10.40.1.97 – 10.40.1.110 | Administration (jump-server) | Nej | **Uträkning:** 6 + 25 % = 8. 10 -> 16. 32 − 28 = 4 värdbitar. 2⁴ = 16 adresser (14 användbara). Nätverk: 10.40.1.96, Broadcast: 10.40.1.111. |
| 10.40.1.112/29 | Databaser | 10.40.1.113 – 10.40.1.118 | Databastjänst | Nej | **Uträkning:** 4 + 25 % = 5. 7 -> 8. 32 − 29 = 3 värdbitar. 2³ = 8 adresser (6 användbara). Nätverk: 10.40.1.112, Broadcast: 10.40.1.119. |
| 10.40.1.120/29 | DMZ | 10.40.1.121 – 10.40.1.126 | Publik webbtjänst | Nej | **Uträkning:** 4 + 25 % = 5. 7 -> 8. 32 − 29 = 3 värdbitar. 2³ = 8 adresser (6 användbara). Nätverk: 10.40.1.120, Broadcast: 10.40.1.127. |
| 10.40.1.128/29 | Logg och övervakning | 10.40.1.129 – 10.40.1.134 | Loggning/övervakning | Nej | **Uträkning:** 3 + 25 % = 4. 6 -> 8. 32 − 29 = 3 värdbitar. 2³ = 8 adresser (6 användbara). Nätverk: 10.40.1.128, Broadcast: 10.40.1.135. |
| 10.40.1.136/30 | Länknät 1 (router–router) | 10.40.1.137 – 10.40.1.138 | Routing | Nej | **Uträkning:** 2 adresser + nät + broadcast = 4. 32 − 30 = 2 värdbitar. 2² = 4 adresser (2 användbara). Nätverk: 10.40.1.136, Broadcast: 10.40.1.139. |
| 10.40.1.140/30 | Länknät 2 (router–router) | 10.40.1.141 – 10.40.1.142 | Routing | Nej | **Uträkning:** som länknät 1. Nätverk: 10.40.1.140, Broadcast: 10.40.1.143. |
| 10.40.1.144/30 | Länknät 3 (router–router) | 10.40.1.145 – 10.40.1.146 | Routing | Nej | **Uträkning:** som länknät 1. Nätverk: 10.40.1.144, Broadcast: 10.40.1.147. |
| 10.40.1.148 – 10.40.255.255 | **Reserverat** | – | Ej tilldelad | **Ja** | Allt utrymme efter sista nätet är reserverat för framtida behov. Får inte användas utan att planen uppdateras. |

## Nät som ska nå varandra

| Från | Till | Syfte |
|---|---|---|
| Klienter | Servrar, DMZ | Åtkomst till tjänster |
| DMZ | Databaser | Webbtjänst hämtar data |
| Servrar | Databaser | Applikationer använder databas |
| Drift och administration | Alla nät | Administration |
| Alla nät | Logg och övervakning | Loggning |
| Gäst och besök | (endast internet) | Isolerat från interna nät |


### **Flödestabell**


| ID | Flödesbeskrivning | Källzon (Source) | Målzon (Destination) | Protokoll | Port / Tjänst | Initiator / Riktning | Syfte & Kommentar |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Applikationsflöden (Pilar i skissen)** |
| **APP-01** | Webbanvändning | Client_Zone 10.40.0.0/24 | DMZ_Zone 10.40.1.120/29 | TCP | 443 (HTTPS) | Client → DMZ | Slutanvändare surfar till webbapplikationen. |
| **APP-02** | Databasfråga | DMZ_Zone 10.40.1.120/29 | Database_Zone 10.40.1.112/29 | TCP | 5432 (PostgreSQL) | DMZ → Database | Webbservren hämtar data från databasen. |
| **APP-02** | DatabasSvar | DMZ_Zone 10.40.1.120/29 | Client_Zone 10.40.0.0/24 | TCP | 443 (HTTPS) | DMZ → Client| webbservern svarar till användaren |
| **Infrastruktur- & Stödtjänstflöden** |
| **INF-01** | Namnuppslagning (DNS) | Alla zoner | Infra_Zone | UDP/TCP | 53 (DNS) | Alla → Infra | Alla enheter behöver kunna slå upp domännamn. |
| **INF-02** | Tidssynkronisering | Alla zoner | Infra_Zone | UDP | 323 (NTP) | Alla → Infra | Klocksynk för loggar och kerberos-autentisering. |
| **INF-03** | Paket- & OS-uppdatering | Alla zoner | Infra_Zone (WSUS/Mirror) | TCP | 80 / 443 | Alla → Infra | Hämtning av säkerhetsuppdateringar internt. |
| **INF-04** | Loggleverans (SIEM) | Alla zoner | Mgmt_Zone (SIEM) | UDP/TCP | 514 (Syslog) / 5044 | Alla → Mgmt | Enheter skickar händelseloggar till central loggserver. |
| **INF-05** | Admin via Jump-host | Mgmt_Zone (Jump) | Alla zoner | TCP | 22 (SSH) / 3389 (RDP) | Jump → Alla | Administratörer ansluter säkert via en Jump-box. |


# Praktisk Tabell

| ID | Flödesbeskrivning | Källzon (Source) | Målzon (Destination) | Protokoll | Port / Tjänst | Initiator / Riktning | Syfte & Kommentar |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| F1 | Internet > Ibrahim (Webb) | Internet (0.0.0.0/0) | Ibrahim Webb 10.40.3.65 | tcp | 443 / HTTPS | Internet > Webb (in) | Publik webbtjänst. Filtreras i moln och på värd |
| F2 | Simon (Client) > Ibrahim (Webb) | Simon Client 10.40.3.2 | Ibrahim Webb 10.40.3.65 | tcp | 443 / HTTPS | Client > Webb (ut på Client, in på Webb) | Användare når webben. |
| F3 | Ibrahim (Webb) > Linus (App) | Ibrahim Webb 10.40.3.65 | Linus App 10.40.3.129 | tcp | 8080 / App-API | Webb > App (ut på Webb, in på App) | Webben anropar applikationen. |
| F4 | Linus (App) > Mohammed (Databas) | Linus App 10.40.3.129 | Mohammed Databas 10.40.3.193 | tcp | 5432 / PostgreSQL | App > Databas (ut på App, in på Databas) | Endast appservern får nå databasen. |

## 4. Hur du ska tänka (Metodik)

När du sätter dig ned för att göra detta, följ denna checklista steg för steg:

1. **Definiera Zonerna:** Gruppera dina servrar och enheter efter roll och risknivå. Skapa inte för många zoner i början, håll det tydligt (3–6 zoner räcker ofta gott).
2. **Följ "Initiator-regeln":** Fråga alltid: *Vem tar första kontakten?* Om en apparat i zon A pratar med zon B för att skicka en logg, så är källzonen A och målzonen B. Svarstrafiken hanteras automatiskt.
3. **Minsta möjliga behörighet (Least Privilege):** Öppna **aldrig** hela zoner mot varandra (t.ex. `ANY` port från DMZ till Server). Specificera alltid exakt port och protokoll.
4. **Glöm inte "Osynliga" infrastrukturflöden:** En server fungerar sällan helt isolerad. Ställ dig frågorna:
   * *Hur får maskinen rätt klocktid?* (NTP - port 123)
   * *Hur vet den vad IP-adressen till databasen är?* (DNS - port 53)
   * *Hur installerar den säkerhetsuppdateringar?* (HTTP/HTTPS till t.ex. lokal mirror)
   * *Var hamnar händelseloggarna?* (Syslog/SIEM - port 514 / 5044)
   * *Hur ska IT-personalen logga in och underhålla maskinen utan att gå direkt från internet?* (Jump-box via SSH/RDP - port 22/3389)

