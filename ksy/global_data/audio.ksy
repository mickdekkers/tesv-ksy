doc-ref: "http://en.uesp.net/wiki/Tes5Mod:Save_File_Format/Audio"
meta:
  id: audio
  license: MIT
  endian: le
  encoding: "windows-1252"
  imports:
    - common/vsval
    - common/ref_id
seq:
  # Skip unknown ref_id
  - size: 3
  - id: tracks_count
    type: vsval
  - id: tracks
    doc: Seems to contain music tracks (MUST records) that were playing at the time of saving, not including the background music.
    type: ref_id
    repeat: expr
    repeat-expr: tracks_count.value
  - id: bgm
    doc: Background music at time of saving. Only MUST records have been observed here.
    type: ref_id
