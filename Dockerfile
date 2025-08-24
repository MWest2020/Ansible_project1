FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y openssh-server sudo python3 python3-apt && \
    mkdir -p /var/run/sshd

# Niet-root gebruiker 'ansible' met sudo (zonder wachtwoord)
RUN useradd -m -s /bin/bash -G sudo ansible && \
    echo "ansible ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ansible

# SSH keys voor 'ansible'
RUN mkdir -p /home/ansible/.ssh && chmod 700 /home/ansible/.ssh
COPY id_ed25519.pub /home/ansible/.ssh/authorized_keys
RUN chown -R ansible:ansible /home/ansible/.ssh && chmod 600 /home/ansible/.ssh/authorized_keys

# Basis hardening
RUN sed -ri 's/^#?PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -ri 's/^#?PermitRootLogin .*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config && \
    echo 'UseDNS no' >> /etc/ssh/sshd_config

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D", "-e"]
