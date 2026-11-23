# AI användning

## Regler för AI användning
Det finns vissa gränser vi tar med AI för att vi själva ska få arbeta, AI är ett fantastiskt verktyg men ska inte skapa eller modifiera filer till en gräns vi inte förstår.
- AI får inte skapa från grunden
- Output som du inte förstår eller inte kan förklara får inte användas.
- AI kan användas för att skapa templates, MD listor osv.
- AI har fel, dubbel kolla alltid output.

## Exempel på output: Simon vs Claude
Här kommer lite exempel på in puts och outputs från loggen, Där claude kom till hjälp för att lösa problem.

| Input | Output | Verifiering |
|---|---|---|
| `ScreenshotPåFärdigNftables.png` & `NästanfärdigMDfil.md` Jag försöker utöka den praktiska tabellen med md filen. Kan du hjälpa mig skriva klart den? | Lägger till D5-D8 i tabellen... | Tabellen verifierades genom att dubbelkolla IP addresser, Portar och testaeds i labmiljön med test skriptet. |
| `CannotConnectTo6514.png` Är det någon rad i min nftables? | Din D8 regel finns... Kontrollera `sudo nft list chain inet zon ut / grep 6514` | Det är oklart enligt Claude loggs om claude löste problemet eftersom den inte föreslog några ändringar och bara kontroller men chatten därefter går till en annan uppgift. Dtta skede på en Workshop så det möjligör att gruppen löste problemet utan Claude.|