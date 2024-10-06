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

echo -e "${YELLOW}Starting Docker installation...${NC}"

# Install yum-utils
echo -e "${GREEN}Installing yum-utils...${NC}"
sudo yum install -y yum-utils
check_success "yum install yum-utils"

# Add Docker repository
echo -e "${GREEN}Adding Docker repository...${NC}"
sudo yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
check_success "add Docker repository"

# Install Docker and related packages
echo -e "${GREEN}Installing Docker...${NC}"
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
check_success "install Docker packages"

# Start Docker service
echo -e "${GREEN}Starting Docker service...${NC}"
sudo systemctl start docker
check_success "start Docker service"

# Enable Docker service on boot
echo -e "${GREEN}Enabling Docker service to start on boot...${NC}"
sudo systemctl enable docker
check_success "enable Docker service"

# Add user to the docker group
USER="ec2user"
echo -e "${GREEN}Adding user ${USER} to the docker group...${NC}"
sudo usermod -aG docker "$USER"
check_success "add user to docker group"

echo -e "${GREEN}Docker installation completed successfully!${NC}"
echo -e "${YELLOW}Please log out and back in for group changes to take effect.${NC}"
