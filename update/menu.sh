#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
###########- COLOR CODE -##############
colornow=$(cat /etc/hokagevpn/theme/color.conf)
export NC="\e[0m"
export YELLOW='\033[0;33m';
export RED="\033[0;31m" 
export COLOR1="$(cat /etc/hokagevpn/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
export COLBG1="$(cat /etc/hokagevpn/theme/$colornow | grep -w "BG" | cut -d: -f2|sed 's/ //g')"                    
###########- END COLOR CODE -##########
tram=$( free -h | awk 'NR==2 {print $2}' )
uram=$( free -h | awk 'NR==2 {print $3}' )
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
CITY=$(curl -s ipinfo.io/city )


BURIQ () {
    curl -sS https://raw.githubusercontent.com/hokagelegend2023/ipmini/main/ijin > /root/tmp
    data=( `cat /root/tmp | grep -E "^### " | awk '{print $2}'` )
    for user in "${data[@]}"
    do
    exp=( `grep -E "^### $user" "/root/tmp" | awk '{print $3}'` )
    d1=(`date -d "$exp" +%s`)
    d2=(`date -d "$biji" +%s`)
    exp2=$(( (d1 - d2) / 86400 ))
    if [[ "$exp2" -le "0" ]]; then
    echo $user > /etc/.$user.ini
    else
    rm -f /etc/.$user.ini > /dev/null 2>&1
    fi
    done
    rm -f /root/tmp
}

MYIP=$(curl -sS ipv4.icanhazip.com)
Name=$(curl -sS https://raw.githubusercontent.com/hokagelegend2023/ipmini/main/ijin | grep $MYIP | awk '{print $2}')
Isadmin=$(curl -sS https://raw.githubusercontent.com/hokagelegend2023/ipmini/main/ijin | grep $MYIP | awk '{print $5}')
echo $Name > /usr/local/etc/.$Name.ini
CekOne=$(cat /usr/local/etc/.$Name.ini)

Bloman () {
if [ -f "/etc/.$Name.ini" ]; then
CekTwo=$(cat /etc/.$Name.ini)
    if [ "$CekOne" = "$CekTwo" ]; then
        res="Expired"
    fi
else
res="Permission Accepted..."
fi
}

PERMISSION () {
    MYIP=$(curl -sS ipv4.icanhazip.com)
    IZIN=$(curl -sS https://raw.githubusercontent.com/hokagelegend2023/ipmini/main/ijin | awk '{print $4}' | grep $MYIP)
    if [ "$MYIP" = "$IZIN" ]; then
    Bloman
    else
    res="Permission Denied!"
    fi
    BURIQ
}

x="ok"


PERMISSION

if [ "$res" = "Expired" ]; then
Exp="\e[36mExpired\033[0m"
rm -f /home/needupdate > /dev/null 2>&1
else
Exp=$(curl -sS https://raw.githubusercontent.com/hokagelegend2023/ipmini/main/ijin | grep $MYIP | awk '{print $3}')
fi
export RED='\033[0;31m'
export GREEN='\033[0;32m'

# // SSH Websocket Proxy
ssh_ws=$( systemctl status ws-tls | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $ssh_ws == "running" ]]; then
    status_ws="${GREEN}ON${NC}"
else
    status_ws="${RED}OFF${NC}"
fi

# // nginx
nginx=$( systemctl status nginx | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $nginx == "running" ]]; then
    status_nginx="${GREEN}ON${NC}"
else
    status_nginx="${RED}OFF${NC}"
fi

# // SSH Websocket Proxy
xray=$( systemctl status xray | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $xray == "running" ]]; then
    status_xray="${GREEN}ON${NC}"
else
    status_xray="${RED}OFF${NC}"
fi

# // SSH Websocket Proxy
dropbear=$( systemctl status dropbear | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $xray == "running" ]]; then
    status_dropbear="${GREEN}ON${NC}"
else
    status_dropbear="${RED}OFF${NC}"
fi

# // SSH PPTP
pptp=$( systemctl status pptpd | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $xray == "running" ]]; then
    status_pptp="${GREEN}ON${NC}"
else
    status_pptp="${RED}OFF${NC}"
fi

# // SSH SSTP
sstp=$( systemctl status accel-ppp | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $sstp == "running" ]]; then
    status_sstp="${GREEN}ON${NC}"
else
    status_sstp="${RED}OFF${NC}"
fi

