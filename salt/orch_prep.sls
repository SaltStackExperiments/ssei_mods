

on_buildbox:
  salt.state:
    - tgt: buildbox
    - sls:
      - prep.bb

on_masters_prep:
  salt.state:
    - tgt: "*-master"
    - tgt_type: glob
    - sls:
      - prep.master
      - prep.verify_raas

test_test-name_check_pillar:
  # keys to check existence(comma-separated):
  # sse_eapi_new_password,sse_eapi_password
  test.check_pillar:
    - present:
      - sse_eapi_new_password
      - sse_eapi_password
    - failhard: True


{% for x in range(0,10) %}
change_root_password_lab{{x}}:
  salt.state:
    - sls:
        - prep.change_password
    - tgt: buildbox
    - pillar:
        sse_eapi_server: 2020-ssei-toulouse-lab{{x}}.ssei.lx4.us

{% endfor %}
