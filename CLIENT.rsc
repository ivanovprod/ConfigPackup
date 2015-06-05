# jun/01/2015 09:00:00 by RouterOS 6.27
# software id = BB4M-7R5H
#
/interface bridge
add name=bridge1
/interface wireless
set [ find default-name=wlan1 ] adaptive-noise-immunity=client-mode band=\
    5ghz-onlyn basic-rates-a/g="" channel-width=20/40mhz-ht-below disabled=no \
    frequency=5485 frequency-mode=superchannel ht-guard-interval=long \
    hw-retries=2 l2mtu=2290 mode=station-wds mtu=1492 multicast-helper=full \
    name=wlan1-gateway nv2-preshared-key=89242729134St nv2-security=enabled \
    scan-list=5485 supported-rates-a/g="" tx-power=11 tx-power-mode=\
    all-rates-fixed wds-default-bridge=bridge1 wds-mode=dynamic \
    wireless-protocol=nv2
/interface ethernet
set [ find default-name=ether1 ] advertise=\
    10M-half,10M-full,100M-half,100M-full auto-negotiation=no l2mtu=1492 mtu=\
    1492 name=ether1-local
/ip neighbor discovery
set ether1-local discover=no
set wlan1-gateway discover=no
set bridge1 discover=no
/queue type
set 1 pfifo-limit=10000
set 2 kind=pfifo pfifo-limit=10000
/interface bridge filter
add action=drop chain=input in-interface=wlan1-gateway packet-type=multicast
/interface bridge port
add bridge=bridge1 interface=ether1-local
add bridge=bridge1 interface=wlan1-gateway
/ip firewall connection tracking
set enabled=no
/ip address
add address=192.168.88.2/24 comment="default configuration" interface=bridge1 \
    network=192.168.88.0
/ip dns static
add address=192.168.88.1 name=router
/ip route
add distance=1 dst-address=192.168.1.0/24 gateway=ether1-local
/ip smb
set allow-guests=no comment=MikrotikClient enabled=yes interfaces=bridge1
/ip smb shares
add directory=/backup name=backup
/ip smb users
add name=admin password=89242729134St read-only=no
/queue interface
set ether1-local queue=ethernet-default
/snmp
set enabled=yes
/system clock
set time-zone-autodetect=no time-zone-name=Asia/Chita
/system leds
set 0 interface=wlan1-gateway
/system ntp client
set enabled=yes primary-ntp=192.168.88.3
/system scheduler
add interval=1m name=PingReset on-event=":local PingCount 6;\r\
    \n:local HostPing 192.168.88.1;\r\
    \n:local PingResultA [/ping \$HostPing count=\$PingCount]; \r\
    \n\r\
    \n:if (\$PingResultA > 0) do={ :put \"Connected\"} else={/system reboot}\r\
    \n:delay 500ms;}" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive start-time=\
    startup
add interval=1w name=backup on-event="/system script run backup" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive start-date=\
    may/25/2015 start-time=09:00:00
/system script
add name=backup policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive source=\
    "file remove backup/CLIENT.rsc \r\
    \nexport file=backup/CLIENT.rsc "
/tool mac-server
set [ find default=yes ] disabled=yes
add interface=ether1-local
/tool mac-server mac-winbox
set [ find default=yes ] disabled=yes
add interface=ether1-local
