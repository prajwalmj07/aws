
**Ansible** is an open-source IT automation tool that simplifies the management of IT infrastructure. It allows users to automate tasks such as provisioning, configuration management, application deployment, and orchestration. Ansible is popular for its simplicity and agentless architecture.

### Key Features of Ansible:

1.  **Agentless Architecture**:

    -   Unlike other automation tools, Ansible does not require agents to be installed on managed nodes. It uses SSH (or WinRM for Windows) to connect to target systems.
2.  **Simple Configuration**:

    -   Ansible configurations are written in human-readable YAML files called **Playbooks**, making it easy for teams to understand and use.
3.  **Idempotent**:

    -   Ansible ensures that changes are applied only when necessary, preventing unintended modifications to systems.
4.  **Extensible**:

    -   Ansible has a vast ecosystem of modules that enable interaction with various systems, services, and APIs.
5.  **Declarative Syntax**:

    -   Users specify "what" needs to be done (desired state), and Ansible handles the "how."

### Components of Ansible:

1.  **Control Node**:

    -   The system where Ansible is installed and from which it manages other nodes.
2.  **Managed Nodes**:

    -   The systems (servers, workstations, devices) being managed by Ansible.
3.  **Modules**:

    -   Reusable scripts executed by Ansible to perform specific tasks, like installing packages or configuring services.
4.  **Inventory**:

    -   A file listing the managed nodes (hosts) and their groups, enabling targeted automation.
5.  **Playbooks**:

    -   YAML files containing sets of instructions to define automation workflows.
6.  **Roles**:

    -   Pre-defined, reusable playbooks and associated files for organizing automation tasks.

### Common Use Cases:

-   **Provisioning**: Automating the setup of virtual machines, containers, and cloud resources.
-   **Configuration Management**: Ensuring systems are consistently configured.
-   **Application Deployment**: Deploying and updating applications across environments.
-   **Continuous Integration/Continuous Deployment (CI/CD)**: Automating pipelines and workflows.
-   **Orchestration**: Coordinating multi-step workflows across multiple systems.

# Setting up and Using Ansible on AWS EC2 Instances

## Overview

This document outlines the steps to set up and use Ansible to manage an AWS EC2 instance. It includes the creation of a control node, configuring passwordless SSH authentication, performing basic ad-hoc commands, and running Ansible playbooks.

---

## Steps

### 1. Launch EC2 Instances

1. Create two EC2 instances:
   - **Control Node**: Used to install and manage Ansible.
   - **Target Node**: Managed by Ansible.
2. Connect to the control node using a terminal client like MobaXterm.

### 2. Install Ansible on the Control Node

1. Update the package manager and install Ansible:
   ```bash
   sudo apt update
   sudo apt install ansible -y
   ```
2. Verify the installation:
   ```bash
   ansible --version
   ```

### 3. Set Up Passwordless SSH Authentication

1. Generate SSH keys on the control node:

   ```bash
   ssh-keygen -t ed25519
   ```

   - Save the key pair in the default location (`/home/ubuntu/.ssh/id_ed25519`).

2. Copy the public key to the target node:

   ```bash
   ssh-copy-id -i ~/.ssh/id_ed25519.pub ubuntu@<TARGET_PRIVATE_IP>
   ```

   Replace `<TARGET_PRIVATE_IP>` with the private IP address of the target EC2 instance.

3. Verify the SSH connection:

   ```bash
   ssh ubuntu@<TARGET_PRIVATE_IP>
   ```

### 4. Create an Inventory File

1. On the control node, create an inventory file:
   ```bash
   touch ~/inventory
   vim ~/inventory
   ```
2. Add the target node's private IP to the inventory file:
   ```
   <TARGET_PRIVATE_IP>
   ```
3. Save and exit.

### 5. Test Ansible Connectivity

1. Use an Ansible ad-hoc command to check connectivity:
   ```bash
   ansible -i ~/inventory all -m ping
   ```
   - The output should indicate success.

### 6. Perform Basic Ad-hoc Commands

1. Example: Create a file on the target node:
   ```bash
   ansible -i ~/inventory all -m shell -a "touch /tmp/devops"
   ```

2. Example: Restart services on the target node:
   ```bash
   ansible -i ~/inventory all -m shell -a "systemctl restart networkd-dispatcher.service"
   ```

3. Example: Check disk usage on the target node:
   ```bash
   ansible -i ~/inventory all -m shell -a "df -h"
   ```

4. Example: Install a package on the target node:
   ```bash
   ansible -i ~/inventory all -m apt -a "name=git state=present"
   ```

5. Example: Retrieve the hostname of the target node:
   ```bash
   ansible -i ~/inventory all -m command -a "hostname"
   ```

### 7. Using Ansible Playbooks

#### Example: Install and Start Nginx

Create a playbook file to automate the installation and startup of Nginx:

```yaml
---
- name: install nginx
  hosts: all
  become: True

  tasks:
    - name: install nginx
      apt:
        name: nginx
        state: present

    - name: start nginx
      service: 
        name: nginx
        state: started
```

Run the playbook:

```bash
ansible-playbook -i ~/inventory <playbook_name>.yaml
```

Replace `<playbook_name>` with the actual name of your playbook file.

### 8. Troubleshooting

- Ensure Ansible is installed by verifying the version:
  ```bash
  ansible --version
  ```
- If SSH fails, verify that the public key is added to the `~/.ssh/authorized_keys` file on the target node.
- Use `sudo` if required to create or modify files on the control node or target node.

---

## Commands Summary

| Step                         | Command                                                                                  |
| ---------------------------- | ---------------------------------------------------------------------------------------- |
| Update and install Ansible   | `sudo apt update && sudo apt install ansible -y`                                         |
| Generate SSH keys            | `ssh-keygen `                                                                  |
| Copy SSH key to target       | `ssh-copy-id -i ~/.ssh/<public_key.pub ubuntu@<TARGET_PRIVATE_IP>`                        |
| Verify SSH connectivity      | `ssh ubuntu@<TARGET_PRIVATE_IP>`                                                         |
| Create inventory file        | `touch ~/inventory && vim ~/inventory`                                                   |
| Test Ansible connectivity    | `ansible -i ~/inventory all -m ping`                                                     |
| Create file via Ansible      | `ansible -i ~/inventory all -m shell -a "touch /tmp/devops"`                             |
| Restart services via Ansible | `ansible -i ~/inventory all -m shell -a "systemctl restart networkd-dispatcher.service"` |
| Check disk usage via Ansible | `ansible -i ~/inventory all -m shell -a "df -h"`                                         |
| Install package via Ansible  | `ansible -i ~/inventory all -m apt -a "name=git state=present"`                         |
| Retrieve hostname via Ansible| `ansible -i ~/inventory all -m command -a "hostname"`                                    |
| Run an Ansible playbook      | `ansible-playbook -i ~/inventory <playbook_name>.yaml`                                   |

---
