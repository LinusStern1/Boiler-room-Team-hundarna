# Wazuh Detektioner

## Elev-18 T1110 Brute force
**Beskrivning:** I wazuh filtrerar vi bort bruset och sickar in oss på en liten antal problem. Eftersom Brute force är ett vandligt angrepsvektor har jag skrivit ett filter som Wazuh sedan har uppdaterat på egen hand.

**Min Ver**
```json
{
  "size": 0,
  "query": {
    "bool": {
      "filter": [
        { "query_string": { "query": "location:*elev-18* AND rule.id:(5710 OR 5712)" } },
        { "range": { "timestamp": { "gte": "{{period_end}}||-5m", "lte": "{{period_end}}", "format": "epoch_millis" } } }
      ]
    }
  }
}
```
- Orginallet är kortfattat och letar igenom min log med en period på 5 minuter.
- Vi kollar efter 5710 eller 5712 som är vandliga varningar för Brute Force.

**Wazus Ver**
```json
{
    "size": 0,
    "query": {
        "bool": {
            "filter": [
                {
                    "query_string": {
                        "query": "location:*elev-18 AND rule.id:(5710 OR 5712)",
                        "fields": [],
                        "type": "best_fields",
                        "default_operator": "or",
                        "max_determinized_states": 10000,
                        "enable_position_increments": true,
                        "fuzziness": "AUTO",
                        "fuzzy_prefix_length": 0,
                        "fuzzy_max_expansions": 50,
                        "phrase_slop": 0,
                        "escape": false,
                        "auto_generate_synonyms_phrase_query": true,
                        "fuzzy_transpositions": true,
                        "boost": 1
                    }
                },
                {
                    "range": {
                        "timestamp": {
                            "from": "{{period_end}}||-5m",
                            "to": "{{period_end}}",
                            "include_lower": true,
                            "include_upper": true,
                            "format": "epoch_millis",
                            "boost": 1
                        }
                    }
                }
            ],
            "adjust_pure_negative": true,
            "boost": 1
        }
    }
}
```
- Wazuh updaterade skriptet med mer information den kräver för att loggen ska fungera.
- Funktionaliteten är dess samma men bra att påpeka.

## Fråga: Hur många angripare?
Wazuh samlar ihop informationen till en `Trigger` som jag lagt på `>=5`. Eftersom 5 försök är en vandlig gräns man kanske inte kommer ihåg ett lösenord eller strullar med inloggningen. Mer en 5 kan bli suspekt och behöver mer fokus.
```json
ctx.results[0].hits.total.value >= 5
```
