doc-ref: "http://en.uesp.net/wiki/Tes5Mod:Save_File_Format/Misc_Stats"
meta:
  id: misc_stats
  license: MIT
  endian: le
seq:
  - id: count
    type: u4
  - id: stats
    type: misc_stat
    repeat: expr
    repeat-expr: count
types:
  misc_stat:
    seq:
      - id: name
        type: wstring
      - id: category
        type: u1
        enum: e_misc_stat
      - id: value
        type: s4
enums:
  e_misc_stat:
    0: general
    1: quest
    2: combat
    3: magic
    4: crafting
    5: crime
    6: dlc
