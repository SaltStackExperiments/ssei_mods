include:
  - prep.gitfs

packages_i_want:
  pkg.installed:
    - names:
      - jq
      - vim
      - tree

{% for x in range(10) %}
change_root_password_lab{{x}}:
  sse_user.password_set:
    - name: root
    - password: {{ salt.pillar.get('sse_eapi_new_password') }}
    - pillar:
        sse_eapi_server: 2020-ssei-toulouse-lab{{x}}.ssei.lx4.us

{% endfor %}

pip_packages:
  pip.installed:
    - name: pynamecom

manage_vimrc:
  file.managed:
    - name: /root/.vimrc
    - source: salt://prep/files/_vimrc
    - user: root

manage_etc_master_d_roots_conf:
  file.managed:
    - name: /etc/salt/master.d/roots.conf
    - source: salt://prep/files/roots.conf 
    - user: root

manage_cloud_profile:
  file.managed:
    - name: /etc/salt/cloud.profiles.d/profile.conf
    - source: salt://prep/files/profile.conf
    - user: root

restart_salt_master:
  cmd.run:
    - name: salt-call service.restart salt-master
    - bg: true
    - onchanges_any:
      - manage_vimrc
      - manage_etc_master_d_roots_conf
