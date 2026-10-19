# Flödestabell – exempel (workshop 2)

Exemplet bygger på den platta miljön från U3.1. Teamets egen tabell ska utgå från teamets zoner och baslinjen från vecka 1.

| Rad | Källzon | Målzon | Protokoll | Port | Riktning | Motivering (verksamhetsfunktion) | Filtreras var |
|---|---|---|---|---|---|---|---|
| 1 | Internet | Webbzon (10.40.1.10) | tcp | 443 | Inkommande | Kunderna når portalen | Molnplattform |
| 2 | Klientzon (10.40.2.0/24) | Webbzon (10.40.1.10) | tcp | 443 | Inkommande till webbservern | Personalen når portalen | Värd |
| 3 | Webbzon (10.40.1.10) | Appzon (10.40.1.20) | tcp | 8080 | Utgående från webb, inkommande till app | Portalen hämtar orderdata | Värd |
| 4 | Appzon (10.40.1.20) | Databaszon (10.40.1.30) | tcp | 5432 | Utgående från app, inkommande till databas | Appen läser och skriver kunddata | Värd |
| 5 | Webb-, app- och databaszon | Loggzon (10.40.1.40) | tcp | 6514 (TLS) | Utgående från källan, inkommande till loggservern | Central loggning | Värd |
| 6 | Webb-, app-, databas- och loggzon | DNS (10.40.1.2) | udp | 53 | Utgående från källan, inkommande till DNS | Namnuppslag | Värd |
| 7 | Adminzon (10.40.3.5), via jump-servern | Webb-, app-, databas- och loggzon | tcp | 22 | Inkommande till servern | Förvaltning, endast nyckelinloggning | Värd |
| 8 | Webbzon (10.40.1.10) | Internet (uppdateringsserver) | tcp | 443 | Utgående | Säkerhetsuppdateringar | Molnplattform |
| – | **Allt som inte står ovan är nekat, inkommande och utgående.** | | | | | | |

## Vad som gör tabellen bra

- **En rad per flöde.** Pilen "webb till app" är rad 3, men om appen också behöver svara på något annat blir det en egen rad.
- **Motiveringen är en verksamhetsfunktion.** "De ligger i samma nät" godtas inte.
- **Konkreta zoner i stället för "Alla".** Rad 5–7 räknar upp vilka som menas, så att någon annan kan implementera tabellen utan att fråga. Det var just "Alla till loggserver" och "Adminstation till alla servrar" som släppte igenom de omotiverade flödena i U3.1.
- **Riktningen anges för båda ändar.** En regel behövs på källans utgående sida och på målets inkommande sida, eftersom default deny gäller åt båda håll.
- **Kolumnen "Filtreras var" följer Hetzners gräns.** Trafik från och till internet kan molnbrandväggen filtrera (rad 1 och 8). Allt inom det privata nätet filtreras på värden.
- **Rad 8 kräver en tanke till.** Så snart en utgående regel skrivs i Hetzners molnbrandvägg blir all övrig utgående trafik implicit nekad. Raden måste därför finnas med, annars slutar uppdateringarna fungera.
