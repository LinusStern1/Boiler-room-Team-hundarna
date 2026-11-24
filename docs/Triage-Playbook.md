# Playbook

## T1110 Brute Force
| Fält | Värde |
|---|---|
| Detektion (monitor) | T1110 Brute Force elev-18 |
| ATT&CK-teknik | T1110 |
| Wazuh-regler (rule.id) | 5710 & 5712 |
| Ägare | elev-18 |
| Senast korstestad | elev-18 · 11/24/2026 |
| Version | 1 |

### Syfte och när den används
**Syfte:** Kollar efter angripare på elev-18 och används när det sker en trigger på 5710 eller 5712.

### Fas 1. Förberedelse (ska vara sant *före* ett larm)
- [ ] Monitorn är *Enabled* i Alerting.
- [ ] Loggkällan syns i Discover (`location`, index `wazuh-alerts-*`).
- [ ] Normal träffmängd är känd: 30 per 24 timmar (från brusmätningen).
- [ ] Kända legitima källor: jump 172.20.1.2, ctf 172.20.1.10
- [ ] Du har åtkomst till: Wazuh, jump.

### Fas 2. Detektion och analys
1. Notera larmets tid (UTC), `rule.id`, `data.srcip` och `location`.
2. Sök: `<DQL>`, tidsfönster ___. **Förväntat:** ___.
3. Sök utan värdfilter på källan: `<DQL>`. Berörs fler servrar eller konton?
4. Jämför källan med flödestabellen och baslinjen. Är den en känd legitim källa?
5. Kontrollera om något följde efter (till exempel lyckad inloggning, nytt konto, nytt program): `<DQL>`.
6. Skriv observation och slutsats i triageloggen, i skilda fält.

### Eskalera när
- angriparen kommer ifrån en okänd adress.
- antal försök går över den kända mängden utanför test.

**Till:** Teamet, **Med underlag:** Sökningar, tider, adresser, **Inom:** 1 timma.

### Avfärda när
- Teamet testar funktionallitet, **Så kontrollerar någon annan det:** `data.srcip: 172.20.1.2` ger inloggs försök med `invalid user ogiltigX` där (X är nummer^).

### Fas 3. Inneslutning, utrotning och återställning
1. <Stoppa spridningen, till exempel blockera källan> `<kommando>`.
2. <Ta bort det angriparen lämnat kvar>.
3. <Återställ och verifiera att det fungerar> `<kommando>`.

> Blockera aldrig jump (172.20.1.2) eller ctf (172.20.1.10). Då låser du ute dig eller kontrollerna.

### Fas 4. Efterarbete
- Dokumentera i triageloggen (post T__).
- Justera tröskel eller undantag om larmet var brus.
- Uppdatera den här playbooken om ett steg var otydligt.

### Korstest
| Testare | Datum | Larm som användes | Där testaren stannade eller gissade | Ändring i playbooken |
|---|---|---|---|---|


---
> Kopiera allt över och lägg till mer playbook regler om det behövs.
## Versionshistorik
| Version | Datum | Ändring |
|---|---|---|
|v1|11/20/2026|Initial|