# // SSH L2TP
l2tp=$( systemctl status xl2tpd | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $l2tp == "running" ]]; then
    status_l2tp="${GREEN}ON${NC}"
else
    status_l2tp="${RED}OFF${NC}"
fi

# // SSH WIREGUARD
wg=$( systemctl status wg-quick@wg0 | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $xray == "running" ]]; then
    status_wg="${GREEN}ON${NC}"
else
    status_wg="${RED}OFF${NC}"
fi

function add-host(){
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}               • ADD VPS HOST •                ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
read -rp "  New Host Name : " -e host
echo ""
if [ -z $host ]; then
echo -e "  [INFO] Type Your Domain/sub domain"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "  Press any key to back on menu"
menu
else
echo "IP=$host" > /var/lib/hokage-pro/ipvps.conf
echo ""
echo "  [INFO] Dont forget to renew cert"
echo ""
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "  Press any key to Renew Cret"
crtxray
fi
}
function updatews(){
clear

echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}            • UPDATE SCRIPT VPS •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC}  $COLOR1[INFO]${NC} Check for Script updates"
sleep 2
wget -q -O /root/update_beta2 "https://raw.githubusercontent.com/hokagelegend2023/update/main/update_beta2" && chmod +x /root/install_up.sh
sleep 2
./update_beta2.sh
sleep 5
rm /root/install_up.sh
rm /opt/.ver
version_up=$(curl -sS https://raw.githubusercontent.com/hokagelegend2023/ipmini/main/versi)
echo "$version_up" > /opt/.ver
echo -e "$COLOR1│${NC}  $COLOR1[INFO]${NC} Successfully Up To Date!"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}              • HOKAGE LEGEND •                $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo ""
read -n 1 -s -r -p "  Press any key to back on menu"
menu
}
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}               • VPS PANEL MENU •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1 <<────────────────────────────────────────────────────>>${NC}"
uphours=`uptime -p | awk '{print $2,$3}' | cut -d , -f1`
upminutes=`uptime -p | awk '{print $4,$5}' | cut -d , -f1`
uptimecek=`uptime -p | awk '{print $6,$7}' | cut -d , -f1`
cekup=`uptime -p | grep -ow "day"`
IPVPS=$(curl -s ipinfo.io/ip )
serverV=$(curl -sS https://raw.githubusercontent.com/hokagelegend2023/ipmini/main/versi)
if [ "$Isadmin" = "ON" ]; then
uis="${GREEN}Premium User$NC"
else
uis="${RED}Free Version$NC"
fi
echo -e "$COLOR1  $NC User Roles     : $uis    "
if [ "$cekup" = "day" ]; then
echo -e "$COLOR1  $NC System Uptime  : $uphours $upminutes $uptimecek           "
else
echo -e "$COLOR1  $NC System Uptime  : $uphours $upminutes                       "
fi
echo -e "$COLOR1  $NC Memory Usage   : $uram / $tram                        "
echo -e "$COLOR1  $NC ISP            : $ISP  "
echo -e "$COLOR1  $NC City           : $CITY                        "
echo -e "$COLOR1  $NC Current Domain : $(cat /etc/xray/domain)          "
echo -e "$COLOR1  $NC IP-VPS         : ${COLOR1}$IPVPS${NC}         "
echo -e "$COLOR1 <<─────────────────────────────────────────────────────>>${NC}"
echo -e "$COLOR1┌────────────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│$NC [ SSH WS   : ${status_ws} ]  [ XRAY : ${status_xray} ]      [ NGINX : ${status_nginx} ]   $COLOR1│$NC"
echo -e "$COLOR1│$NC                                                        $COLOR1│$NC"
echo -e "$COLOR1│$NC [ SW-SHOCK : ${status_xray} ]  [ DROPBEAR : ${status_dropbear} ]  [ PPTP : ${status_pptp} ]    $COLOR1│$NC"
echo -e "$COLOR1│$NC                                                        $COLOR1│$NC"
echo -e "$COLOR1│$NC [ WIREGUARD: ${status_wg} ]  [ L2TP : ${status_l2tp} ]      [ SSTP : ${status_sstp} ]    $COLOR1│$NC"
echo -e "$COLOR1│$NC                                                        $COLOR1│$NC"
echo -e "$COLOR1└────────────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌────────────────────────────────────────────────────────────┐${NC}"
echo -e "${COLOR1}│  [01]${NC} • SSHWS      [${YELLOW}Menu${NC}]   ${COLOR1}[09]${NC} • PPTP            [${YELLOW}Menu${NC}]  $COLOR1│$NC"   
echo -e "${COLOR1}│  [02]${NC} • VMESS      [${YELLOW}Menu${NC}]   ${COLOR1}[10]${NC} • BACKUP          [${YELLOW}Menu${NC}]  $COLOR1│$NC"  
echo -e "${COLOR1}│  [03]${NC} • VLESS      [${YELLOW}Menu${NC}]   ${COLOR1}[11]${NC} • VPN RUNNING     [${YELLOW}Menu${NC}]  $COLOR1│$NC"  
echo -e "${COLOR1}│  [04]${NC} • TROJAN     [${YELLOW}Menu${NC}]   ${COLOR1}[12]${NC} • THEME           [${YELLOW}Menu${NC}]  $COLOR1│$NC"  
echo -e "${COLOR1}│  [05]${NC} • SW-Shock   [${YELLOW}Menu${NC}]   ${COLOR1}[13]${NC} • SETTINGS        [${YELLOW}Menu${NC}]  $COLOR1│$NC"
echo -e "${COLOR1}│  [06]${NC} • WIREGUARD  [${YELLOW}Menu${NC}]   ${COLOR1}[14]${NC} • INFO            [${YELLOW}Menu${NC}]  $COLOR1│$NC"
echo -e "${COLOR1}│  [07]${NC} • SSTP       [${YELLOW}Menu${NC}]   ${COLOR1}[15]${NC} • ADD HOST/DOMAIN         $COLOR1│$NC"
echo -e "${COLOR1}│  [08]${NC} • L2TP       [${YELLOW}Menu${NC}]   ${COLOR1}[16]${NC} • RENEW CERT              $COLOR1│$NC"
if [ "$Isadmin" = "ON" ]; then
echo -e "${COLOR1}│                                                            $COLOR1│$NC"
ressee="menu-ip"
bottt="menu-bot"
else
ressee="menu"
bottt="menu"
fi
echo -e "$COLOR1└────────────────────────────────────────────────────────────┘${NC}"
myver="$(cat /opt/.ver)"

if [[ $serverV > $myver ]]; then
echo -e "$RED┌─────────────────────────────────────────────────┐${NC}"
echo -e "$RED│$NC ${COLOR1}[100]${NC} • UPDATE TO V$serverV" 
echo -e "$RED└─────────────────────────────────────────────────┘${NC}"
up2u="updatews"
else
up2u="menu"
fi

DATE=$(date +'%d %B %Y')
datediff() {
    d1=$(date -d "$1" +%s)
    d2=$(date -d "$2" +%s)
    echo -e "$COLOR1│$NC Expiry In   : $(( (d1 - d2) / 86400 )) Days"
}
mai="datediff "$Exp" "$DATE""

echo -e "$COLOR1┌─────────────────────────────────────────────────┐$NC"
echo -e "$COLOR1│$NC Version     :${COLOR1} $(cat /opt/.ver) ( Alpha 1 )                   $COLOR1│$NC"
echo -e "$COLOR1│$NC Client Name : $Name                           $COLOR1│$NC"
if [ $exp \> 1000 ];
then
    echo -e "$COLOR1│$NC License     : Lifetime                          $COLOR1│$NC"
else
    datediff "$Exp" "$DATE"
fi;
echo -e "$COLOR1└─────────────────────────────────────────────────┘$NC"
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}              • HOKAGE LEGEND •                  $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e ""
echo -ne " Select menu : "; read opt
case $opt in
01 | 1) clear ; sshovpnmenu ;;
02 | 2) clear ; vmessmenu ;;
03 | 3) clear ; vlessmenu ;;
04 | 4) clear ; trmenu ;;
05 | 5) clear ; ssmenu ;;
06 | 6) clear ; wgmenu ;;
06 | 7) clear ; sstpmenu ;;
07 | 8) clear ; l2tpmenu ;;
09 | 9) clear ; pptpmenu ;;
10 | 10) clear ; backup ;;
11 | 11) clear ; running ;;
12 | 12) clear ; menutheme ;;
13 | 13) clear ; setmenu ;;
14 | 14) clear ; menuinfo ;;
15 | 15) clear ; addhost ;;
16 | 16) clear ; certv2ray ;;
100) clear ; $up2u ;;
00 | 0) clear ; menu ;;
*) clear ; menu ;;
esac
