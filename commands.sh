for user in $( cut -d ':' -f1 /etc/shadow ); do echo "$user: $( ps -u $user 2>/dev/null | wc -l )"; done
