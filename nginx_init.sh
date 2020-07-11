 
#!/bin/bash

###########################################################
#  Configure CentOS 7 with NGINX                          #
#  Robert Watkins                              		  #
#  Updated: 10/13/2019                         		  #
#  Changelog:                                  		  #
#  - 1.0: Initial Creation                     		  #
###########################################################

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
echo "Working..."
apt-get  install -y nginx certbot python3-certbot-nginx > /dev/null 2>&1

cat << EOF > /etc/nginx/conf.d/include_sites.conf
include /etc/nginx/sites-enabled/*.conf;

EOF

systemctl start nginx > /dev/null 2>&1
systemctl enable nginx > /dev/null 2>&1

#firewall-cmd --permanent --add-service=http
#firewall-cmd --permanent --add-service=https
#firewall-cmd --reload
cls 
echo "Done!"

exit 0
