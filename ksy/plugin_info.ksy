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
