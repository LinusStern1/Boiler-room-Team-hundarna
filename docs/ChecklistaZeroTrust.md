# Checklista: Zero Trust-principer i segmentering

Beslut per begäran jämfört med tillit som bygger på var man sitter i nätet.

Underlag: NIST SP 800-207, *Zero Trust Architecture*, avsnitt 2.1 (de sju principerna).

| # | Princip (NIST SP 800-207) | Kontrollfråga | Svar | Bevis |
|---|---|---|---|---|
| 1 | Alla data- och tjänsteresurser räknas som resurser | Har vi en förteckning över alla resurser (servrar, tjänster, data) som ska skyddas, inte bara över nät och subnät? |  |  |
| 2 | All kommunikation skyddas oavsett nätplats | Är trafiken krypterad och autentiserad även inom samma segment? |  |  |
| 3 | Åtkomst ges per session | Ges åtkomst per anslutning, eller räcker en tidigare inloggning eller att man sitter i ett öppet segment? |  |  |
| 4 | Åtkomst styrs av dynamisk policy | Tas beslutet utifrån identitet, enhetens tillstånd och sammanhang, eller bara utifrån käll-IP? |  |  |
| 5 | Tillgångarnas integritet och säkerhetsstatus övervakas | Kontrolleras enhetens patchnivå och status innan den får åtkomst? |  |  |
| 6 | Autentisering och auktorisering sker dynamiskt och strikt före åtkomst | Måste varje begäran autentiseras och auktoriseras innan den släpps igenom, även mellan segment? |  |  |
| 7 | Så mycket information som möjligt samlas in för att förbättra säkerheten | Loggas och analyseras trafiken mellan segmenten, och används resultatet för att skärpa reglerna? |  |  |