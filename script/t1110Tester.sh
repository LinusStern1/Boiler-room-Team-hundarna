#!/usr/bin/env bash
set -u

# servers
Hosts=(
	"elev-18"
	"elev-31"
	"elev-41"
	"elev-23"
)

ATTEMPTS_PER_HOST=12
MIN_DELAY=0.5
MAX_DELAY=1.0

# 4 * 12 = 48 attempts ~50s
echo "Starting T1110 SSH brute force test across ${#Hosts[@]} hosts (${ATTEMPTS_PER_HOST} attempts each)..."

for host in "${Hosts[@]}"; do
	echo "Testing target: $host..."

	for i in $(seq 1 "$ATTEMPTS_PER_HOST"); do
		user="giltigTest${i}"

		ssh -o BatchMode=yes \
		    -o ConnectTimeout=5 \
		    -o StrictHostKeyChecking=accept-new \
		    "${user}@${host}" >/dev/null 2>&1
		rc=$?

		echo "[$(date '+%H:%M:%S')] Target: $host | Attempt: $i/$ATTEMPTS_PER_HOST | User: $user | Exit: $rc"
		#Sleep
		if ! { [[ "$host" == "${Hosts[-1]}" ]] && [[ "$i" -eq "$ATTEMPTS_PER_HOST" ]]; }; then
			#Random Sleep
			sleep_for=$(awk -v min="$MIN_DELAY" -v max="$MAX_DELAY" 'BEGIN{srand(); printf "%.2f", min+rand()*(max-min)}')
			sleep "$sleep_for"
		fi
	done
done

echo "Test completed. Check Wazuh for SSH authentication failures / T1110."
