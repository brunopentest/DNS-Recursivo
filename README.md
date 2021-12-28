# DNS-Recursivo
DNS-RECURSIVO-PUNK

SCRIPT HOMOLOGADO EM DEBIAN-10 E DEBIAN-11.
Utilização do Unbound + DNSsec + Cache + Hyperlocal + CPU affinity com IRQbalance + NTPcliente + Tuning Kernel

OBS¹: Faça uma instalação limpa do Debian utilizando o netinstall, durante a instalação ao chegar o taskel instalar somente servidor ssh.

OBS²: Esse Debian preferencialmente tem que está com ip público.

Comando para serem aplicados assim que iniciar o Debian já com internet:

su -
apt-get install curl
curl -s https://github.com/brunopentest/DNS-Recursivo/recursivo.sh | sudo bash
