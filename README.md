# README

## Devcontainer for web development

Featuring TypeScript, Neovim w/ LazyVim, Copilot to create React apps with TailwindCSS.

OpenSSH server for remote development.

## Installation
Pull image and just use it w/ docker run command or devcontainer configuration:
```js
{
  "name": "React Devcontainer",
  "image": "ghcr.io/<GITHUB_USER>/<REPO_NAME>:latest",
  "extensions": [
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode",
    "ms-vscode.vscode-typescript-next"
  ],
  "forwardPorts": [3000]
}
```

## Configure OpenSSH server
Don't use default setting in production environment.

This guide explains how to configure SSH in the Docker container and set up authentication using an SSH key pair.

---

### 1. Generate an SSH Key Pair

If you don't already have an SSH key pair, generate one:

1. Open a terminal.
2. Run the following command:
   ```bash
   ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
   ```
   - Press **Enter** to save the key in the default location (`~/.ssh/id_rsa`).
   - Optionally, set a passphrase for additional security.

3. The key pair will be created:
   - **Private key**: `~/.ssh/id_rsa` (keep this secret!)
   - **Public key**: `~/.ssh/id_rsa.pub`

---

### 2. Add the Public Key to the Container

1. Start the container:
   ```bash
   docker build -t ssh-devcontainer .
   docker run -d -p 2222:22 ssh-devcontainer
   ```

2. Copy your public key into the container:
   ```bash
   docker exec -it <CONTAINER_ID> bash
   ```
   Replace `<CONTAINER_ID>` with the ID or name of the running container (you can find it with `docker ps`).

3. Add the public key to the SSH configuration for the user `devuser`:
   ```bash
   mkdir -p /home/devuser/.ssh
   echo "your-public-key-content" >> /home/devuser/.ssh/authorized_keys
   chmod 600 /home/devuser/.ssh/authorized_keys
   chown -R devuser:devuser /home/devuser
   ```

   Alternatively, use the following command to directly copy the key:
   ```bash
   cat ~/.ssh/id_rsa.pub | docker exec -i <CONTAINER_ID> bash -c "cat >> /home/devuser/.ssh/authorized_keys"
   ```

---

### 3. Verify SSH Configuration

Ensure the SSH server is configured properly:

1. Open the SSH configuration file in the container:
   ```bash
   nano /etc/ssh/sshd_config
   ```

2. Verify or update the following settings:
   ```
   PubkeyAuthentication yes
   PasswordAuthentication no
   ```

3. Restart the SSH server:
   ```bash
   service ssh restart
   ```

---

### 4. Connect to the Container via SSH

Use the SSH key pair to connect to the container:

1. Run the following command:
   ```bash
   ssh -i ~/.ssh/id_rsa devuser@localhost -p 2222
   ```
   - `-i ~/.ssh/id_rsa`: Specifies the private key path.
   - `-p 2222`: Specifies the SSH port.

2. You should be logged in without being prompted for a password.

---

### 5. Troubleshooting

#### Common Issues

- **"Permission denied (publickey)":**
  - Verify that the `authorized_keys` file exists and has the correct permissions:
    ```bash
    chmod 600 /home/devuser/.ssh/authorized_keys
    chmod 700 /home/devuser/.ssh
    chown -R devuser:devuser /home/devuser/.ssh
    ```

- **SSH server not running:**
  - Check the SSH server status:
    ```bash
    service ssh status
    ```
  - Start the SSH server if needed:
    ```bash
    service ssh start
    ```

- **Check SSH logs:**
  - Review SSH server logs for error messages:
    ```bash
    tail -f /var/log/auth.log
    ```

---

### 6. Security Recommendations

- **Disable Password Authentication:**
  Update `/etc/ssh/sshd_config` to disable password-based logins:
  ```
  PasswordAuthentication no
  ```

- **Disable Root Login:**
  Update `/etc/ssh/sshd_config` to restrict root access:
  ```
  PermitRootLogin no
  ```

- **Limit SSH Access:**
  Use firewall rules to restrict SSH access to trusted IPs only.

---


