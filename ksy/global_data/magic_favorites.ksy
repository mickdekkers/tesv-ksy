doc-ref: "http://en.uesp.net/wiki/Tes5Mod:Save_File_Format/Magic_Favorites"
meta:
  id: magic_favorites
  license: MIT
  endian: le
  imports:
    - common/vsval
    - common/ref_id
seq:
  - id: favorited_magic_count
    type: vsval
  - id: favorited_magic
    doc: Spells, shouts, abilities etc.
    type: ref_id
    repeat: expr
    repeat-expr: favorited_magic_count.value
  - id: magic_hotkey_count
    type: vsval
  - id: magic_hotkey
    doc: Hotkey corresponds to the position of magic in this array
    type: ref_id
    repeat: expr
    repeat-expr: magic_hotkey_count.value
