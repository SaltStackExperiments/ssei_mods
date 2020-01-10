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

