# infra

A collection of infrastructure-as-code tools and configurations designed to automate and manage infrastructure components using Ansible, Packer, and Terraform.

## Features

- **Ansible Playbooks**: Automate configuration management and application deployment.
- **Packer Templates**: Create machine images for various platforms.
- **Terraform Modules**: Provision and manage infrastructure resources.
- **Infrastructure Diagrams**: Visual representations of the infrastructure setup.

## Prerequisites

- [Ansible](https://www.ansible.com/)
- [Packer](https://www.packer.io/)
- [Terraform](https://www.terraform.io/)
- [Python 3.x](https://www.python.org/)
- [Poetry](https://python-poetry.org/)

## Installation

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/rippleFCL/infra.git
   cd infra
   ```

2. **Set Up Python Environment**:

   Ensure you have Poetry installed. If not, install it from [here](https://python-poetry.org/docs/#installation).

   ```bash
   poetry install
   ```

3. **Activate the Virtual Environment**:

   ```bash
   poetry shell
   ```

## Usage

### Ansible

Navigate to the `ansible` directory and run the desired playbooks:

```bash
cd ansible
ansible-playbook playbook.yml
```

### Packer

Navigate to the `packer` directory and build images:

```bash
cd packer
packer build template.json
```

### Terraform

Navigate to the `terraform` directory and apply configurations:

```bash
cd terraform
terraform init
terraform apply
```

## Directory Structure

- `ansible/`: Ansible playbooks and roles.
- `packer/`: Packer templates for image creation.
- `terraform/`: Terraform modules and configurations.
- `diagrams/`: Infrastructure diagrams and visualizations.
- `the-cows/`: Miscellaneous scripts and tools.
- `.vscode/`: Visual Studio Code settings.
- `pyproject.toml`: Python project configuration.
- `poetry.lock`: Poetry lock file for dependencies.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request for any enhancements or bug fixes.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

*Note: This setup is intended for educational and experimental purposes. Use at your own risk.* 
