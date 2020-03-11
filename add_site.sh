#!/bin/bash

###########################################################
#  Configure servers on NGINX Reverse Proxy with Certbot  #
#  Robert Watkins                              		  #
#  Updated: 10/13/2019                         		  #
#  Changelog:                                  		  #
#  - 1.0: Initial Creation                     		  #
###########################################################

# Check if user is root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

cls () {
clear
cat << "EOF"
 _______    ________.___ _______  ____  ___  ____________________ 
 \      \  /  _____/|   |\      \ \   \/  /  \______   \______   \
 /   |   \/   \  ___|   |/   |   \ \     /    |       _/|     ___/
/    |    \    \_\  \   /    |    \/     \    |    |   \|    |    
\____|__  /\______  /___\____|__  /___/\  \   |____|_  /|____|    
 v1.0   \/        \/            \/      \_/          \/           
EOF
echo ""
}
cls

# Check if user is root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# vars
domain="watkins.network"
reachable=false


# Get info
echo "Enter the subdomain:"
read sub
cls
echo "Enter the destination [http(s)://<IP>:<PORT>]:"
read location
cls
# check if location is reachable
ping -c1 $(echo $location | awk -F '//' '{print $2}' | awk -F ':' '{print $1}') >/dev/null
if [ $? -eq 0 ]
then
    reachable=true
    echo "The host is reachable"
else
    reachable=false
    read -rp "The host is not reachable. Do you want to continue [ Enter | ctl-c ]"
fi

fullDomain=$(echo ${sub}.${domain})
sleep 1
cls

# Show file
cat << EOF 
server {
    server_name $fullDomain;
    location / {
        proxy_pass $location;
    }
}

EOF
read -rp "Do you want to continue? [ Enter | ctl-c ]"
cls

# Create Files and Symlink
echo "- Creating /etc/nginx/sites-available/${fullDomain}.conf"
cat << EOF > $(echo /etc/nginx/sites-available/${fullDomain}.conf)
server {
    server_name $fullDomain;
    location / {
        proxy_pass $location;
    }
}

EOF

echo "- Linking file to /etc/nginx/sites-enabled/${fullDomain}.conf"
ln -sf /etc/nginx/sites-available/${fullDomain}.conf /etc/nginx/sites-enabled/${fullDomain}.conf
echo "- Restarting nginx"
systemctl restart nginx
echo "Done!"
read -rp "Do your want to update certbot? [ Enter | ctl-c ]"
cls
certbot --nginx

exit 0
