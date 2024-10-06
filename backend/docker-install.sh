#!/bin/bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to check command success
check_success() {
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: $1 failed.${NC}" >&2
        exit 1
    fi
}

# Function to check if a command is already completed
check_if_installed() {
    if command -v "$1" &> /dev/null; then
        echo -e "${YELLOW}$1 is already installed, skipping.${NC}"
        return 0
    fi
    return 1
}

echo -e "${YELLOW}Starting Docker installation...${NC}"

# Install yum-utils if not already installed
if ! check_if_installed "yum-utils"; then
    echo -e "${GREEN}Installing yum-utils...${NC}"
    sudo yum install -y yum-utils
    check_success "yum install yum-utils"
fi

# Add Docker repository if not already added
if ! yum repolist | grep -q "docker-ce"; then
    echo -e "${GREEN}Adding Docker repository...${NC}"
    sudo yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
    check_success "add Docker repository"
else
    echo -e "${YELLOW}Docker repository already added, skipping.${NC}"
fi

# Install Docker and related packages if not already installed
if ! check_if_installed "docker"; then
    echo -e "${GREEN}Installing Docker...${NC}"
    sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    check_success "install Docker packages"
else
    echo -e "${YELLOW}Docker already installed, skipping.${NC}"
fi

# Start Docker service if not already running
if ! systemctl is-active --quiet docker; then
    echo -e "${GREEN}Starting Docker service...${NC}"
    sudo systemctl start docker
    check_success "start Docker service"
else
    echo -e "${YELLOW}Docker service already running, skipping.${NC}"
fi

# Enable Docker service on boot if not already enabled
if ! systemctl is-enabled --quiet docker; then
    echo -e "${GREEN}Enabling Docker service to start on boot...${NC}"
    sudo systemctl enable docker
    check_success "enable Docker service"
else
    echo -e "${YELLOW}Docker service already enabled, skipping.${NC}"
fi

# Add user to the docker group if not already added
USER="ec2-user"
if groups "$USER" | grep &>/dev/null "\bdocker\b"; then
    echo -e "${YELLOW}User ${USER} is already in the docker group, skipping.${NC}"
else
    echo -e "${GREEN}Adding user ${USER} to the docker group...${NC}"
    sudo usermod -aG docker "$USER"
    check_success "add user to docker group"
fi

echo -e "${GREEN}Docker installation completed successfully!${NC}"
echo -e "${YELLOW}Please log out and back in for group changes to take effect.${NC}"
