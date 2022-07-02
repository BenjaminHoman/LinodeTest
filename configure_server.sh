#!/bin/bash

# Declare Constants
declare -r RED='\033[0;31m'
declare -r NC='\033[0m'
declare -r YELLOW='\033[1;33m'
declare -r GREEN='\033[1;32m'

echo "Configuring Firewall Rules <---------------------"
echo "	This allows traffic to flow on a given port via TCP."
echo ""
echo ""

# Get Input param
PORT=$1

re='^[0-9]+$'
if ! [[ $PORT =~ $re ]] ;
then
	printf "${RED}ERROR: ${NC}Script usage is the following --> $0 {PORT}"
	echo ""
	exit 1
fi

# Display FirewallD Daemon
echo ""
systemctl status firewalld
echo ""

printf "${YELLOW}INFO: ${NC}Checking firewalld status."
OUTPUT=$(firewall-cmd --state)

if [ "$OUTPUT" = "running" ];
then
	printf "${YELLOW}INFO: ${NC}Firewalld is running.\n"
else
	printf "${RED}}ERROR: ${NC}Firewalld is not running. Script will exit.\n"
	exit 1
fi

# GET Default Zone
DEFAULT_ZONE=$(firewall-cmd --get-default-zone)
printf "${YELLOW}INFO: ${NC}Default Zone: $DEFAULT_ZONE.\n"

# Set Port
OUTPUT=$(firewall-cmd --zone=$DEFAULT_ZONE --add-port=${PORT}/tcp --permanent)
if [ "$OUTPUT" = "success" ] ;
then
	printf "${YELLOW}INFO: ${NC}Successfully added port ( $PORT ) to firewall.\n"
else 
	printf "${RED}ERROR: ${NC}Error adding port ( $PORT ) to firewall.\n"
fi

# Add HTTP service
# OUTPUT=$(firewall-cmd --zone=$DEFAULT_ZONE --add-service=http --permanent)
# echo "add http service output: $OUTPUT"

# Reload firewall after changes
OUTPUT=$(firewall-cmd --reload)
if [ "$OUTPUT" == "success" ] ;
then
	printf "${GREEN}STATUS: ${NC}Port has been added to firewall.\n"
else
	printf "${RED}ERROR: ${NC}Firewall could not be reloaded.\n"
	exit 1
fi

