doc-ref: "http://en.uesp.net/wiki/Tes5Mod:Save_File_Format/Global_Variables"
meta:
  id: global_variables
  license: MIT
  endian: le
  imports:
    - common/vsval
    - common/ref_id
seq:
  - id: count
    type: vsval
  - id: globals
    type: global_variable
    repeat: expr
    repeat-expr: count.value
types:
  global_variable:
    seq:
      - id: form_id
        type: ref_id
      - id: value
        type: f4
