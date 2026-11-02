# Denna MD fil inehåller kommandon för test och annat.

**För att själv testa kontakt mellan servrar**

Detta kommandot testar tcp kontakten mellan servrar och om reglerna nekar åtkomst.
- `timeout 3 bash -c 'exec 3<>/dev/tcp/IP/PORT'; echo $?`
    - 1 = Kontakt, Bra
    - 124 = Ingen kontakt, Dåligt

