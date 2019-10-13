# NGINX Reverse Proxy Configurator
Script to configure servers on nginx reverse proxy with certbot on CentOS 7

Requirements:
- installed:
  - nginx 
  - certbot
  - python2-certbot-nginx
- a domain name pointing to public IP (I'm using Dynamic DNS from dynu.com)
- ports 80 and 443 forwarded to Reverse Proxy Server
- ports 80 and 443 allowed on firewall 
