meta:
  id: tesv_savegame
  title: "Skyrim Save Format"
  application: "The Elder Scrolls V: Skyrim"
  file-extension: ess
  license: MIT
  endian: le
  encoding: "windows-1252"
seq:
  - id: magic
    contents: [0x54, 0x45, 0x53, 0x56, 0x5F, 0x53, 0x41, 0x56, 0x45, 0x47, 0x41, 0x4D, 0x45]
  - id: header_size
    type: u4
  - id: header
    type: header
  - id: shot_width
    type: u4
    doc: Screenshot width in pixels
  - id: shot_height
    type: u4
    doc: Screenshot height in pixels
  - id: screenshot_data
    size: 3 * shot_width * shot_height
    doc: RGB pixel data of the image
  - id: form_version
    contents: [0x4a]
  - id: plugin_info_size
    type: u4
  - id: plugin_info
    type: plugin_info
  - id: file_location_table
    type: file_location_table
instances:
  form_id_array:
    type: form_id_array
    pos: file_location_table.form_id_array_count_offset
  global_data_table_1:
    pos: file_location_table.global_data_table_1_offset
    type: global_data_record
    repeat: expr
    repeat-expr: file_location_table.global_data_table_1_count
  global_data_table_2:
    pos: file_location_table.global_data_table_2_offset
    type: global_data_record
    repeat: expr
    repeat-expr: file_location_table.global_data_table_2_count
  global_data_table_3:
    pos: file_location_table.global_data_table_3_offset
    type: global_data_record
    repeat: expr
    repeat-expr: file_location_table.global_data_table_3_count
