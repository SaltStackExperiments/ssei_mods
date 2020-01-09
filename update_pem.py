from six.moves import input
import json
import yaml

print("You really must update the pillar/deploy.sls file to contain an actual "
      "private pem key")

contents = []
print("what is the PEM key? press CTL-D to save")
while True:
    try:
        line = input("")
    except EOFError:
        break
    contents.append(line.lstrip())

pem = '\n'.join(contents)

with open('./pillar/deploy.sls') as _f:
    yaml_file = yaml.load(_f)
    yaml_file['sse_scripts_deploy_key']['pem'] = pem
    print(yaml_file)

with open('./pillar/deploy-bk.sls', 'w') as _f:
    _f.write('#! jinja|json\n')
    json.dump(yaml_file, _f, indent=2)
