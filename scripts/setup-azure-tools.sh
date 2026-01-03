#!/bin/bash

echo "====================================="
echo "Azure Tools Setup Script"
echo "====================================="

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Detected: macOS"

    # Install Homebrew if not present
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Install Azure CLI
    echo "Installing Azure CLI..."
    brew update && brew install azure-cli

    # Install kubectl
    echo "Installing kubectl..."
    brew install kubectl

    # Install Terraform
    echo "Installing Terraform..."
    brew tap hashicorp/tap
    brew install hashicorp/tap/terraform

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Detected: Linux"

    # Install Azure CLI
    echo "Installing Azure CLI..."
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

    # Install kubectl
    echo "Installing kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl

    # Install Terraform
    echo "Installing Terraform..."
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install terraform

else
    echo "Unsupported OS: $OSTYPE"
    echo "Please install manually:"
    echo "  - Azure CLI: https://docs.microsoft.com/cli/azure/install-azure-cli"
    echo "  - kubectl: https://kubernetes.io/docs/tasks/tools/"
    echo "  - Terraform: https://learn.hashicorp.com/tutorials/terraform/install-cli"
    exit 1
fi

echo ""
echo "====================================="
echo "Verifying installations..."
echo "====================================="

# Verify installations
echo -n "Azure CLI: "
az version --output tsv 2>/dev/null | head -1 || echo "❌ Not installed"

echo -n "kubectl: "
kubectl version --client --short 2>/dev/null || echo "❌ Not installed"

echo -n "Terraform: "
terraform version | head -1 || echo "❌ Not installed"

echo ""
echo "====================================="
echo "Setup complete!"
echo "====================================="
echo ""
echo "Next steps:"
echo "1. Login to Azure: az login"
echo "2. Deploy AKS cluster using Terraform"
echo ""
