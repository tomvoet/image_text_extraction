## Prerequisites

Create a service account with the following roles:
- Service Networking Admin
- Cloud Memorystore Redis Admin
- Vertex AI Service Agent
- Compute Admin

## Deployment Steps

1. Save your gcp service-account credentials as `service-account.json` in the root directory of the project.
2. Run the following commands inside the `/ansible` folder to deploy and set up the infrastructure:

```bash
# Install the required roles
$ ansible-galaxy install -r requirements.yml

# Run the playbook
$ ansible-playbook playbook.yml
```