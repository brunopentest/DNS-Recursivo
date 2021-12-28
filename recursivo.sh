#!/bin/bash

##-APRESENTAÇÕES
echo -e "\033[01;31m"
echo -e ""
echo -e " ############################################ "
echo -e " ## DNS-RECURSIVO"
echo -e " ## Filename: recursivo.sh"
echo -e " ## Revision: 2.0"
echo -e " ## Date: 28/12/2021"
echo -e " ## By: Bruno Cavalcante"
echo -e " ## Mail: bru.cavalcantedasilva@gmail.com"
echo -e " ## Instagram: @bru_cavalcante12"
echo -e " ## LinkedIn: https://bit.ly/2XI6k2s"
echo -e " ## OBS: Homologado em Debian10 e Debian11"
echo -e " #############################################"
echo -e ""
echo -e "\033[0m"


##-ALIMENTAÇÃO DAS VARIÁVEIS
echo -e "Qual o seu bloco \033[01;31mIPV4 PÚBLICO: \033[0m" ; read IPV4
echo -e ""
echo -e ""
echo -e "Qual o seu bloco \033[01;31mIPV6 PÚBLICO: \033[0m" ; read IPV6
echo -e ""
echo -e ""
echo -e "Qual o seu \033[01;31mIP: \033[0m" ; read IP
echo -e ""
echo -e ""

##-ATUALIZAÇÃO DAS SOURCE-LIST
echo -e "deb http://deb.debian.org/debian/ bullseye main contrib non-free
deb-src http://deb.debian.org/debian/ bullseye main contrib non-free

deb http://security.debian.org/debian-security bullseye-security main contrib non-free
deb-src http://security.debian.org/debian-security bullseye-security main contrib non-free

deb http://deb.debian.org/debian/ bullseye-updates main contrib non-free
deb-src http://deb.debian.org/debian/ bullseye-updates main contrib non-free

deb http://deb.debian.org/debian bullseye-backports main contrib non-free
deb-src http://deb.debian.org/debian bullseye-backports main contrib non-free" > /etc/apt/sources.list


##-ATUALIZAÇÃO DOS REPOSITORIOS E PACOTES
apt-get update -y && apt-get upgrade -y && apt-get dist-upgrade -y


##-INSTAÇÃO DE PACOTES BASICOS PARA O LINUX
apt-get install -y htop iotop iftop wget traceroute bash-completion irqbalance openntpd sudo


##-INSTALAÇÃO DOS PACOTES REFERENTE A APLICAÇÃO
apt-get install -y unbound dnsutils apt-transport-https libtool ca-certificates build-essential libssl-dev


##-HABILITANDO O START NO BOOT O SERVIÇO IRQBALANCE
systemctl enable irqbalance


##-STARTANDO O SERVIÇO IRQBALANCE
systemctl start irqbalance


##-HABILITANDO O START NO BOOT O SERVIÇO UNBOUND
systemctl enable unbound


##-STARTANDO O SERVIÇO UNBOUND
systemctl start unbound


##-HABILITANDO O START NO BOOT O SERVIÇO OPENNTPD
systemctl enable openntpd


##-STARTANDO O SERVIÇO OPENNTPD
systemctl start openntpd


##-CONFIGURANDO O NTP DO NIC.BR
echo "servers pool.ntp.br" > /etc/openntpd/ntpd.conf


##-RESTARTANDO O SERVIÇO OPENNTPD
/etc/init.d/openntpd restart


##-CONFIGURANDO O BASH-COMPLETION
echo -e "# enable bash completion in interactive shells
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi" >> /etc/bash.bashrc


##-AJUSTANDO O KERNEL A SEU FAVOR
echo -e "net.ipv4.tcp_sack = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_low_latency = 1
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864
net.ipv4.tcp_mem = 6672016 6682016 7185248
net.ipv4.tcp_congestion_control=htcp
net.ipv4.tcp_mtu_probing=1
net.ipv4.tcp_moderate_rcvbuf =1
net.ipv4.tcp_no_metrics_save = 1" > /etc/sysctl.d/001-net-tcp-ipv4.conf


##-AJUSTANDO O KERNEL A SEU FAVOR
echo -e "vm.swappiness=1" > /etc/sysctl.d/002-swappiness.conf


##-AJUSTANDO O KERNEL A SEU FAVOR
echo -e "vm.vfs_cache_pressure=50" > /etc/sysctl.d/003-vfs-cache-pressure.conf


##-AJUSTANDO O KERNEL A SEU FAVOR
echo -e "fs.file-max = 3263776
fs.aio-max-nr=3263776
fs.mount-max=1048576
fs.mqueue.msg_max=128
fs.mqueue.msgsize_max=131072
fs.mqueue.queues_max=4096
fs.pipe-max-size=8388608" > /etc/sysctl.d/004-fs-options.conf


##-AJUSTANDO O KERNEL A SEU FAVOR
echo -e "net.ipv4.ip_local_port_range=1024 65535" > /etc/sysctl.d/005-port-range-ipv4.conf


##-AJUSTANDO O KERNEL A SEU FAVOR
echo -e "net.ipv4.ip_default_ttl=128" > /etc/sysctl.d/006-default-ttl-ipv4.conf


