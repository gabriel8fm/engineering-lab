app_dir:
  file.directory:
    - name: {{ salt['pillar.get']('app:dir') }}
    - user: deploy
    - group: nginx
    - mode: 770
    - makedirs: True

/var/www:
  file.directory:
    - user: root
    - group: root
    - mode: 755
