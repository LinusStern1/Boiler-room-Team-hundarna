# Boiler-room-labb

[Zonuppgraget](https://chasacademy.instructure.com/courses/627/pages/boiler-room-zonuppdraget?module_item_id=24159)



Skriven av Claude AI
### Segmentering av nätverket

IPv4-adressplan och privat nätverk med subnät
Ni ska bestämma hur adresserna fördelas och sedan bygga det i molnplattformen (t.ex. ett VPC/VNet med flera subnät). Planen ska visa vilket adressintervall (CIDR) varje subnät får, t.ex. ett för webbservrar, ett för databaser, ett för förvaltning och ett för logg. Tänk på att lämna utrymme för tillväxt.

Zonmodell med uppräknade tillåtna flöden
Ni delar in miljön i zoner efter funktion och känslighet (t.ex. DMZ, applikation, data, management, logg). Sedan skriver ni en tabell över exakt vilka flöden som är tillåtna: från zon, till zon, protokoll, port och syfte. Allt som inte står där är förbjudet (standard "deny").

Regelverk som implementerar zonmodellen "i båda riktningarna"
Ni översätter tabellen till faktiska brandväggsregler med två lager:

molnplattformens egna medel (säkerhetsgrupper, nätverks-ACL:er, routingtabeller)
Linux egna medel på servrarna (nftables, iptables eller ufw)

"Båda riktningarna" betyder att ni reglerar både inkommande (ingress) och utgående (egress) trafik, inte bara det som kommer in.

Omkörbart testskript
Ett skript (t.ex. bash eller Python) som automatiskt testar att regelverket fungerar: tillåtna flöden går igenom och förbjudna flöden blockeras. Det ska gå att köra om när som helst, till exempel efter en ändring, och ge ett tydligt resultat (godkänt/underkänt per test).

### Loggning och detektion

Insamling till gemensam loggserver
Ni väljer ut relevanta loggkällor (t.ex. auth-loggar, brandväggsloggar, systemloggar, applikationsloggar, molnplattformens flödesloggar) och skickar dem till en central loggserver (t.ex. via rsyslog, Filebeat eller liknande till en SIEM som Wazuh eller Elastic). Motivera varför just de källorna valdes.

Skydd av loggkedjan
Ni beskriver hur loggarna skyddas från källa till lagring, till exempel:

kryptering under överföring (TLS)
åtkomstkontroll på loggservern
skydd mot manipulation och radering (append-only, hashning, separat lagring)
tidssynkronisering (NTP)
bevarandetid och backup

Detektioner och playbooks
Ni skriver regler som larmar vid definierade händelser, t.ex. upprepade misslyckade inloggningar, en blockerad trafikflöde som bryter mot zonmodellen, eller ny användare som skapas. Varje detektion får en playbook: en kort instruktion för vad den som tar emot larmet ska göra (bedöm, avgränsa, åtgärda, eskalera).

### Härdning

Mandatory Access Control (MAC)
Ni aktiverar SELinux eller AppArmor på servrarna, i enforcing-läge.

Egen tjänst under egen profil
Ni väljer en tjänst (ni kan skriva en enkel egen) och skapar en säkerhetsprofil som ger den bara de rättigheter den behöver (least privilege). Testa att den fungerar och att den nekas det som inte ingår.

Dokumentation
Ni dokumenterar konfigurationen så att någon annan kan återskapa och förstå den: vad som aktiverats, profilens innehåll och varför.

### Incidentutredning och beslutsunderlag

Utredning i den egna miljön
Ni genomför (eller simulerar) en incident, t.ex. ett intrångsförsök eller en misstänkt sidorörelse mellan zoner, och utreder den med hjälp av era loggar och detektioner. Beskriv förloppet: vad hände, hur upptäcktes det, vad visade loggarna, vad gjordes.

Beslutsunderlag
Ett dokument riktat till en beslutsfattare som motiverar era val av segmentering och loggstrategi mot tillgångsklassificeringen. Det vill säga: ni klassificerar tillgångarna (t.ex. efter vikt för konfidentialitet, integritet och tillgänglighet) och visar att de mest skyddsvärda tillgångarna ligger i de mest skyddade zonerna och loggas mest noggrant. Incidenten används som bevis för att strategin fungerar eller för vad som bör förbättras.

1. Förslag på ordning
2. Tillgångsklassificering och adressplan
3. Zonmodell och flödestabell
4. Bygg nätet och regelverket, skriv testskriptet
5. Sätt upp loggserver och insamling, beskriv skyddet
6. Skriv detektioner och playbooks
7. Härda servrar och egen tjänst med MAC
8. Genomför och utred incidenten
9. Skriv beslutsunderlaget
