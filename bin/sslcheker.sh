#!/bin/sh


# echo | openssl s_client -connect $1:443 -servername $1 2> /dev/null | openssl x509 -noout -dates

gracedays=30

while read p; do
	# echo ""
	# echo "${p}"
	# output=$(echo | openssl s_client -connect $p:443 -servername $p 2> /dev/null | openssl x509 -noout -dates | sed -e 's#notAfter=##')
	# #endDate=$(echo $output | awk -F= '$1=="notAfter"{print $2}')
	# echo $output

	# case $p in \#*) continue ;; esac

    data=`echo | openssl s_client -connect "${p}:443" -servername "${p}" 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | sed -e 's#notAfter=##'`

	# echo $data

    ssldate=`gdate -d "${data}" '+%s'`
    nowdate=`gdate '+%s'`
    diff="$((${ssldate}-${nowdate}))"

    if test "${diff}" -lt "$((${gracedays}*24*3600))";
    then
        if test "${diff}" -lt "0";
        then
            echo "The certificate for ${p} has already expired."
        else
            echo "The certificate for ${p} will expire in $((${diff}/3600/24)) days on ${data}."
        fi
    fi

done <testdomains.txt

# | awk -F= '$1=="notAfter"{print $2}'
