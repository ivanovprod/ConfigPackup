# may/22/2015 09:28:37 by RouterOS 6.27
# software id = VB9P-23PH
#huyhuyhuy Yoyoyoyoxfgvdfgdfgdf
/interface bridge
add admin-mac=D4:CA:6D:DA:90:21 auto-mac=no name=bridge-local
/interface ethernet
set [ find default-name=ether1 ] auto-negotiation=no comment=Switch mtu=1492 \
    name=ether1-gateway rx-flow-control=on tx-flow-control=on
set [ find default-name=ether2 ] mtu=1492 name=ether2-master-local \
    rx-flow-control=auto tx-flow-control=auto
set [ find default-name=ether3 ] name=ether3-slave-local rx-flow-control=auto \
    tx-flow-control=auto
set [ find default-name=ether4 ] comment=IPTV l2mtu=1492 mtu=1492 name=\
    ether4-slave-local rx-flow-control=auto tx-flow-control=auto
set [ find default-name=ether5 ] auto-negotiation=no comment=BRIDGE l2mtu=\
    1492 mtu=1492 name=ether5-slave-local poe-out=off
/interface pppoe-client
add add-default-route=yes comment=\
    "\D2\D2\CA 751106987 CsYFxzze gagar15kv119d1" disabled=no interface=\
    ether5-slave-local max-mru=1492 max-mtu=1492 mrru=1492 name=pppoe-out1 \
    password=CsYFxzze service-name=12 use-peer-dns=yes user=gagar15kv119d1
/interface pptp-server
add name=pptp-in1 user=ppp1
/interface wireless
set [ find default-name=wlan1 ] adaptive-noise-immunity=ap-and-client-mode \
    area=100m band=2ghz-b/g/n comment=WIFI disabled=no frequency=2422 \
    frequency-mode=superchannel hw-protection-mode=rts-cts l2mtu=1600 mode=\
    ap-bridge multicast-helper=full ssid=MikroTik-DA9025 tx-power=19 \
    tx-power-mode=all-rates-fixed wireless-protocol=802.11 wmm-support=\
    enabled
/interface wireless manual-tx-power-table
set wlan1 comment=WIFI
/ip neighbor discovery
set ether1-gateway comment=Switch discover=no
set ether2-master-local discover=no
set ether3-slave-local discover=no
set ether4-slave-local comment=IPTV discover=no
set ether5-slave-local comment=BRIDGE
set wlan1 comment=WIFI discover=no
set bridge-local discover=no
set pppoe-out1 comment="\D2\D2\CA 751106987 CsYFxzze gagar15kv119d1" \
    discover=no
/interface wireless nstreme
set wlan1 comment=WIFI enable-polling=no
/interface wireless
add mac-address=D6:CA:6D:DA:90:25 master-interface=wlan1 name=Virtual ssid=\
    IPTV wds-cost-range=0 wds-default-cost=0
/ip neighbor discovery
set Virtual discover=no
/interface wireless security-profiles
set [ find default=yes ] authentication-types=wpa2-psk eap-methods="" mode=\
    dynamic-keys wpa-pre-shared-key=89242729134St wpa2-pre-shared-key=\
    89242729134St
add authentication-types=wpa-psk,wpa2-psk eap-methods="" \
    management-protection=allowed name=Free supplicant-identity=""
/ip ipsec proposal
set [ find default=yes ] enc-algorithms=3des,aes-128-cbc lifetime=1h \
    pfs-group=none
/ip pool
add name=dhcp ranges=192.168.1.10-192.168.1.254
add name=dhcp2 ranges=192.168.45.1-192.168.45.100
/ip dhcp-server
add address-pool=dhcp disabled=no interface=bridge-local name=default
add address-pool=dhcp2 disabled=no interface=ether4-slave-local name=Free
/queue type
set 1 pfifo-limit=10000
add kind=pfifo name=TTK pfifo-limit=1000
set 8 kind=pfifo pfifo-limit=10000
/user group
add name=test policy="read,write,test,web,!local,!telnet,!ssh,!ftp,!reboot,!po\
    licy,!winbox,!password,!sniff,!sensitive,!api"
/interface bridge filter
add action=drop chain=forward out-interface=wlan1 packet-type=multicast
/interface bridge port
add bridge=bridge-local interface=ether2-master-local
add bridge=bridge-local interface=wlan1
add bridge=bridge-local interface=ether1-gateway
add bridge=bridge-local interface=ether3-slave-local
/interface bridge settings
set use-ip-firewall=yes use-ip-firewall-for-pppoe=yes
/ip firewall connection tracking
set enabled=yes
/interface pptp-server server
set enabled=yes keepalive-timeout=disabled
/ip address
add address=192.168.1.1/24 comment="default configuration" interface=\
    ether2-master-local network=192.168.1.0
