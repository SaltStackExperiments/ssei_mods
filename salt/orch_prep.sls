on_masters_prep:
  salt.state:
    - tgt: "*-master"
    - tgt_type: glob
    - sls:
      - prep.master
      - prep.verify_raas

on_buildbox:
  salt.state:
    - tgt: buildbox
    - sls:
      - prep.master

sync_minions:
  salt.function:
    - tgt: "*-master"
    - tgt_type: glob
    - name: cmd.run
    - arg:
      - "salt '*' saltutil.sync_all"
