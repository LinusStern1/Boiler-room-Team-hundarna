| Namn | Roll | Adress (IP) | Tjänster | (Protokoll/portar)  Belägg
| :--- | :--- | :--- | :--- | :--- |
| **Webbserver-01** | Hostar projektets publika webbplats och testmiljö. | 10.10.10.10 | HTTP (80), HTTPS (443), SSH (22) | Verifierat via nätverksfångst och kommandot `ip a`. |
| **App-server-01** | Hanterar affärslogik och backend-kopplingar. | 10.10.20.10 | TCP (8080), SSH (22) | Dokumenterat i nätverksarkitekturen. |
| **Databas-01** | Lagrar användardata och systeminformation. | 10.10.30.10 | PostgreSQL (5432) | Fångat via konfigurationsfiler och testskript. |
| **Loggserver-01** | Samlar in och säkrar centraliserade loggar (SIEM). | 10.10.40.10 | Syslog (514/TCP/UDP), TLS (1514) | Verifierat via `rsyslog`-konfiguration. |
