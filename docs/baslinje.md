# Trafikbaslinjen

### Belägg
```bash
sudo timeout 1m tcpdump -i any -nn -w /tmp/baslinje.pcap
```
Kör tcpdump i 1 minute och använd interface ´any´ för att få all trafik i systemet.


### Flöde
 | källa             | destination     | port  | protokoll      | riktning             | frekvens  |
 |-------------------|-----------------|-------|----------------|----------------------|-----------|
 | 172.20.1.118      | 172.20.1.2      | 22    | SSH            | lab till jump server | 72 gånger |
 | 172.20.1.2        | 172.20.1.118    | 22    | SSH            | jump till server     | 74 gånger |
 | 172.20.1.2        | 172.20.1.118    | 22    | TCP [ACK]      | jump till server     | 4 gånger  |
 | 20.65.170.227     | 178.105.110.241 | 36225 | TCP [SYN]      | request              | 1 gång    |
 | 178.105.110.241   | 20.65.170.227   | 7474  | TCP [RST, ACK] | reset                | 1 gång    |
 | 198.235.24.101    | 178.105.110.241 | 52302 | TCP [SYN]      | request              | 1 gång    |
 | 178.105.110.241   | 198.235.24.101  | 8085  | TCP [RST, ACK] | reset                | 1 gång    |
 | 92:00:0a:0d:67:28 |