types:
  header:
    seq:
      - id: version
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
  plugin_info:
    seq:
      - id: plugin_count
        type: u1
      - id: plugins
        type: wstring
        repeat: expr
        repeat-expr: plugin_count
  file_location_table:
    seq:
      - id: form_id_array_count_offset
        type: u4
        doc: Absolute offset to the start of File.formIDArrayCount
      - id: unknown_table_3_offset
        type: u4
        doc: Absolute offset to the start of File.unknown3TableSize
      - id: global_data_table_1_offset
        type: u4
        doc: Absolute offset to the start of File.globalDataTable1
      - id: global_data_table_2_offset
        type: u4
        doc: Absolute offset to the start of File.globalDataTable2
      - id: change_forms_offset
        type: u4
        doc: Absolute offset to the start of File.changeForms
      - id: global_data_table_3_offset
        type: u4
        doc: Absolute offset to the start of File.globalDataTable3
      - id: global_data_table_1_count
        type: u4
        doc: The number of Global Data in File.globalDataTable1
      - id: global_data_table_2_count
        type: u4
        doc: The number of Global Data in File.globalDataTable2
      - id: global_data_table_3_count
        type: u4
        doc: The number of Global Data in File.globalDataTable3
      - id: change_forms_count
        type: u4
  form_id_array:
    seq:
      - id: count
        type: u4
      - id: form_id
        type: ref_id
        repeat: expr
        repeat-expr: count
  wstring:
    seq:
      - id: size
        type: u2
      - id: string
        type: str
        size: size
  ref_id:
    seq:
      - id: byte0
        type: u1
      - id: byte1
        type: u1
      - id: byte2
        type: u1
  vsval:
    # Thanks to @koczkatamas
    doc: Variable-sized value
    seq:
      - id: byte1
        type: u1
      - id: byte2
        type: u1
        if: (byte1 & 0b11) >= 1
      - id: byte34
        type: u2le
        if: (byte1 & 0b11) >= 2
    instances:
      value:
        value: >
          (byte1 >> 2) |
          (((byte1 & 0b11) >= 1) ? (byte2 << 6) : 0) | 
          (((byte1 & 0b11) >= 2) ? (byte34 << 14) : 0)
  global_data_record:
    seq:
      - id: record_type
        type: u4
      - id: record_length
        type: u4
      - id: record_data
        size: record_length
        type:
          switch-on: record_type
          cases:
            0: misc_stats
            1: player_location
            3: global_variables
            4: created_objects
            6: weather
            7: audio
  misc_stats:
    doc: "http://en.uesp.net/wiki/Tes5Mod:Save_File_Format/Misc_Stats"
    seq:
      - id: count
        type: u4
      - id: stats
        type: misc_stat
        repeat: expr
        repeat-expr: count
  misc_stat:
    seq:
      - id: name
        type: wstring
      - id: category
        type: u1
        enum: e_misc_stat
      - id: value
        type: s4
  player_location:
    doc: "http://en.uesp.net/wiki/Tes5Mod:Save_File_Format/Player_Location"
    seq:
      - id: next_object_id
        doc: Number of next savegame specific object id, i.e. FFxxxxxx
        type: u4
      - id: world_space_1
        doc: 	This form is usually 0x0 or a worldspace. coorX and coorY represent a cell in this worldspace
        type: ref_id
      - id: coor_x
        doc: x-coordinate (cell coordinates) in worldSpace1
        type: s4
      - id: coor_y
        doc: y-coordinate (cell coordinates) in worldSpace1
        type: s4
      - id: world_space_2
        doc: "This can be either a worldspace or an interior cell. If it's a worldspace, the player is located at the cell (coorX, coorY). posX/Y/Z is the player's position inside the cell"
        type: ref_id
      - id: pos_x
        doc: x-coordinate in worldSpace2
        type: f4
      - id: pos_y
        doc: y-coordinate in worldSpace2
        type: f4
      - id: pos_z
        doc: z-coordinate in worldSpace2
        type: f4
  global_variables:
    doc: "http://en.uesp.net/wiki/Tes5Mod:Save_File_Format/Global_Variables"
    seq:
      - id: count
        type: vsval
      - id: globals
        type: global_variable
        repeat: expr
        repeat-expr: count.value
  global_variable:
    seq:
      - id: form_id
        type: ref_id
      - id: value
        type: f4
  created_objects:
    doc: "http://en.uesp.net/wiki/Tes5Mod:Save_File_Format/Created_Objects"
    seq:
      - id: weapon_count
        type: vsval
      - id: weapon_enchs
        doc: List of all created enchantments that have been applied to weapons
        type: enchantment
        repeat: expr
        repeat-expr: weapon_count.value
      - id: armor_count
        type: vsval
      - id: armor_enchs
        doc: List of all created enchantments that have been applied to armor. Not sure which types of armor (Body/Gloves/Boots/Shield/etc) this encompasses.
        type: enchantment
        repeat: expr
        repeat-expr: armor_count.value
      - id: potion_count
        type: vsval
      - id: potions
        doc: List of all created potions
        type: enchantment
        repeat: expr
        repeat-expr: potion_count.value
      - id: poison_count
        type: vsval
      - id: poisons
        doc: List of all created poisons
        type: enchantment
        repeat: expr
        repeat-expr: poison_count.value
  enchantment:
    seq:
      - id: ref_id
        doc: FormID of the enchantment
        type: ref_id
      - id: times_used
        type: u4
      - id: count
        type: vsval
      - id: effects
        type: magic_effect
        repeat: expr
        repeat-expr: count.value
  magic_effect:
    seq:
      - id: effect_id
        type: ref_id
      - id: info
        type: ench_info
      - id: price
        doc: Amount this enchantment adds to the base item's price
        type: f4
  ench_info:
    seq:
      - id: magnitude
        type: f4
      - id: duration
        type: u4
      - id: area
        type: u4
  weather:
    seq:
      - id: climate
        type: ref_id
      - id: weather
        type: ref_id
      - id: prev_weather
        doc: Only during weather transition. In other cases it equals zero.
        type: ref_id
      - id: unk_weather_1
        type: ref_id
      - id: unk_weather_2
        type: ref_id
      - id: regn_weather
        type: ref_id
      - id: cur_time
        doc: Current in-game time in hours
        type: f4
      - id: beg_time
        doc: Time of current weather beginning
        type: f4
      - id: weather_pct
        doc: A value from 0.0 to 1.0 describing how far in the current weather has transitioned
        type: f4
      # Skip unknown data
      - size: 4 * 8
      - id: flags
        type: u1
  audio:
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
enums:
  e_misc_stat:
    0: general
    1: quest
    2: combat
    3: magic
    4: crafting
    5: crime
    6: dlc
