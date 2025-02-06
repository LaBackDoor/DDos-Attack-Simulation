# DDoS Attack Simulation Framework

This repository contains an automated framework for simulating Distributed Denial of Service (DDoS) attacks in a controlled environment. The framework uses Terraform for infrastructure provisioning and Ansible for orchestrating the simulation.

## Repository Structure

```
ddos-attack/
├── Orchestration/
│   └── Ansible/
│       └── Attack/
│           ├── tasks/
│           ├── group_vars/
│           ├── continuous-ddos-playbook.yml
│           ├── clear_website.yml
│           ├── reboot_cleanup_all.yml
│           └── inventory.ini
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── provider.tf
│   └── terraform.tfvars
└── scripts/
    ├── normal.sh
    ├── syn_flood.sh
    └── route.sh
```

## Components

### Infrastructure (Terraform)

The infrastructure is managed using Terraform with vSphere as the provider. Key components include:
- VM provisioning from templates
- Network configuration
- Resource pool management
- Customizable deployment parameters

### Orchestration (Ansible)

The Ansible playbooks handle the simulation orchestration:
- Role assignment for attacker and normal traffic nodes
- Traffic generation and attack execution
- Packet capture and monitoring
- Cleanup and system maintenance

### Scripts

- `normal.sh`: Generates legitimate traffic patterns
- `syn_flood.sh`: Executes SYN flood attacks
- `route.sh`: Manages traffic routing configurations

## Setup and Configuration

1. **Infrastructure Setup**
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

2. **Configure Ansible Vault**
```bash
cd Orchestration/Ansible/Attack
ansible-vault create group_vars/all/vault.yml
```

3. **Update Inventory**
   Modify `inventory.ini` with your infrastructure details.

## Running Simulations

1. **Start Continuous DDoS Simulation**
```bash
ansible-playbook continuous-ddos-playbook.yml --ask-vault-pass
```

2. **Clean Up After Simulation**
```bash
ansible-playbook reboot_cleanup_all.yml --ask-vault-pass
```

## Attack Patterns

The framework supports different attack intensities:
- Low: 5-35% of nodes as attackers
- Mid: 35-65% of nodes as attackers
- High: 65-85% of nodes as attackers

## Monitoring and Logging

- Packet captures are stored in `/var/log/pcap/`
- Simulation logs are in `/var/log/ddos_sim/`
- Individual attack logs are maintained on each node

## Security Considerations

- Credentials are stored in Ansible Vault
- Terraform sensitive variables are marked appropriately
- Infrastructure credentials are managed via separate provider configuration
- All script execution is contained within the defined network

## Requirements

- Terraform >= 1.0
- Ansible >= 2.9
- vSphere environment
- Ubuntu-based templates
- Python 3.x

## Maintenance

- Use `clear_website.yml` for web server maintenance
- `reboot_cleanup_all.yml` for complete system reset
- Regular monitoring of log directories to prevent disk space issues

## Best Practices

1. Always use Ansible Vault for sensitive data
2. Keep Terraform state files secure
3. Monitor resource usage during simulations
4. Regular cleanup of log files
5. Test in isolated network environments

## Important Notes

- This framework is for research and testing purposes only
- Should only be used in controlled, isolated environments
- All simulations should comply with relevant policies and regulations
- Monitor system resources during extended simulations

## Contributing

1. Fork the repository
2. Create a feature branch
3. Submit a pull request with detailed description
4. Ensure all tests pass
5. Update documentation as needed

## License

[Insert your license information here]

## Disclaimer

This tool is for research and educational purposes only. Users are responsible for ensuring all activities comply with applicable laws and regulations.