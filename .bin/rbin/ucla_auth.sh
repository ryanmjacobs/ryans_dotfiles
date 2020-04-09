#!/bin/bash

err_cred() {
    >&2 echo 'error: $UCLA_USER and/or $UCLA_PASS are empty. (Should be in ~/rd/.env)'
    exit 1
}

. ~/.rd/.env
[ -z "$UCLA_USER" ] && err_cred
[ -z "$UCLA_PASS" ] && err_cred

echo "$UCLA_USER"

authenticate() {
    curl -X POST -d "user=$UCLA_USER&password=$UCLA_PASS"\
        netaccess.logon.ucla.edu/cgi-bin/login
}

while true; do
    # skip non-ucla networks
    conn="$(nmcli device show wlp3s0 | grep CONNECTION | awk '{print $2}')"
    if [ ! "$conn" == UCLA_WIFI ]; then
        echo "non-ucla network. skipping."
        sleep 5
        continue
    fi

    echo "detected connection to UCLA_WIFI."

    # skip if we already have working internet
    resp="$(curl -sL google.com)"
    if [[ "$resp" =~ "Feeling Lucky" ]]; then
        echo "internet online. sleeping for 2 minutes."
        sleep 120
        continue
    fi

    # otherwise authenticate
    echo "authenticating..."
    authenticate

    sleep 5
done
