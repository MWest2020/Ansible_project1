# Ansible_project1

Ansible Docker Lab met CI/CD

Dit project is een leer- en oefenomgeving waarin we Ansible inzetten om meerdere Linux-omgevingen te beheren.
We gebruiken Docker om snel een cluster van headless Ubuntu-containers op te zetten, en GitHub Actions (met een self-hosted runner) voor CI/CD.

📂 Structuur
ANSIBLE/
├── .github/workflows/        # CI/CD pipelines
│   ├── ci.yml
│   └── cd.yml
├── .yamllint                 # lint-config
├── .gitignore
├── Dockerfile                # basis image (Ubuntu + SSH + ansible user)
├── docker-compose.yaml       # meerdere nodes tegelijk
├── ansible.cfg               # Ansible defaults
├── inventory.ini             # hosts/ports
├── site.yml                  # hoofd-playbook (roept rollen aan)
└── roles/
    ├── common/               # voorbeeldrol
    ├── hardening/            # sshd/fail2ban/logrotate etc.
    └── webserver/            # nginx + config uit template

🐳 Docker lab

Met docker-compose start je meerdere targets (Ubuntu 22.04 met sshd en user ansible).
Voorbeeld:

node1 → SSH via localhost:2221, HTTP via localhost:8081

node2 → SSH via localhost:2222, HTTP via localhost:8082

node3 → SSH via localhost:2223, HTTP via localhost:8083

Start lab:

` docker compose up -d --build` 

🔑 SSH keys

De containers accepteren de public key in ` id_ed25519.pub`.

Jouw private key ~/.ssh/ansible_lab hoort daarbij en staat niet in Git.

Om niet steeds je passphrase te typen:

```
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/ansible_lab
```

🚀 Ansible basics

Ping alle nodes:

`ansible -i inventory.ini all -m ping`


Run playbook:

`ansible-playbook -i inventory.ini site.yml`


site.yml laadt meerdere rollen, zoals hardening en webserver.

🧩 Rollen
hardening

Schakelt password login uit

Activeert `fail2ban` voor `sshd`

Zet timezone op Europe/Amsterdam

(optioneel) activeert `ufw` en opent alleen `ssh/http` 

webserver

Installeert nginx

Plaatst host-specifieke config via template

Maakt per host aparte access/error logs

Levert eenvoudige indexpagina (curl http://localhost:8081)

🔄 CI/CD
CI (.github/workflows/ci.yml)

- Draait op GitHub cloud runners

- Checks:

* yamllint (met custom config die Actions-YAML accepteert)

* ansible-lint

* Syntax-check van playbooks

* Dry-run (--check --diff)

CD (.github/workflows/cd.yml)

- Draait op een self-hosted runner met label ansible

- Workflow:

* Checkt repo uit

* Zorgt dat Ansible aanwezig is

* Laadt ssh-key in agent

* Voert playbook uit op de containers

🏃 Self-hosted runner

De CD pipeline draait op je eigen laptop/server (anders kan GitHub je lokale containers niet bereiken).

Installeren

1. Ga in je repo naar: Settings → Actions → Runners → New self-hosted runner.

2. Volg de instructies (download + ./config.sh).
Geef het label `ansible`.

3 Start de runner:

```
tmux new -s gha-runner
./run.sh
```

(loskoppelen: Ctrl+b d, terugkeren: `tmux attach -t gha-runner`)

Key & permissies

Zorg dat `~/.ssh/ansible_lab` aanwezig en chmod 600 is.

Runner-user moet die kunnen lezen.

📋 Yamllint-config

Bestand: .yamllint
```yaml
---
extends: default

ignore: |
  .git/.*

rules:
  document-start:
    present: false
  truthy:
    allowed-values: ["true", "false"]
    check-keys: false
  empty-lines:
    max: 1
    max-start: 0
    max-end: 1
  line-length: disable
  comments:
    min-spaces-from-content: 1
``` 
