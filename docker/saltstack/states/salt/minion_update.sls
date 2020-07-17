include:
 - .repo

minion_update:
  cmd.run:
    - name: |
        exec 0>&- # close stdin
        exec 1>&- # close stdout
        exec 2>&- # close stderr
        nohup /bin/sh -c 'sleep 10 && salt-call --local service.stop salt-minion && salt-call --local pkg.install salt-minion only_upgrade=true skip_verify=true && killall salt-minion && rm -f /var/run/salt-minion.pid; salt-call --local service.start salt-minion' &
    - require:
      - pkgrepo: salt-repo

