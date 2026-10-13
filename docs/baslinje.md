# Trafikbaslinjen

### Belägg
```bash
sudo timeout 1m tcpdump -i any -nn -w /tmp/baslinje.pcap
```
Kör tcpdump i 1 minute och använd interface `any` för att få all trafik i systemet.

### Flöde

| källa                                  | destination     | port   | protokoll      | lager           | riktning             | frekvens  | användning                                          |
|----------------------------------------|-----------------|--------|----------------|-----------------|----------------------|-----------|-----------------------------------------------------|
| 172.20.1.118                           | 172.20.1.2      | 22     | SSH            | Applikation     | lab till jump server | 76 gånger | SSH-session                                         |
| 172.20.1.2                             | 172.20.1.118    | 22     | SSH            | Applikation     | jump till server     | 74 gånger | SSH-session                                         |
| 172.20.1.2                             | 172.20.1.118    | 22     | TCP [ACK]      | Transport       | jump till server     | 4 gånger  | Kvittens utan data i SSH-sessionen                  |
| 20.65.170.227                          | 178.105.110.241 | 36225  | TCP [SYN]      | Transport       | request              | 1 gång    | Portskanning mot port 7474 (extern bakgrundstrafik) |
| 178.105.110.241                        | 20.65.170.227   | 7474   | TCP [RST, ACK] | Transport       | reset                | 1 gång    | Porten är stängd, anslutningen nekas                |
| 198.235.24.101                         | 178.105.110.241 | 52302  | TCP [SYN]      | Transport       | request              | 1 gång    | Portskanning mot port 8085                          |
| 178.105.110.241                        | 198.235.24.101  | 8085   | TCP [RST, ACK] | Transport       | reset                | 1 gång    | Porten är stängd, anslutningen nekas                |
| 178.105.110.241 MAC(92:00:0a:0d:67:28) | 172.31.1.1      | Saknas | ARP            | Nätverksåtkomst | request              | 2 gånger  | Frågar efter MAC-adressen till 172.31.1.1           |
| 172.31.1.1 MAC(d2:74:7f:6e:37:e3)      | 178.105.110.241 | Saknas | ARP            | Nätverksåtkomst | reply                | 2 gånger  | Svarar med sin MAC-adress                           |
| 216.219.89.86                          | 178.105.110.241 | 53913  | TCP [SYN]      | Transport       | request              | 3 gånger  | Portskanning mot portarna 36223, 59757 och 40851    |
| 178.105.110.241                        | 216.219.89.86   | 36223  | TCP [RST, ACK] | Transport       | reset                | 1 gång    | Porten är stängd, anslutningen nekas                |
| 178.105.110.241                        | 216.219.89.86   | 59757  | TCP [RST, ACK] | Transport       | reset                | 1 gång    | Porten är stängd, anslutningen nekas                |
| 178.105.110.241                        | 216.219.89.86   | 40851  | TCP [RST, ACK] | Transport       | reset                | 1 gång    | Porten är stängd, anslutningen nekas                |
| 179.43.167.3                           | 178.105.110.241 | 37000  | TCP [SYN]      | Transport       | request              | 1 gång    | Portskanning mot port 8168                          |
| 178.105.110.241                        | 179.43.167.3    | 8168   | TCP [RST, ACK] | Transport       | reset                | 1 gång    | Porten är stängd, anslutningen nekas                |
| 118.26.36.18                           | 178.105.110.241 | 42288  | TCP [SYN]      | Transport       | request              | 1 gång    | Portskanning mot port 30005                         |
| 178.105.110.241                        | 118.26.36.18    | 30005  | TCP [RST, ACK] | Transport       | reset                | 1 gång    | Porten är stängd, anslutningen nekas                |
| 204.76.203.219                         | 178.105.110.241 | 50079  | TCP [SYN]      | Transport       | request              | 1 gång    | Portskanning mot port 8080                          |
| 178.105.110.241                        | 204.76.203.219  | 8080   | TCP [RST, ACK] | Transport       | reset                | 1 gång    | Porten är stängd, anslutningen nekas                |
| 198.235.24.177                         | 178.105.110.241 | 54874  | TCP [SYN]      | Transport       | request              | 1 gång    | Portskanning mot port 1911                          |
| 178.105.110.241                        | 198.235.24.177  | 1911   | TCP [RST, ACK] | Transport       | reset                | 1 gång    | Porten är stängd, anslutningen nekas                |
| 194.180.49.127                         | 178.105.110.241 | 59657  | TCP [SYN]      | Transport       | request              | 2 gånger  | Portskanning mot portarna 10836 och 10969           |
| 178.105.110.241                        | 194.180.49.127  | 10836  | TCP [RST, ACK] | Transport       | reset                | 1 gång    | Porten är stängd, anslutningen nekas                |
| 178.105.110.241                        | 194.180.49.127  | 10969  | TCP [RST, ACK] | Transport       | reset                | 1 gång    | Porten är stängd, anslutningen nekas                |
| 193.24.123.120                         | 178.105.110.241 | 41184  | TCP [SYN]      | Transport       | request              | 1 gång    | Portskanning mot port 2234                          |
| 178.105.110.241                        | 193.24.123.120  | 2234   | TCP [RST, ACK] | Transport       | reset                | 1 gång    | Porten är stängd, anslutningen nekas                |
| 91.231.89.1                            | 178.105.110.241 | 38021  | TCP [SYN]      | Transport       | request              | 1 gång    | Portskanning mot port 1349                          |
| 178.105.110.241                        | 91.231.89.1     | 1349   | TCP [RST, ACK] | Transport       | reset                | 1 gång    | Porten är stängd, anslutningen nekas                |
| 193.163.125.174                        | 178.105.110.241 | 52720  | TCP [SYN]      | Transport       | request              | 1 gång    | Portskanning mot port 2605                          |
| 178.105.110.241                        | 193.163.125.174 | 2605   | TCP [RST, ACK] | Transport       | reset                | 1 gång    | Porten är stängd, anslutningen nekas                |
| 167.94.145.31                          | 178.105.110.241 | 41783  | TCP [SYN]      | Transport       | request              | 1 gång    | Portskanning mot port 18444                         |
| 178.105.110.241                        | 167.94.145.31   | 18444  | TCP [RST, ACK] | Transport       | reset                | 1 gång    | Porten är stängd, anslutningen nekas                |
| 80.82.65.153                           | 178.105.110.241 | 32010  | TCP [SYN]      | Transport       | request              | 1 gång    | Portskanning mot port 5432                          |
| 178.105.110.241                        | 80.82.65.153    | 5432   | TCP [RST, ACK] | Transport       | reset                | 1 gång    | Porten är stängd, anslutningen nekas                |
