doc-ref: http://en.uesp.net/wiki/Tes5Mod:Save_File_Format#Header
meta:
  id: header
  license: MIT
  endian: le
  imports:
    - common/wstring
seq:
  - id: version
    doc: Current as of Skyrim 1.9 is 9
    contents: [0x9, 0x0, 0x0, 0x0]
  - id: save_number
    type: u4
  - id: player_name
    type: wstring
  - id: player_level
    type: u4
  - id: player_location
    type: wstring
  - id: game_date
    type: wstring
    doc: In-game date at the time of saving
  - id: player_race_editor_id
    type: wstring
  - id: player_sex
    type: u2
    doc: |
      0 = Male
      1 = Female
  - id: player_cur_exp
    type: f4
    doc: Experience gathered for level up
  - id: player_lvl_up_exp
    type: f4
    doc: Experience required for level up
  - id: filetime
    type: u8
  - id: shot_width
    type: u4
    doc: Screenshot width in pixels
  - id: shot_height
    type: u4
    doc: Screenshot height in pixels
