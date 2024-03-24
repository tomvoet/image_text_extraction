## Prerequisites

Create a service account with the following roles:
- Service Networking Admin
- Compute Network Admin
- Cloud Memorystore Redis Admin

## Deployment Steps

1. Save your gcp service-account credentials as `service-account.json` in the `/deployment` folder.
2. Run the following commands inside the `/deployment/ansible` folder to deploy and set up the infrastructure:

```bash
ansible-galaxy install -r requirements.yml
ansible-playbook -i inventory.ini playbook.yml
```