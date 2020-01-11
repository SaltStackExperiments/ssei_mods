change_password:
  sse_user.password_set:
    - name: root
    - password: {{ salt.pillar.get('sse_eapi_new_password') }}
    - force: True
