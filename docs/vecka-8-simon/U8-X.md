# U8.1
```bash
#!/usr/bin/env bash

# Läser in filen.
qfile="q.txt"
# kontrollera att filen finns.
if [[ ! -r "$qfile" ]]; then
	echo "Error: cannot read '$qfile'" >&2
	exit 1
fi
# Läser in varje rad i filen och dekodar den.
while read -r q; do
	l=${q%%.*}
	s=$(echo "${l:1}" | tr a-z A-Z)
	while [ $(( ${#s} % 8 )) -ne 0 ]; do s="$s="; done
	echo "${l:0:1} $(echo "$s" | base32 -d 2>/dev/null | tr -c 'a-z\n' '.')"
done < "$qfile" > flagga.txt
# sorterar utt den och skriver ut den i terminalen.
sort -n flagga.txt
```

# U8.2 – Attackens tidslinje (tshark)

**Övergripande metod:** vi går bakifrån från rådata-paket till att identifiera fem ATT&CKm tekniker utifrån deras *form*. En skanning ser ut som många misslyckade enstaka försök mot olika portar, brute force ser ut som många identiska misslyckade försök mot en och samma port, en riktig inloggning sticker ut i storlek/varaktighet, sidledsrörelse är en ny utgående anslutning från en redan komprometterad värd; DNS-tunnling syns som ovanligt många förfrågningar mot en okänd domän.

## T1046 – Skanning
```bash
tshark -r U8.1-scenario.pcap -Y 'tcp.flags.syn==1 && tcp.flags.ack==0' -T fields -e ip.src -e ip.dst | sort | uniq -c | sort -rn
```
```text
    236 172.20.1.102    172.20.1.118
     35 172.20.1.118    172.20.1.58
      2 172.20.1.101    172.20.1.118
      1 172.20.1.118    172.20.1.106
      1 172.20.1.117    172.20.1.118
      1 172.20.1.108    172.20.1.118
      1 172.20.1.103    172.20.1.118
```
Här har vi adresser sorterat med den mest använda högst upp och här ser vi att `172.20.1.102` förekommer ett fler antal gånger. 

```bash
tshark -r U8.1-scenario.pcap -Y 'tcp.flags.syn==1 && tcp.flags.ack==0 && ip.src==172.20.1.102 && ip.dst==172.20.1.118' -T fields -e tcp.dstport | sort -n | uniq -c
tshark -r U8.1-scenario.pcap -Y 'tcp.flags.syn==1 && tcp.flags.ack==0 && ip.src==172.20.1.102 && ip.dst==172.20.1.118' -T fields -e frame.number -e frame.time | head -1
```
```text
17 på port 22, resten utspritt över hundratals olika portar (1 träff vardera)
89      Nov 18, 2026 11:14:08.691131000 UTC
```
**Resultat:** `172.20.1.102` svep-skannar hundratals portar mot `172.20.1.118`. Första paketet = **paket 89, 11:14:08.691 UTC**.

## T1110 – Brute force
```bash
tshark -r U8.1-scenario.pcap -q -z conv,tcp,tcp.port==22
tshark -r U8.1-scenario.pcap -Y 'tcp.flags.syn==1 && tcp.flags.ack==0 && ip.src==172.20.1.102 && ip.dst==172.20.1.118 && tcp.srcport==53993' -T fields -e frame.number -e frame.time
```
```text
================================================================================
TCP Conversations
Filter:tcp.port==22
                                                           |       <-      | |       ->      | |     Total     |    Relative    |   Duration   |
                                                           | Frames  Bytes | | Frames  Bytes | | Frames  Bytes |      Start     |              |
172.20.1.102:53993         <-> 172.20.1.118:22                  4 396bytes        6 569bytes       10 965bytes    122.911914000         0.2595
172.20.1.102:54804         <-> 172.20.1.118:22                  4 413bytes        6 721bytes       10 1,134bytes   123.185792000         0.3415
172.20.1.102:41250         <-> 172.20.1.118:22                  4 520bytes        6 770bytes       10 1,290bytes   123.532868000         0.2126
172.20.1.102:56517         <-> 172.20.1.118:22                  4 536bytes        6 816bytes       10 1,352bytes   123.761633000         0.2458
172.20.1.102:41581         <-> 172.20.1.118:22                  4 468bytes        6 640bytes       10 1,108bytes   124.027123000         0.1991
172.20.1.102:42606         <-> 172.20.1.118:22                  4 478bytes        6 652bytes       10 1,130bytes   124.274200000         0.2291
172.20.1.102:44136         <-> 172.20.1.118:22                  4 397bytes        6 726bytes       10 1,123bytes   124.552451000         0.2281
172.20.1.102:56160         <-> 172.20.1.118:22                  4 478bytes        6 676bytes       10 1,154bytes   124.796807000         0.2868
172.20.1.102:47986         <-> 172.20.1.118:22                  4 458bytes        6 714bytes       10 1,172bytes   125.093990000         0.3190
172.20.1.102:56845         <-> 172.20.1.118:22                  4 473bytes        6 550bytes       10 1,023bytes   125.450913000         0.2012
172.20.1.102:55293         <-> 172.20.1.118:22                  4 499bytes        6 722bytes       10 1,221bytes   125.674883000         0.2635
172.20.1.102:56941         <-> 172.20.1.118:22                  4 522bytes        6 726bytes       10 1,248bytes   125.978578000         0.2129
172.20.1.102:47433         <-> 172.20.1.118:22                  4 451bytes        6 632bytes       10 1,083bytes   126.234526000         0.1363
172.20.1.102:52602         <-> 172.20.1.118:22                  4 445bytes        6 641bytes       10 1,086bytes   126.417418000         0.2079
172.20.1.102:45274         <-> 172.20.1.118:22                  4 478bytes        6 726bytes       10 1,204bytes   126.657936000         0.2263
172.20.1.102:41554         <-> 172.20.1.118:22                  4 2,837bytes       6 2,545bytes      10 5,382bytes   130.749030000        16.4169
172.20.1.118:57601         <-> 172.20.1.106:22                  4 2,237bytes       6 2,145bytes      10 4,382bytes   136.221329000         0.2292
172.20.1.102:44000         <-> 172.20.1.118:22                  1 54bytes         2 108bytes        3 162bytes    117.938845000         0.0464
================================================================================

15 sessioner, 10 paket vardera, ~1 000–1 350 byte, 0,13–0,34s varaktighet
537     Nov 18, 2026 11:14:23.974166000 UTC
```
**Resultat:** 15 identiska, snabba, avvisade SSH-inloggningar = brute force. Första försöket = **paket 537, 11:14:23.974 UTC**.