##-AJUSTANDO O KERNEL A SEU FAVOR
echo -e "net.ipv4.neigh.default.gc_interval = 30
net.ipv4.neigh.default.gc_stale_time = 60
net.ipv4.neigh.default.gc_thresh1 = 4096
net.ipv4.neigh.default.gc_thresh2 = 8192
net.ipv4.neigh.default.gc_thresh3 = 12288
net.ipv4.ipfrag_high_thresh=4194304
net.ipv4.ipfrag_low_thresh=3145728
net.ipv4.ipfrag_max_dist=64
net.ipv4.ipfrag_secret_interval=0
net.ipv4.ipfrag_time=30" > /etc/sysctl.d/007-neigh-ipv4.conf


##-AJUSTANDO O KERNEL A SEU FAVOR
echo -e "net.ipv4.conf.default.forwarding=1" > /etc/sysctl.d/008-default-foward-ipv4.conf


##-AJUSTANDO O KERNEL A SEU FAVOR
echo -e "net.ipv4.conf.all.forwarding=1" > /etc/sysctl.d/009-all-foward-ipv4.conf


##-AJUSTANDO O KERNEL A SEU FAVOR
echo -e "net.ipv4.ip_forward=1" > /etc/sysctl.d/010-ipv4-forward.conf


##-ENTRANDO DIRETORIO DO UNBOUND
cd /etc/unbound


##-BAIXANDO OS ENDEREÇAMENTOS DOS ROOT.SERVERS
wget ftp://ftp.internic.net/domain/named.cache


##-ALTERANDO O DONO E AS PERMISSÕES DOS ARQUIVOS
chown unbound:root * ; sudo chmod 440 unbound_*


##-GERANDO AS CHAVES NECESSÁRIAS PARA O TLS
unbound-control-setup


##-CONFIGURAÇÃO DO UNBOUND
echo -e "server:
	port: 53
	interface: 127.0.0.1
	interface: $IP
	verbosity: 1
	statistics-interval: 0
	statistics-cumulative: no
	extended-statistics: yes
	num-threads: 4
	interface-automatic: no
	outgoing-range: 8192
	outgoing-num-tcp: 20
	incoming-num-tcp: 20
	so-rcvbuf: 4m
	so-sndbuf: 4m
	edns-buffer-size: 1232
	msg-cache-size: 100m
	msg-cache-slabs: 4
	num-queries-per-thread: 8192
	rrset-cache-size: 200m
	rrset-cache-slabs: 4
	infra-cache-slabs: 4
	do-ip4: yes
	do-ip6: yes
	do-udp: yes
	do-tcp: yes
	access-control: 0.0.0.0/0 deny
	access-control: 127.0.0.0/8 allow
	access-control: 192.168.0.0/16 allow
	access-control: 172.16.0.0/12 allow
	access-control: 10.0.0.0/8 allow
	access-control: 100.64.0.0/10 allow
	access-control: fd00::/8 allow
	access-control: $IPV4 allow
	access-control: $IPV6 allow
	chroot: \"\"
	username: \"unbound\"
	directory: \"/etc/unbound\"
	logfile: \"/etc/unbound/unbound.log\"
	use-syslog: no
	log-time-ascii: yes
	log-queries: no
	pidfile: \"/var/run/unbound.pid\"
	root-hints: \"/etc/unbound/named.cache\"
	hide-identity: yes
	hide-version: yes
	unwanted-reply-threshold: 10000000
	prefetch: yes
	prefetch-key: yes
	rrset-roundrobin: yes
	minimal-responses: yes
	val-clean-additional: yes
	val-permissive-mode: no
	val-log-level: 1
	key-cache-slabs: 4
	do-daemonize: yes
	auto-trust-anchor-file: \"/var/lib/unbound/root.key\"
	local-data: \"localhost A 127.0.0.1\"
	local-data-ptr: \"127.0.0.1 localhost\"
	local-zone: \"wpad.domain.name.\" static
	local-zone: \"domain.name.\" static
	local-zone: \"contentexplorer.net.\" static
	local-zone: \"home.contentexplorer.net.\" static
	local-zone: \"wallpaper.pcappstore.baidu.com.\" static

python:

remote-control:
	control-enable: yes
	server-key-file: \"/etc/unbound/unbound_server.key\"
	server-cert-file: \"/etc/unbound/unbound_server.pem\"
	control-key-file: \"/etc/unbound/unbound_control.key\"
	control-cert-file: \"/etc/unbound/unbound_control.pem\"

auth-zone:
	name: \".\"
	master: \"b.root-servers.net\"
	master: \"c.root-servers.net\"
	master: \"f.root-servers.net\"
	master: \"g.root-servers.net\"
	master: \"k.root-servers.net\"
	master: \"lax.xfr.dns.icann.org\"
	master: \"iad.xfr.dns.icann.org\"
	fallback-enabled: yes
	for-downstream: no
	for-upstream: yes
	zonefile: \"/var/lib/unbound/root.zone\" " > /etc/unbound/unbound.conf


##-ALTERANDO O DONO DA CHAVE DNS-SEC
chown unbound:root /var/lib/unbound/root.key


##-RESTARTANDO O SERVIÇO DO UNBOUND
/etc/init.d/unbound restart


##-CONFIGURANDO DNS LOCAL DA MÁQUINA
echo "namerserver 127.0.0.1" > /etc/resolv.conf


##-REBOOT NA MAQUINA PARA APLICAÇÃO DOS AJUSTES DE KERNEL.
reboot