add address=192.168.88.3/24 interface=ether5-slave-local network=192.168.88.0
add address=192.168.45.101/24 interface=ether4-slave-local network=\
    192.168.45.0
/ip arp
add address=192.168.1.2 interface=ether1-gateway mac-address=\
    1C:6F:65:BF:9B:37
add address=192.168.1.2 interface=bridge-local mac-address=1C:6F:65:BF:9B:37
/ip cloud
set update-time=no
/ip dhcp-server network
add address=192.168.1.0/24 comment="default configuration" dns-server=\
    192.168.1.1,8.8.8.8,8.8.4.4 gateway=192.168.1.1 netmask=24
add address=192.168.45.0/24 dns-server=192.168.1.1,8.8.8.8 gateway=\
    192.168.45.101 netmask=24
/ip dns
set allow-remote-requests=yes servers=8.8.8.8,8.8.4.4,192.168.100.250
/ip dns static
add address=8.8.8.8 name=Google
add address=192.168.100.250 name=Server
/ip firewall filter
add chain=input comment=IPTV protocol=igmp
add chain=forward protocol=igmp
add chain=input comment=Ping protocol=icmp
add chain=forward protocol=icmp
add chain=input comment="Accept established connections" connection-state=\
    established
add chain=forward connection-state=established
add chain=input comment="Accept related connections" connection-state=related
add chain=forward connection-state=related
add action=drop chain=input comment="Drop invalid connections" \
    connection-state=invalid
add action=drop chain=forward connection-state=invalid
add action=drop chain=output connection-state=invalid
add chain=input comment="Allow UDP" protocol=udp
add chain=forward protocol=udp
add chain=input dst-address=83.234.69.59 dst-port=1723 in-interface=\
    pppoe-out1 protocol=tcp
add chain=input dst-port=8291 protocol=udp
add action=drop chain=input comment=\
    "Access to Mikrotik only from our local network" disabled=yes \
    in-interface=pppoe-out1
/ip firewall nat
add action=masquerade chain=srcnat comment="default configuration" \
    out-interface=pppoe-out1
add action=masquerade chain=srcnat dst-address=192.168.88.0/24 out-interface=\
    ether5-slave-local
add action=masquerade chain=srcnat dst-address=192.168.100.0/24 \
    out-interface=pptp-in1
add action=netmap chain=dstnat dst-port=8080 in-interface=pppoe-out1 \
    protocol=tcp to-addresses=192.168.1.2 to-ports=8080
add action=netmap chain=dstnat comment=RDP dst-port=3389 in-interface=\
    pppoe-out1 protocol=tcp to-addresses=192.168.1.2 to-ports=3389
add action=netmap chain=dstnat dst-port=22074 in-interface=pppoe-out1 \
    protocol=tcp to-addresses=192.168.1.3 to-ports=22074
add action=netmap chain=dstnat dst-port=9 in-interface=pppoe-out1 protocol=\
    udp to-addresses=192.168.1.2 to-ports=9
add action=netmap chain=dstnat dst-port=27015 in-interface=pppoe-out1 \
    protocol=tcp to-addresses=192.168.1.2 to-ports=27015
add action=netmap chain=dstnat dst-port=27015 in-interface=ether5-slave-local \
    protocol=udp to-addresses=192.168.1.2 to-ports=27015
add action=netmap chain=dstnat dst-port=7205 in-interface=pppoe-out1 \
    protocol=tcp to-addresses=192.168.1.2 to-ports=7205
add action=netmap chain=dstnat dst-port=5394 in-interface=pppoe-out1 \
    protocol=udp to-addresses=192.168.1.2 to-ports=5394
add action=netmap chain=dstnat dst-address=192.168.1.0/24 in-interface=\
    pptp-in1 to-addresses=192.168.1.0/24
add action=masquerade chain=srcnat dst-address=192.168.2.0/24 out-interface=\
    ether4-slave-local
/ip ipsec peer
add address=83.234.69.59/32 dpd-interval=2m30s generate-policy=port-override \
    lifetime=3h passive=yes secret=89242729134St
