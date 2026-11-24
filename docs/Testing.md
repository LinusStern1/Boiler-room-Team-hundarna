# Denna MD fil inehåller kommandon för test och annat.

**För att själv testa kontakt mellan servrar**

Detta kommandot testar tcp kontakten mellan servrar och om reglerna nekar åtkomst. Vi utegår ifrån att svaret blir 1 i normalfall då vi saknar programvara som svarar på våra servrar och skickar svar tillbaka för att få `0`.
- `timeout 3 bash -c 'exec 3<>/dev/tcp/IP/PORT'; echo $?`
    - 0 = anslutningen lyckades, Bra
    - 1 = Kontakt men avisades, Förväntat
    - 124 = Ingen kontakt, Dåligt

