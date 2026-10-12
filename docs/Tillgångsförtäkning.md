| Namn | Roll | Adress (IP) | Tjänster | (Protokoll/portar)  Belägg
| :--- | :--- | :--- | :--- | :--- |
| **Webbserver-01** | Hostar projektets publika webbplats och testmiljö. | 10.10.10.10 | HTTP (80), HTTPS (443), SSH (22) | Verifierat via nätverksfångst och kommandot `ip a`. |
| **App-server-01** | Hanterar affärslogik och backend-kopplingar. | 