#!/bin/bash

clear

# exit the script if any statement returns a non-true return value
set -e

INFO='\033[0;34m'    # Blue
ALERT='\033[0;31m'   # Redr
NC='\033[0m'         # No Color

CERT=""

function checks() {
    if [ -x "$(command -v docker)" ]; then
        echo -e "${INFO}Docker is intalled...${NC}"
    else
        echo -e "${ALERT}Please install docker!${NC}"
        exit 1
    fi

    if [ -x "$(command -v docker-compose)" ]; then
        echo -e "${INFO}Docker compose is intalled...${NC}"
    else
        echo -e "${ALERT}Please install docker-compose!${NC}"
        exit 1
    fi

    if [ -f "docker-compose.yml" ]; then
        echo -e "${INFO}docker-compose.yml file exists...${NC}"
    else
        echo -e "${ALERT}docker-compose.yml file does not exist!${NC}"
        exit 1
    fi

    if [ -x "$(command -v git)" ]; then
        echo -e "${INFO}Git is intalled...${NC}"
    else
        echo -e "${ALERT}Please install git!${NC}"
        exit 1
    fi
}

function select_cert() {
    echo -e "${INFO}Select certificate and press enter:${NC}"

    echo "  1) Local: 192.168.0.2"
    echo "  2) Public: 1.2.3.4"
    echo "  3) Domain: example.com"
    echo "  4) Exit"

    read n

    case $n in
    1)
        CERT="local"
        ;;
    2)
        CERT="public"
        ;;
    3)
        CERT="domain"
        ;;
    *) 
        echo -e "${ALERT}Invalid option $REPLY ${NC}" 
        exit 1
        ;;
    esac
}

checks
select_cert

if [ -n "${CERT}" ]; then
    #sudo sysctl -w vm.max_map_count=262144
    if [[ $(docker ps -aq) ]]; then
        docker stop $(docker ps -aq)
    fi
    CERT=$CERT docker-compose up --build
fi
