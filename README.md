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