## T1078 – Giltig inloggning
```bash
tshark -r U8.1-scenario.pcap -Y 'tcp.flags.syn==1 && tcp.flags.ack==0 && ip.src==172.20.1.102 && ip.dst==172.20.1.118 && tcp.srcport==41554' -T fields -e frame.number -e frame.time
```
```text
689     Nov 18, 2026 11:14:31.811282000 UTC
```
**Resultat:** En session bryter mönstret — 5 382 byte, 16,4s varaktighet, istället för en nästan omedelbar avvisning. Ett fungerande lösenord ledde till en interaktiv session. **Paket 689, 11:14:31.811 UTC**.

## T1021 – Sidledsrörelse (lateral movement)
```bash
tshark -r U8.1-scenario.pcap -Y 'tcp.flags.syn==1 && tcp.flags.ack==0 && ip.src==172.20.1.118 && ip.dst==172.20.1.106' -T fields -e frame.number -e frame.time
```
```text
700     Nov 18, 2026 11:14:37.283581000 UTC
```
**Resultat:** Den komprometterade värden `.118` öppnar en ny utgående SSH-anslutning till en tredje värd, `.106` — ett pivot-steg. **Paket 700, 11:14:37.283 UTC**.

## T1048 – DNS-exfiltrering
```bash
tshark -r U8.1-scenario.pcap -Y 'dns.flags.response==0 && dns.qry.name contains "sync.telemetri-app.net"' -T fields -e frame.number -e frame.time | head -1
```
```text
710     Nov 18, 2026 11:14:40.092067000 UTC
```
**Resultat:** Första förfrågan mot en okänd domän med onormalt hög frekvens (14 mot 4 för normala infrastruktursökningar) — klassisk DNS-tunnling. **Paket 710, 11:14:40.092 UTC**.

## Hela kedjan
| Ordning | Teknik | Paket | Tid (UTC) |
|---|---|---|---|
| 1 | T1046 – Skanning | 89 | 11:14:08.691 |
| 2 | T1110 – Brute force | 537 | 11:14:23.974 |
| 3 | T1078 – Giltig inloggning | 689 | 11:14:31.811 |
| 4 | T1021 – Sidledsrörelse | 700 | 11:14:37.283 |
| 5 | T1048 – DNS-exfiltrering | 710 | 11:14:40.092 |

# U8.3
**Beskrivning:** U8.3 saknade `Wazuh-archive-*` och det fick läggas till i efterhand i Index, Loggen las därefter till under dagen och kunde inte tidssorteras normalt. Iställer kollade jag efter den senaste månaden till nu och sorterade utt den med angriparens port som jag hittade i U8.2.
 ```bash
 tshark -r U8.1-scenario.pcap -q -z conv,tcp,tcp.port==22
 ```

# U8.4
```bash
tshark -r U8.1-scenario.pcap -Y 'tcp.flags.syn==1 && tcp.flags.ack==0' -T fields -e ip.src -e ip.dst | sort | uniq -c | sort -rn

tshark -r U8.1-scenario.pcap -Y 'tcp.flags.syn==1 && tcp.flags.ack==0 && ip.src==172.20.1.118 && ip.dst==172.20.1.58' -T fields -e tcp.dstport | sort -n | uniq -c
tshark -r U8.1-scenario.pcap -Y 'tcp.flags.syn==1 && tcp.flags.ack==0 && ip.src==172.20.1.118 && ip.dst==172.20.1.58' -T fields -e frame.time_relative
```
**Beskrivning:** När vi letar efter ett flöde som kan vara en felconfigurerad programvara och inte en attack kan vi kolla på hur ofta och när programmet försöker göra kontakt. Detta sker genom att vi först letar upp addresserna och sedan plockar utt den adress som vi vill kontrollera. När vi har bekreftat att adressen inte är en sökning kan vi kolla på `-e frame.time_relative` för att see hur lång tid det är i mellan. En person skulle aldrig ge utt ett exact nummer och i detta fallet får vi exakt 5 secunder.

```text
    236 172.20.1.102    172.20.1.118
     35 172.20.1.118    172.20.1.58
      2 172.20.1.101    172.20.1.118
      1 172.20.1.118    172.20.1.106
      1 172.20.1.117    172.20.1.118
      1 172.20.1.108    172.20.1.118
      1 172.20.1.103    172.20.1.118

     35 1514

1.042179000
6.040137000
11.041466000
16.044787000
21.045541000
26.044492000
31.047490000
36.050629000
41.047770000
46.044415000
```
Port:1514
Adress:172.20.1.58