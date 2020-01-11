test_needs_several_pillars_check_pillar:
  # keys to check existence
  test.check_pillar:
    - present:
      - sse_eapi_server
      - sse_eapi_username
      - sse_eapi_password
      - sse_eapi_new_password
    - failhard: True

include:
  - prep.gitfs

licensekey_mods:
  file.managed:
    - name: /etc/raas/raas.license
    - user: raas
    - group: raas
    - replace: False

reconfigure_raas:
  file.managed:
    - name: /etc/raas/raas
    - user: raas
    - source: salt://prep/files/raas.txt
    - template: jinja
    - context:
      sse_eapi_ssl_enabled: False

reconfigure_raas.conf:
  file.managed:
    - name: /etc/salt/master.d/raas.conf
    - source: salt://prep/files/raas.conf
    - template: jinja

restart_raas_if_necessary:
  service.running:
    - name: raas
    - watch:
      - reconfigure_raas

sync_runnerside:
  cmd.run:
    - name: salt-run saltutil.sync_all

sync_minions:
  cmd.run:
    - name: "salt '*' saltutil.sync_all"
    - bg: true
    - onchanges_any:
      - pub_grain_py
