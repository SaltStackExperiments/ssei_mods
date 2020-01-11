
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

restart_master:
  cmd.run:
    - name: salt-call --local service.restart salt-master
    - onchanges_any:
      - installer_git_GitPython

