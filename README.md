# Ansible_project1

# Ansible Docker Lab

Dit lab zet drie kale **Ubuntu 22.04 containers** op, elk met een eigen SSH-server en een gebruiker `ansible`.  
Ze draaien **headless** (zonder GUI) en bootsen zo drie losse servers na waarop je Ansible kunt oefenen.

## 🔑 SSH en sleutels
- Alle containers accepteren dezelfde public key (`id_ed25519.pub`) voor de user `ansible`.
- Jouw private key (`~/.ssh/ansible_lab`) hoort bij die public key.
- Om niet steeds de passphrase in te typen, kun je `ssh-agent` gebruiken:

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/ansible_lab
``` 

Daarmee wordt de key tijdelijk in je sessie bewaard en automatisch gebruikt bij alle SSH-verbindingen (ook via Ansible).

🐳 Containers

Met `docker compose up -d --build` worden drie nodes gestart:

node1 → bereikbaar via poort 2221

node2 → bereikbaar via poort 2222

node3 → bereikbaar via poort 2223

Alle drie draaien exact dezelfde Docker image (Ubuntu + SSH + Ansible user).

📂 Inventaris

In inventory.ini staan de drie nodes gedefinieerd, zodat Ansible weet op welke hosts het moet inloggen en via welke poort.

🚀 Testen

Check verbinding:

`ansible -i inventory.ini all -m ping`


Voer het playbook uit:

`ansible-playbook -i inventory.ini site.yml`

🧩 Rollen

De taken zijn netjes in rollen opgesplitst.
roles/common/tasks/main.yml bevat basisacties zoals het installeren van curl en het neerzetten van een testbestand.
