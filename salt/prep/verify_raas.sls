raas_running:
  service.running:
    - name: raas
    - enable: True
    - restart: True

check_http:
  http.query:
    - name: http://localhost
    - verify_ssl: False
    - status: 200
    - match: ss_root
