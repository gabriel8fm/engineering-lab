php7-fpm_groupID:
  cmd.run:
    - name: sed -i 's/33/48/g' /etc/gshadow /etc/shadow /etc/group /etc/passwd /usr/share/base-passwd/passwd.master /usr/share/base-passwd/group.master

php7-fpm_www_user:
  cmd.run:
    - name: ls /etc/init.d/ | grep fpm | xargs -i service {} stop && sed -i 's/www-data/www/g' /etc/gshadow /etc/shadow /etc/group /etc/passwd /usr/lib/tmpfiles.d/php7.0-fpm.conf /usr/share/base-passwd/passwd.master /usr/share/base-passwd/group.master && ls /etc/init.d/ | grep fpm | xargs -i service {} start