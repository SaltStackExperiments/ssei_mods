pub_grain_py:
  file.managed:
     - name: /srv/salt/_grains/aws_pub_ip.py
     - source: salt://_grains/aws_pub_ip.py
     - makedirs: True

# install git, GitPython
installer_git_GitPython:
  pkg.installed:
    - names:
      - git
      - GitPython

configure_GitFS:
  file.managed:
    - name: /etc/salt/master.d/z-files.conf
    - source: salt://prep/files/files.conf

configure_deploy_key_pem:
  file.managed:
    - name: /etc/salt/git_deploy.pem
    - mode: 0400
    - contents_pillar: sse_scripts_deploy_key:pem

strict_host_checking:
  file.managed:
    - name: /root/.ssh/config
    - mkdirs: True
    - source: salt://prep/files/ssh_config


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

restart_master:
  cmd.run:
    - name: salt-call --local service.restart salt-master
    - onchanges_any:
      - installer_git_GitPython
      - reconfigure_raas.conf

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
      - configure_GitFS
