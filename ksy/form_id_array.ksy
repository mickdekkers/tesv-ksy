doc-ref: http://en.uesp.net/wiki/Tes5Mod:Save_File_Format#File
meta:
  id: form_id_array
  license: MIT
  endian: le
  imports:
    - common/ref_id
seq:
  - id: count
    type: u4
  - id: form_id
    type: ref_id
    repeat: expr
    repeat-expr: count
