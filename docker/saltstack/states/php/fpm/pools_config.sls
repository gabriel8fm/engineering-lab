# Manages the php-fpm pools config files
{% from 'php/map.jinja' import php with context %}
{% from "php/macro.jinja" import sls_block, serialize %}

# Simple path concatenation.
{% macro path_join(file, root) -%}
  {{ root ~ '/' ~ file }}
{%- endmacro %}

{% set pool_states = [] %}

{% for pool, config in php.fpm.pools.iteritems() %}
{% set state = 'php_fpm_pool_conf_' ~ loop.index0 %}
{% set fpath = path_join(config.get('filename', pool), php.lookup.fpm.pools) %}

{{ state }}:
{% if config.enabled %}
  file.managed:
    {{ sls_block(config.get('opts', {})) }}
    - name: {{ fpath }}
    - source: salt://php/files/www.conf.jinja
    - template: jinja
    - context:
        config: {{ serialize(config.get('settings', {})) }}
{% else %}
  file.absent:
    - name: {{ fpath }}
{% endif %}

{% do pool_states.append(state) %}
{% endfor %}
