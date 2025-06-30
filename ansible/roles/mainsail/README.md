# Mainsail Role

This Ansible role installs and configures Mainsail, a web interface for Klipper 3D printer firmware. It follows the official manual installation guide from [docs.mainsail.xyz](https://docs.mainsail.xyz/setup/getting-started/manual-setup).

## What This Role Does

1. **System Preparation**
   - Updates system packages
   - Installs required dependencies for Klipper, Moonraker, and Mainsail
   - Installs and configures NGINX as reverse proxy

2. **Klipper Installation**
   - Clones Klipper repository
   - Creates Python virtual environment
   - Installs Python dependencies
   - Creates systemd service and environment files

3. **Moonraker Installation**
   - Clones Moonraker repository
   - Creates Python virtual environment
   - Installs Python dependencies
   - Creates systemd service and configuration files
   - Sets up PolicyKit rules

4. **Mainsail Installation**
   - Downloads and extracts Mainsail web interface
   - Configures NGINX with proper upstreams and site configuration
   - Sets up directory structure and permissions

5. **Service Management**
   - Enables and starts all required services
   - Optionally installs avahi-daemon for hostname resolution

## Requirements

- Debian 11 (Bullseye) or Debian 12 (Bookworm)
- Target system should have internet access for downloading packages and repositories
- User with sudo privileges

## Role Variables

All variables are prefixed with `mainsail_` to avoid conflicts:

### Basic Configuration
- `mainsail_user`: User to run services (default: "pi")
- `mainsail_group`: Group for the user (default: same as user)
- `mainsail_home`: Home directory path (default: "/home/{{ mainsail_user }}")

### Network Configuration
- `mainsail_moonraker_port`: Moonraker API port (default: 7125)
- `mainsail_nginx_port`: NGINX port (default: 80)

### Security Configuration
- `mainsail_moonraker_trusted_clients`: List of trusted IP ranges for Moonraker API
- `mainsail_moonraker_cors_domains`: List of allowed CORS domains

### Optional Features
- `mainsail_install_avahi`: Install avahi-daemon for hostname resolution (default: true)

## Dependencies

None. This role installs all required packages.

## Example Playbook

```yaml
---
- hosts: printers
  become: true
  vars:
    mainsail_user: "pi"
    mainsail_moonraker_trusted_clients:
      - "10.0.0.0/8"
      - "192.168.1.0/24"
      - "127.0.0.1"
  roles:
    - bootstrap_mainsail
```

## Example with Custom User

```yaml
---
- hosts: printers
  become: true
  vars:
    mainsail_user: "printer"
    mainsail_moonraker_trusted_clients:
      - "192.168.1.0/24"
    mainsail_install_avahi: false
  roles:
    - bootstrap_mainsail
```

## Post-Installation

After running this role:

1. Configure your printer settings in `~/printer_data/config/printer.cfg`
2. Access the web interface at `http://<printer-ip>/`
3. If avahi is installed, you can also use `http://<hostname>.local/`

## Important Notes

- **Printer Configuration**: You must still configure your specific printer settings in the `printer.cfg` file
- **Security**: Review and adjust the `trusted_clients` list based on your network setup
- **Firewall**: Ensure ports 80 and 7125 are accessible from your network
- **User Permissions**: The role sets up proper permissions for the web server to access user files

## Troubleshooting

1. **Check service status**:
   ```bash
   sudo systemctl status klipper
   sudo systemctl status moonraker
   sudo systemctl status nginx
   ```

2. **Check logs**:
   ```bash
   sudo journalctl -u klipper -f
   sudo journalctl -u moonraker -f
   ```

3. **Verify API access**:
   ```bash
   curl http://localhost:7125/server/info
   ```

## File Structure

```
bootstrap_mainsail/
├── README.md                    # Comprehensive documentation
├── handlers/
│   └── main.yml                # Service restart handlers
├── meta/
│   └── main.yml                # Role metadata and dependencies
├── tasks/
│   ├── main.yml                # Main orchestration file
│   ├── install_packages.yml    # System package installation
│   ├── setup_klipper.yml       # Klipper installation and configuration
│   ├── setup_moonraker.yml     # Moonraker installation and configuration
│   ├── setup_nginx.yml         # NGINX reverse proxy configuration
│   └── setup_mainsail.yml      # Mainsail web interface setup
├── templates/
│   ├── common_vars.conf.j2     # NGINX common variables
│   ├── klipper.env.j2          # Klipper environment file
│   ├── klipper.service.j2      # Klipper systemd service
│   ├── mainsail.nginx.j2       # NGINX site configuration
│   ├── moonraker.conf.j2       # Moonraker configuration
│   ├── moonraker.env.j2        # Moonraker environment file
│   ├── moonraker.service.j2    # Moonraker systemd service
│   └── upstreams.conf.j2       # NGINX upstreams configuration
├── vars/
│   └── main.yml                # Default variables
└── playbooks/
    ├── install-mainsail.yml        # Example usage playbook
    └── test-mainsail-role.yml      # Role testing playbook
```

## Task Organization

The role is organized into logical task files for better maintainability:

- **`main.yml`**: Orchestrates the installation by including other task files
- **`install_packages.yml`**: Handles system package installation and updates
- **`setup_klipper.yml`**: Installs and configures Klipper 3D printer firmware
- **`setup_moonraker.yml`**: Installs and configures Moonraker API server
- **`setup_nginx.yml`**: Configures NGINX as reverse proxy
- **`setup_mainsail.yml`**: Downloads and sets up the Mainsail web interface

## Using Tags

You can run specific parts of the installation using tags:

```yaml
# Install only packages
- hosts: printers
  roles:
    - { role: bootstrap_mainsail, tags: packages }

# Setup only Klipper
- hosts: printers
  roles:
    - { role: bootstrap_mainsail, tags: klipper }

# Setup web components only (NGINX + Mainsail)
- hosts: printers
  roles:
    - { role: bootstrap_mainsail, tags: [nginx, web-interface] }
```

Available tags:
- `packages`: System packages and dependencies
- `klipper`: Klipper firmware setup
- `moonraker`: Moonraker API server setup
- `nginx`: NGINX reverse proxy setup
- `mainsail`: Mainsail web interface setup
- `web`: Both nginx and mainsail
- `dependencies`: Package installation
- `firmware`: Klipper setup
- `api`: Moonraker setup
- `web-interface`: Mainsail setup

## License

This role is provided under the same license terms as the original Mainsail documentation.
