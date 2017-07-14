doc-ref: http://en.uesp.net/wiki/Tes5Mod:Save_File_Format#Plugin_Info
meta:
  id: plugin_info
  license: MIT
  endian: le
  imports:
    - common/wstring
seq:
  - id: plugin_count
    type: u1
  - id: plugins
    type: wstring
    repeat: expr
    repeat-expr: plugin_count
