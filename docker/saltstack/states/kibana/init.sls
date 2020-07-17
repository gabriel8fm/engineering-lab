# -*- coding: utf-8 -*-
# vim: ft=sls

include:
  - kibana.install
# FIXME: add support for source install for the bottom two
  - kibana.config
  - kibana.service
