# Triagelogg

**Team:** Hundarna · **Period:** 11/24/2026 · **Triagerade av:** elev-18
**Larmkälla:** Wazuh (`wazuh-alerts-*`) och övningsfilen U6.4

> Anteckna ärligt när varje triage faktiskt gjordes. En post med påhittade
> tider eller loggrader går inte att kontrollera.

## Metod
1. Börja i larmet: rule.id, nivå, tid (UTC), location, data.srcip.
2. Skriv observation (bara det du ser) och slutsats (din bedömning) i skilda fält.
3. Sök utan värdfilter på källa och konto: vad mer berördes?
4. Jämför med flödestabellen och normaltrafiken.
5. Avfärda bara med ett skäl som någon annan kan kontrollera.

## Översikt

| ID | Tid (UTC) | Larm (rule.id, nivå) | Källa | Berörd server | Slutsats | Playbook |
|---|---|---|---|---|---|---|
| T1 | Nov 24, 2026 @ 10:00:00.000 - Nov 24, 2026 @ 10:30:00.000 | 5710 | from 172.20.1.2 | /elev-18/ | 16 ogiltiga inlogg försök mot elev-18 via SSH under kort period, (mindre en 30 secunder). Triggrar Alert skapad för brute force. | Försöket kommer ifrån jump (172.20.1.2) och är ett wazuh relaterat test. |
| T2 | | | | | | |

---

## T1 – Wazuh testet

| Fält | Värde |
|---|---|
| Tid (UTC) | Nov 24, 2026 @ 10:00:00.000 |
| Larm | rule.id 5710 · nivå ___ · beskrivning: Brute force |
| Detektion / monitor | T1110 brute force mot elev-18 |
| Källa (`data.srcip`) | 172.20.1.2 |
| Berörd server (`location`) | /var/log/remote/elev-18/syslog.log |
| Orsak | ☑ Vi orsakade det (test), ☐ Legitim aktivitet, ☐ Brus, ☐ Verklig incident, ☐ Oklart |

### Observation (bara det loggen visar)
- Sökning (DQL): `...`
- Tidsfönster och antal träffar: 16 träffar
- Vad hände närmast före och efter larmet: Tom logg, igen data, normal operation.

### Tre frågor
**1. Vad hände?**
Nov 24, 2026 @ 10:16:00.000 skickade teamet 16 ogiltiga inlogg försök till elev-18 med måll att testa wazuhs fångst av loggen.

**2. Vad berördes?**
Bara elev-18 berörs i detta testet.

**3. Vad gjordes?**
Ingen åtgärd krävs i detta fallet eftersom det var ett förväntat antal försök under en förväntad tid.

### Slutsats
☐ Sant positivt ☐ Falskt positivt ☑ Förväntad aktivitet

Bedömning i en till två meningar:

### Beslut
- [ ] Eskalera till:
- [ ] med underlag:
- [ ] Åtgärda:
- [x] Avfärda

**Skäl för avfärdande (måste gå att kontrollera):**

**Så kontrollerar någon annan det** (sökning eller kommando och förväntat resultat):

### Förbättring av detektionen
Tröskel, undantag eller fält som skulle minska bruset:

### Koppling till playbook
Detektion: ___ · Playbook: [Triage-Playbook.md](Triage-Playbook.md) · Fas som åtgärden hör till: ___

---

## T2 – <kort rubrik>
(Kopiera hela blocket ovan.)