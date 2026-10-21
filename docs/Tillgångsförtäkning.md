# Tillgångsförteckning
| Namn | Roll | Adress | Tjänst | Belägg |
|:---|:---|:---|:---|:---|
| `jump.sec.chas-lab.dev` | Hoppserver | 172.20.1.2 | SSH TCP | `ss -tnp` SSH hopp |
| Elev-18 | Labbmiljö | 172.20.1.118 | SSH TCP | `ip -br a` |
### Kommentar
- Elev-18 labbmiljö ip adress är på `eth1` på port `32`
- Elev-18 har även adresser `eth0` `178.105.110.241` på port `32` och `lo` `127.0.0.1` på port `8`.
- `ss -tuln` visar flera okända adresser i labbmiljö, en hel adress koplad till port `323`. Adressen är koplad till en tjänst som har hand om Tid syncronisering. (`chronyd`)
