# get all nodes
# for each node, check that an elb exists, using a certificate, pointing to the
# instance

# Using a profile from pillars
{% set key = salt.pillar.get('sse_scripts_deploy_key:myprofile') %}
{% for x in range(10) %}
{% set instance_name = '2020_ssei_610_toulouse-lab' ~ x ~ '-master' %}

Ensure myelb ELB exists - {{x}}:
    boto_elb.present:
        - name: 2020-ssei-toulouse-lab{{x}}
        - listeners:
          - elb_port: 443
            instance_port: 80
            elb_protocol: HTTPS
            instance_protocol: HTTP
            certificate: 'arn:aws:acm:eu-central-1:842104844444:certificate/6afb5fcc-0e5a-40a6-a29a-fc30e7a175c9'
        - availability_zones:
            - eu-central-1b
            - eu-central-1a
        - security_groups:
          - elb_security_groups
        - profile:
            region: {{ key.region }}
            keyid: {{ key.keyid }}
            key: {{ key.key }}




{% set id = salt.boto_ec2.get_id(name=instance_name, keyid=key.keyid, key=key.key, region=key.region) %}
add-instances_to_2020-ssei-toulouse-lab{{x}}:
  boto_elb.register_instances:
    - name: 2020-ssei-toulouse-lab{{x}}
    - profile:
        region: {{ key.region }}
        keyid: {{ key.keyid }}
        key: {{ key.key }}
    - instances:
      - {{ id }} 

{% endfor %}