/ip ipsec policy
set 0 disabled=yes
/ip route
add distance=1 dst-address=192.168.2.0/24 gateway=ether4-slave-local
add distance=1 dst-address=192.168.88.0/24 gateway=ether5-slave-local
add distance=1 dst-address=192.168.100.0/24 gateway=pptp-in1
/ip service
set telnet disabled=yes
set ftp disabled=yes
set ssh disabled=yes
set api disabled=yes
set api-ssl disabled=yes
/ip smb
set enabled=yes interfaces=bridge-local
/ip smb shares
add directory=/backup name=Backup
/ip smb users
add name=Backup password=89242729134St read-only=no
/ip traffic-flow
set enabled=yes interfaces=ether1-gateway
/ip upnp
set enabled=yes
/ip upnp interfaces
add interface=bridge-local type=internal
add interface=ether5-slave-local type=external
/ppp secret
add local-address=192.168.1.9 name=ppp1 password=89144331872 profile=\
    default-encryption remote-address=192.168.100.248 service=pptp
/queue interface
set ether4-slave-local queue=ethernet-default
set ether5-slave-local queue=TTK
/routing igmp-proxy
set quick-leave=yes
/routing igmp-proxy interface
add alternative-subnets=0.0.0.0/0 interface=ether5-slave-local upstream=yes
add interface=ether4-slave-local
add interface=bridge-local
/snmp
set enabled=yes
/system clock
set time-zone-autodetect=no time-zone-name=Asia/Chita
/system leds
set 5 interface=wlan1
/system ntp client
set enabled=yes primary-ntp=91.226.136.136
/system ntp server
set enabled=yes manycast=no
/system routerboard settings
set cpu-frequency=750MHz
/system scheduler
add interval=1m name=PingResetPPTP on-event=":local PingCount 6;\r\
    \n:local HostPing 192.168.100.250;\r\
    \n:local PingResultA  [/ping \$HostPing count=\$PingCount]; \r\
    \n:if (\$PingResultA < 1) do={\r\
    \n /interface pptp-server disable 1;\r\
    \n:delay 1s;\r\
    \n /interface pptp-server enable 1;\r\
    \n\r\
    \n}" policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive \
    start-time=startup
add disabled=yes interval=1w name=BACKUP on-event="/system script run backup\r\
    \n:delay 2;\r\
    \n/system script run backup_send" policy=\
    ftp,reboot,read,policy,test,password,sniff,sensitive start-date=\
    apr/18/2015 start-time=19:00:00
/system script
add name=WOL policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive source=\
    "tool wol mac=1C:6F:65:BF:9B:37"
add name="E-mail send" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive source="tool e-\
    mail send from=\"home@geochita.ru\" server=213.180.193.38 port=465 user=ho\
    me@geochita.ru password=89242729134St to=report@geochita.ru body=\"SERVER \
    is down\" subject=\"REPORT\"\r\
    \n"
add name=backup_send policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive source="tool e-\
    mail send from=\"home@geochita.ru\" server=213.180.193.38 port=465 user=ho\
    me@geochita.ru password=89242729134St to=report@geochita.ru body=\"Weekly \
    backup\" subject=\"BACKUP\" file=mikrotik.backup\r\
    \n"
add name=backup policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive source=\
    "/file remove mikrotik.backup\r\
    \n/system backup save name=mikrotik"
add name=BackupConfigTXT policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive source=\
    "export file=/backup/config_beckup_20121030.rsc"
add name=restartPptp policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive source=" /inter\
    face pptp-server disable 1;\r\
    \n:delay 1s;\r\
    \n /interface pptp-server enable 1;"
/tool bandwidth-server
set allocate-udp-ports-from=1000 authenticate=no enabled=no max-sessions=1
/tool e-mail
set address=213.180.193.38 from=Mikrotik port=587 start-tls=tls-only user=\
    home@geochita.ru
/tool mac-server
set [ find default=yes ] disabled=yes
add interface=ether2-master-local
add interface=ether3-slave-local
add interface=ether4-slave-local
add interface=ether5-slave-local
add interface=wlan1
add interface=bridge-local
/tool mac-server mac-winbox
set [ find default=yes ] disabled=yes
add interface=ether2-master-local
add interface=ether3-slave-local
add interface=ether4-slave-local
add interface=ether5-slave-local
add interface=wlan1
add interface=bridge-local
/tool netwatch
add down-script="tool e-mail send from=\"home@geochita.ru\" server=213.180.193\
    .38 port=465 user=home@geochita.ru password=89242729134St to=report@geochi\
    ta.ru body=\"KERIO is down\" subject=\"REPORT\"\r\
    \n" host=192.168.100.1
add down-script="tool e-mail send from=\"home@geochita.ru\" server=213.180.193\
    .38 port=465 user=home@geochita.ru password=89242729134St to=report@geochi\
    ta.ru body=\"SERVER is down\" subject=\"REPORT\"\r\
    \n" host=192.168.100.250

