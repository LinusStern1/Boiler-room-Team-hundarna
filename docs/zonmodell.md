# Flödestabell

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
