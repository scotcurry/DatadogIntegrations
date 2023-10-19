# Overview

Basic configuration for updating the Datadog agent and any other simple VM setups that may be needed.  This is currently configured on the ansible.curryware.org server.

## Installation

Didn't take notes on the installation process so getting Ansible installed was very easy.  [Installation Instructions](https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html#installing-ansible-on-ubuntu)

## Configuration

You add the hosts you want to manages in /etc/ansible/hosts file.  There are sections that can be used to add different configurations to different types of machines.

### SSH - Important to use Ansible, so a big section on SSH

Ansible connects to the hosts in manages using SSH.  To get around the issue of needing to import ssh keys to make connections to the remote machines, the following line was added to the /etc/ansible/ansible.cfg file:
```
host_key_checking=False
```

**Note** To make sure the console can connect to the machines in the hosts file use:
```
ansible all -m ping -u scot --ask-pass
```

**Note** There is a tool called Ansible Vault which can be used to encrypt variables.  This was used to encrypt the Datadog API key.  Use the following command to do the encryption:
```
ansible-vault encrypt_string <Datadog API Key> --name 'datadog_api_key'
```
You need to then use this variable in the playbook.  When running the playbook, you will be prompted for the password used to encrypt the API key.

### Run the Datadog Agent Playbook
```
ansible-playbook -u scot --ask-pass --ask-become-pass --ask-vault-password ./datadog_agent.yml
```