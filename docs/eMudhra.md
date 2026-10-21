# TLS nycklar komprimerat 2026-10-20
## Sammanfattnign
Privata nycklar till åtta mellan-CA-certifikat (intermediate CA) utfärdade av eMudhra är komprometterade. Certifikaten kedjar till rötter som är betrodda av Mozilla, Microsoft, Apple och Chrome. Den som har nyckeln kan utge sig för att vara vilken webbplats eller tjänst som helst.
 
Webbläsarna är i stort sett skyddade genom återkallelse. Många klienter utanför webbläsarvärlden saknar dock sådant skydd och måste uppdateras.

## Tidslinje
 
| Datum (UTC) | Händelse |
|---|---|
| Apr 2025 | De påverkade mellan-CA-certifikaten skapas med felaktigt genererade nycklar. |
| 17 okt 2026 | Rapportören skickar bevis till root program-teamen. Firefox och Chrome blockerar certifikaten. |
| 19 okt 2026 | Ansvarsfull delgivning till downstream-trust stores. Apple blockerar certifikaten. Cloudflare får kännedom ca 17:00 och börjar utvärdera. |
| 20 okt 2026, 02:00 | Cloudflare publicerar uppdateringar för Cloudflare One-klient/WARP (iOS väntar på app review). |
| 20 okt 2026, 09:15 | Uppdatering av Cloudflare Tunnel (cloudflared) publiceras. |
| 20 okt 2026 | Microsoft blockerar certifikaten. eMudhra återkallar certifikaten. |
| 20 okt 2026, 19:20 | Cloudflares CDN- och serverside Zero Trust-åtgärder fullt utrullade. |
| 20 okt 2026 | Offentlig kommunikation från Cloudflare och Dennis Jackson. |

## Verifiering
 
Den ursprungliga rapportören, "Wayne", signerade ett meddelande med var och en av de åtta mellan-CA-nycklarna och rapporterade det till root program-teamen den 17 oktober. Meddelandet, certifikaten, publika nycklar och signaturer finns i [`proof.zip`](https://emudhra.we-have-a-problem.com/proof.zip) och kan verifieras med OpenSSL:
 
```bash
openssl x509 -in EM-DV-TLS-CA-G3B.crt.pem -noout -pubkey | diff - EM-DV-TLS-CA-G3B.pub.pem
openssl dgst -sha384 -verify EM-DV-TLS-CA-G3B.pub.pem -signature EM-DV-TLS-CA-G3B.sig message.txt
```

## Risk

Risken finns att det skapar en Man-In-The-Middle attack vektor, Avlysnande av trafik och manipulation av den.
**Potentionella exponerade**
- Klienter som inte hanterar återkallelse eller CT: curl, språkruntimes, SDK:er, bakgrundstjänster och containerbilder med inbyggda trust stores.
- Origin-servrar med strikt TLS-läge (Full strict) och mTLS-konfigurationer.
- macOS inbyggda `/usr/bin/curl`, som använder `/etc/ssl/cert.pem` utan återkallelsekontroll. Filen har inte uppdaterats.

## Åtgärder

**Arch Linux**
```bash
trust extract --format=pem-bundle \
  --filter='pkcs11:object=emSign%20ECC%20Root%20CA%20-%20G3;type=cert' \
  /etc/ca-certificates/trust-source/blocklist/emSign_ECC_Root_CA_-_G3.pem &&
update-ca-trust
```

**Debian & Ubantu**
```bash
sed -i \
  -e 's|^mozilla/emSign_ECC_Root_CA_-_G3.crt|!&|' \
  -e 's|^mozilla/Comodo_AAA_Services_root.crt|!&|' \
  /etc/ca-certificates.conf && update-ca-certificates
```

Den fullständiga listan finns på https://emudhra.we-have-a-problem.com/#developers.