# Meta-state to fully install php.fpm

include:
  - php.fpm.config
  - php.fpm.service
  - php.fpm.pools

extend:
  php_fpm_service:
    service:
      - watch:
        - file: php_fpm_ini_config
        - file: php_fpm_conf_config
      - require:
        - sls: php.fpm.config
  php_fpm_ini_config:
    file:
      - require:
        - pkg: php_install_fpm
  php_fpm_conf_config:
    file:
      - require:
        - pkg: php_install_fpm
