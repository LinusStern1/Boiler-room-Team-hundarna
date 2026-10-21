Den 20 oktober 2026 offentliggjordes att de privata nycklarna till åtta mellanliggande certifikatutfärdare (intermediate CA) hos eMudhra är komprometterade. Certifikaten kedjar till rotcertifikat som Mozilla, Microsoft, Apple och Chrome litar på. Den ursprungliga rapportören, “Wayne”, bevisade problemet genom att signera ett meddelande med varje nyckel och rapportera det till root-programmen den 17 oktober.

Enligt hemsidan genererades nycklarna felaktigt av certifikatutfäraren, vilket gör att vem som helst kan räkna ut dem utifrån certifikaten. Svagheten har funnits sedan certifikaten skapades i april 2025.

Den som har en sådan nyckel kan utge sig för att vara vilken webbplats eller tjänst som helst. Webbläsare som kräver Certificate Transparency (Firefox, Chrome, Edge, Safari) bedöms inte ha kunnat attackeras, eftersom det saknas loggposter för certifikaten. Många klienter utanför webbläsarvärlden kräver inte detta, och om någon utnyttjat svagheten mot dem är okänt.

Certifikaten blockerades i Firefox och Chrome den 17 oktober, i Apple-enheter den 19:e och hos Microsoft den 20:e. eMudhra har återkallat certifikaten. Klienter som inte hanterar återkallelseinformation kräver dock programuppdateringar, och flera Linux-distributioner, programmeringsspråk och paketverktyg har släppt rättade versioner.

Händelsen visar hur ett enda fel i nyckelgenereringen hos en CA kan undergräva hela förtroendekedjan, och att uppdaterade trust stores är avgörande. Användare bör uppdatera webbläsare och operativsystem.

Källa: [[eMudhra Intermediate CA Compromise, we-have-a-problem.com, 20 okt 2026](https://emudhra.we-have-a-problem.com/)](https://emudhra.we-have-a-problem.com/)