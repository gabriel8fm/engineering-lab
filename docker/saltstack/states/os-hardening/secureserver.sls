iptables:
  pkg:
    - installed

denyhosts:
  pkg:
    - installed

psad:
  pkg:
    - installed

fail2ban:
  pkg:
    - installed

logwatch:
  pkg:
    - installed

aide:
  pkg:
    - installed

/etc/cron.daily/00logwatch:
  file:
    - managed
    - source: salt://cron.daily/00logwatch
    - require:
      - pkg: logwatch

ssh:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - match: state
    - connstate: NEW
    - dport: 22
    - proto: tcp
    - sport: 1025:65535
    - save: True

allow established:
  iptables.append:
    - table: filter
    - chain: INPUT
    - match: state
    - connstate: ESTABLISHED
    - jump: ACCEPT

default to reject:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: REJECT