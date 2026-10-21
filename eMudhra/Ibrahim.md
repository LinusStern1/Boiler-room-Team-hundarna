### Rapport

Den 20 oktober 2026 larmades säkerhetsfolk världen över efter att åtta mellanliggande TLS-certifikat visat sig ha så svaga privata nycklar att vem som helst kunde skapa betrodda certifikat för vilken webbplats som helst. Certifikaten tillhör eMudhra Limited, en indisk certifikatutfärdare. Upptäckten blev känd när ett informellt meddelande publicerades på en särskild webbplats, signerat med den privata nyckeln från ett av certifikaten. Det var ett bevis på att den som skrev kontrollerade nyckeln, och att samma nyckel kunde användas för att signera falska certifikat som miljontals servrar skulle lita på.

### Hur svaga var nycklarna?

En normal privat nyckel av typen NIST P-384 har ungefär 384 bitar entropi, vilket ger ett astronomiskt antal möjliga kombinationer. De komprometterade nycklarna hade bara mellan 3 och 8 bitar och gick därför att gissa nästan omedelbart. Experter beskrev felet som något som egentligen inte borde vara möjligt. Orsaken är okänd.

### Nuläge

De flesta webbläsartillverkare, flera större appar och programmeringsspråk hade vid artikelns publicering redan blockerat alla åtta certifikaten. Det finns inga rapporter om att certifikattransparensloggarna visar att nycklarna missbrukats. Appar som inte förlitar sig på TLS för sekretess, som Signal, WhatsApp och WireGuard, påverkas inte.

### Vem är i riskzonen?

För att utnyttja certifikaten krävs en aktiv man-i-mitten-attack, där angriparen placerar sig mellan två parter, tar emot den krypterade trafiken, dekrypterar den, krypterar om den och skickar vidare. Det kräver normalt stora resurser, men personer som kontrollerar ett lokalt nätverk, som ett kafé, ett universitet eller en arbetsplats, har betydligt lättare att genomföra det. Mest utsatta just nu är VPN-användare, särskilt i länder där myndigheter kan tänkas avlyssna trafik illasinnat. Vanliga användare har få egna möjligheter att skydda sig utöver att vänta på uppdateringar och undvika känslig kommunikation via icke-webbläsarbaserad TLS tills de fått försäkran om att patchar finns.

### Lärdomen

Händelsen visar en grundläggande svaghet i TLS-systemet: det är bara så starkt som sin svagaste länk, och här var länken eMudhra. Certifikattransparensloggar mildrar skadan, men de kräver att någon aktivt övervakar enorma flöden och fungerar först efter att ett obehörigt certifikat har utfärdats.

### Vad du bör göra

Håll webbläsare, operativsystem och appar uppdaterade, undvik känsliga aktiviteter på publika nätverk.
