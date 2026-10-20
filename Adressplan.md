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
| 10.40.0.0/24 | Klienter | 10.40.0.1 – 10.40.0.254 | DHCP | Nej | **Uträkning:** 120 idag + 25 % = 150. 150 + nät + broadcast = 152 → 256. 32 − 24 = 8 värdbitar. 2⁸ = 256 adresser (254 användbara). Nätverk: 10.40.0.0, Broadcast: 10.40.0.255. |
| 10.40.1.0/26 | Gäst och besök | 10.40.1.1 – 10.40.1.62 | DHCP (gästnät) | Nej | **Uträkning:** 40 + 25 % = 50. 52 → 64. 32 − 26 = 6 värdbitar. 2⁶ = 64 adresser (62 användbara). Nätverk: 10.40.1.0, Broadcast: 10.40.1.63. |
| 10.40.1.64/27 | Servrar | 10.40.1.65 – 10.40.1.94 | Applikationsservrar | Nej | **Uträkning:** 14 + 25 % = 18. 20 → 32. 32 − 27 = 5 värdbitar. 2⁵ = 32 adresser (30 användbara). Nätverk: 10.40.1.64, Broadcast: 10.40.1.95. |
| 10.40.1.96/28 | Drift och administration | 10.40.1.97 – 10.40.1.110 | Administration (jump-server) | Nej | **Uträkning:** 6 + 25 % = 8. 10 → 16. 32 − 28 = 4 värdbitar. 2⁴ = 16 adresser (14 användbara). Nätverk: 10.40.1.96, Broadcast: 10.40.1.111. |
| 10.40.1.112/29 | Databaser | 10.40.1.113 – 10.40.1.118 | Databastjänst | Nej | **Uträkning:** 4 + 25 % = 5. 7 → 8. 32 − 29 = 3 värdbitar. 2³ = 8 adresser (6 användbara). Nätverk: 10.40.1.112, Broadcast: 10.40.1.119. |
| 10.40.1.120/29 | DMZ | 10.40.1.121 – 10.40.1.126 | Publik webbtjänst | Nej | **Uträkning:** 4 + 25 % = 5. 7 → 8. 32 − 29 = 3 värdbitar. 2³ = 8 adresser (6 användbara). Nätverk: 10.40.1.120, Broadcast: 10.40.1.127. |
| 10.40.1.128/29 | Logg och övervakning | 10.40.1.129 – 10.40.1.134 | Loggning/övervakning | Nej | **Uträkning:** 3 + 25 % = 4. 6 → 8. 32 − 29 = 3 värdbitar. 2³ = 8 adresser (6 användbara). Nätverk: 10.40.1.128, Broadcast: 10.40.1.135. |
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