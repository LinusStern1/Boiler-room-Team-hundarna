# Trafikbaslinjen

### Belägg
```bash
sudo timeout 1m tcpdump -i any -nn -w /tmp/baslinje.pcap
```
Kör tcpdump i 1 minute och använd interface `any` för att få all trafik i systemet.

### Flöde

| källa                                  | destination     | port   | protokoll       | riktning             | frekvens  |
|----------------------------------------|-----------------|--------|-----------------|----------------------|-----------|
| 172.20.1.118                           | 172.20.1.2      | 22     | SSH [PSH, ACK]  | lab till jump server | 76 gånger |
| 172.20.1.2                             | 172.20.1.118    | 22     | SSH [PSH, ACK]  | jump till server     | 74 gånger |
| 172.20.1.2                             | 172.20.1.118    | 22     | TCP [ACK]       | jump till server     | 4 gånger  |
| 20.65.170.227                          | 178.105.110.241 | 36225  | TCP [SYN]       | request              | 1 gång    |
| 178.105.110.241                        | 20.65.170.227   | 7474   | TCP [RST, ACK]  | reset                | 1 gång    |
| 198.235.24.101                         | 178.105.110.241 | 52302  | TCP [SYN]       | request              | 1 gång    |
| 178.105.110.241                        | 198.235.24.101  | 8085   | TCP [RST, ACK]  | reset                | 1 gång    |
| 178.105.110.241 MAC(92:00:0a:0d:67:28) | 172.31.1.1      | Saknas | ARP             | request              | 1 gånger  |
| 172.31.1.1 MAC(d2:74:7f:6e:37:e3)      | 178.105.110.241 | Saknas | ARP             | reply                | 1 gånger  |
| 216.219.89.86                          | 178.105.110.241 | 53913  | TCP [SYN]       | request              | 3 gånger  |
| 178.105.110.241                        | 216.219.89.86   | 36223  | TCP [RST, ACK]  | reset                | 1 gång    |
| 178.105.110.241                        | 216.219.89.86   | 59757  | TCP [RST, ACK]  | reset                | 1 gång    |
| 178.105.110.241                        | 216.219.89.86   | 40851  | TCP [RST, ACK]  | reset                | 1 gång    |
| 179.43.167.3                           | 178.105.110.241 | 37000  | TCP [SYN]       | request              | 1 gång    |
| 178.105.110.241                        | 179.43.167.3    | 8168   | TCP [RST, ACK]  | reset                | 1 gång    |
| 118.26.36.18                           | 178.105.110.241 | 42288  | TCP [SYN]       | request              | 1 gång    |
| 178.105.110.241                        | 118.26.36.18    | 30005  | TCP [RST, ACK]  | reset                | 1 gång    |
| 204.76.203.219                         | 178.105.110.241 | 50079  | TCP [SYN]       | request              | 1 gång    |
| 178.105.110.241                        | 204.76.203.219  | 8080   | TCP [RST, ACK]  | reset                | 1 gång    |
| 198.235.24.177                         | 178.105.110.241 | 54874  | TCP [SYN]       | request              | 1 gång    |
| 178.105.110.241                        | 198.235.24.177  | 1911   | TCP [RST, ACK]  | reset                | 1 gång    |
| 194.180.49.127                         | 178.105.110.241 | 59657  | TCP [SYN]       | request              | 2 gånger  |
| 178.105.110.241                        | 194.180.49.127  | 10836  | TCP [RST, ACK]  | reset                | 1 gång    |
| 178.105.110.241                        | 194.180.49.127  | 10969  | TCP [RST, ACK]  | reset                | 1 gång    |
| 193.24.123.120                         | 178.105.110.241 | 41184  | TCP [SYN]       | request              | 1 gång    |
| 178.105.110.241                        | 193.24.123.120  | 2234   | TCP [RST, ACK]  | reset                | 1 gång    |
| 91.231.89.1                            | 178.105.110.241 | 38021  | TCP [SYN]       | request              | 1 gång    |
| 178.105.110.241                        | 91.231.89.1     | 1349   | TCP [RST, ACK]  | reset                | 1 gång    |
| 193.163.125.174                        | 178.105.110.241 | 52720  | TCP [SYN]       | request              | 1 gång    |
| 178.105.110.241                        | 193.163.125.174 | 2605   | TCP [RST, ACK]  | reset                | 1 gång    |
| 167.94.145.31                          | 178.105.110.241 | 41783  | TCP [SYN]       | request              | 1 gång    |
| 178.105.110.241                        | 167.94.145.31   | 18444  | TCP [RST, ACK]  | reset                | 1 gång    |
| 80.82.65.153                           | 178.105.110.241 | 32010  | TCP [SYN]       | request              | 1 gång    |
| 178.105.110.241                        | 80.82.65.153    | 5432   | TCP [RST, ACK]  | reset                | 1 gång    |
