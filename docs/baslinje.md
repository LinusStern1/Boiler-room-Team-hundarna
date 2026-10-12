| Källa                            | Mål         | Protokoll     | Port | riktning      |
|----------------------------------|-------------|---------------|------|---------------|
| Central server (stjärn topology) | Gren server | TCP och HTTPS | 443  | dubble duplex |

Flödet händer varje gång någoting händer i server och skickas loggar till huvud server med HTTPS protokoll.

Tranport portokoll och Internet portokoll

Kommando: tcpdump -i any -n -w baselinje.pcap

![topology](/images/topology.jpg)
