#!/usr/bin/env bash

current_ip=$(ip -4 -br addr show eth2 | awk '{print $3}' | cut -d/ -f1)
logfile="logfile.log"

simon_ip="10.40.3.2"       
simon_port="443"
ibrahim_ip="10.40.3.65"   
linus_ip="10.40.3.129"     
linus_port="8080"
mohammed_ip="10.40.3.193"  
mohammed_port="5432"

# check <from-name> <to-name> <ip> <port>
check() {
	local from=$1 to=$2 ip=$3 port=$4
	timeout 3 bash -c "exec 3<>/dev/tcp/$ip/$port" 2>/dev/null
	case $? in
		0)   echo "$(date -Is) $from -> $to ($ip:$port): OPEN" | tee -a $logfile ;;
		124) echo "$(date -Is) $from -> $to ($ip:$port): NO ACCESS (timed out, likely firewalled)" | tee -a $logfile ;;
		*)   echo "$(date -Is) $from -> $to ($ip:$port): REACHABLE but port closed/refused" | tee -a $logfile ;;
	esac
}

case "$current_ip" in
	"$simon_ip")
		check "Simon" "Ibrahim" "$ibrahim_ip" "$simon_ip"
		check "Simon" "Linus" "$linus_ip" "$linus_ip"
		check "Simon" "Mohammed" "$mohammed_ip" "$mohammed_port"
		;;
	"$ibrahim_ip")
		check "Ibrahim" "Simon"    "$simon_ip"    "$simon_port"
		check "Ibrahim" "Linus"    "$linus_ip"    "$linus_port"
		check "Ibrahim" "Mohammed" "$mohammed_ip" "$mohammed_port"
		;;
	"$linus_ip")
		check "Linus" "Simon"    "$simon_ip"    "$simon_port"
		check "Linus" "Ibrahim"  "$ibrahim_ip"  "$linus_port"
		check "Linus" "Mohammed" "$mohammed_ip" "$mohammed_port"
		;;
	"$mohammed_ip")
		check "Mohammed" "Simon"    "$simon_ip"    "$simon_port"
		check "Mohammed" "Ibrahim"  "$ibrahim_ip"  "443"
		check "Mohammed" "Linus" "$mohammed_ip" "$mohammed_port"
		;;
	*)
		echo "Unknown host: $current_ip"
		;;
esac
