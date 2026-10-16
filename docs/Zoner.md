# Zoner
| **Namn** | **Klassning: Låg, Medel, Hög** | **Syfte** |
| :--- | :--- | :--- |
| **Publik webbserver** | Medel | Exponerad direkt mot internet, vilket ökar risken för intrång, men lagrar inte i sig de mest känsliga personuppgifterna. |
| **Kunddatabas med personuppgifter** | **Hög** | Innehåller skyddsvärda personuppgifter (GDPR), en läcka eller skada får mycket stora konsekvenser. |
| **Loggserver** | Medel / Hög | Kritisk för spårbarhet, incidenthantering och säkerhetsövervakning i miljön. |
| **Jump-server för administration** | Hög | Används för att administrera hela miljön, ett intrång innebär att hela plattformen kan komprometteras. |
| **arbetsplatser** | Låg / Medel | Slutanvändarmiljö med begränsad direktkritikalitet för den centrala serverdriften. |