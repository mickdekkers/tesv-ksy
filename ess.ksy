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
    doc: This is always "TESV_SAVEGAME"
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
    doc: Current as of Skyrim 1.9 is 74
    contents: [0x4A]
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
  change_forms:
    pos: file_location_table.change_forms_offset
    type: change_form
    repeat: expr
    repeat-expr: file_location_table.change_forms_count
types:
  header:
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
            100: process_list
            109: magic_favorites
            112: ingredient_shared
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
        doc: This form is usually 0x0 or a worldspace. coorX and coorY represent a cell in this worldspace
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
    doc: "http://en.uesp.net/wiki/Tes5Mod:Save_File_Format/Weather"
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
    doc: "http://en.uesp.net/wiki/Tes5Mod:Save_File_Format/Audio"
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
  process_list:
    doc: "http://en.uesp.net/wiki/Tes5Mod:Save_File_Format/Process_Lists"
    seq:
      # Skip unknown floats
      - size: 4 * 3
      - id: next_num
        doc: The value assigned to the next process
        type: u4
      - id: all_crimes
        doc: Crimes grouped according to their type
        type: crime_group
        repeat: expr
        repeat-expr: 7
  crime_group:
    seq:
      - id: count
        type: vsval
      - id: crimes
        type: crime
        repeat: expr
        repeat-expr: count.value
  # TODO: test crime type, I've never committed one ¯\_(ツ)_/¯
  crime:
    seq:
      - id: witness_num
        type: u4
      - id: crime_type
        type: u4
        enum: e_crime_type
      # Skip unknown u1
      - size: 1
      - id: quantity
        doc: The number of stolen items (e.g. if you've stolen Gold(7), it would be equals to 7). Only for thefts
        type: u4
      - id: serial_num
        doc: Assigned in accordance with nextNum
        type: u4
      # Skip unknown u1 + u4
      - size: 1 + 4
      - id: elapsed_time
        doc: Negative value measured from moment of crime
        type: f4
      - id: victim_id
        doc: The killed, forced door, stolen item etc.
        type: ref_id
      - id: criminal_id
        type: ref_id
      - id: item_base_id
        doc: Only for thefts
        type: ref_id
      - id: ownership_id
        doc: Faction, outfit etc. Only for thefts
        type: ref_id
      - id: witness_count
        type: vsval
      - id: witnesses
        type: ref_id
        repeat: expr
        repeat-expr: witness_count.value
      - id: bounty
        type: u4
      - id: crime_faction_id
        type: ref_id
      - id: is_cleared
        doc: 0 - active crime, 1 - it was atoned
        type: u1
  magic_favorites:
    doc: "http://en.uesp.net/wiki/Tes5Mod:Save_File_Format/Magic_Favorites"
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
  ingredient_shared:
    doc: |
      Pairs of failed ingredient combinations in alchemy.
      http://en.uesp.net/wiki/Tes5Mod:Save_File_Format/Ingredient_Shared
    seq:
      - id: count
        type: u4
      - id: ingredients_combined
        type: ingredient_combination
        repeat: expr
        repeat-expr: count
  ingredient_combination:
    seq:
      - id: ingredient_0
        type: ref_id
      - id: ingredient_1
        type: ref_id
  change_form:
    seq:
      - id: form_id
        type: ref_id
      - id: change_flags
        type: u4
      - id: length_size
        doc: The size of the data lengths
        type: b2
      - id: change_form_type
        doc: The type of form
        type: b6
        enum: e_change_form_type
      - id: version
        doc: Current as of Skyrim 1.9 is 74
        contents: [0x4A]
      - id: length
        doc: Length of following data
        type:
          switch-on: length_size
          cases:
            0: u1
            1: u2
            2: u4
            # _: throw_error
      - id: uncompressed_length
        doc: If this value is non-zero, data is compressed. This value then represents the uncompressed length
        type:
          switch-on: length_size
          cases:
            0: u1
            1: u2
            2: u4
            # _: throw_error
      - id: data_uncomp
        size: length
        if: uncompressed_length == 0
        type:
          switch-on: change_form_type
          cases:
            e_change_form_type::refr: change_form_refr
            e_change_form_type::cell: change_form_cell
      - id: data_comp
        size: length
        process: zlib
        if: uncompressed_length > 0
        type:
          switch-on: change_form_type
          cases:
            e_change_form_type::refr: change_form_refr
            e_change_form_type::cell: change_form_cell
    instances:
      data:
        value: >
          (uncompressed_length > 0) ? data_comp : data_uncomp
  change_form_refr:
    seq:
      - id: initial_data
        type: change_form_initial_data
        parent: _parent
  change_form_cell:
    seq:
      - id: initial_data
        type: change_form_initial_data
        parent: _parent
  change_form_initial_data:
    seq:
      - id: value
        type:
          switch-on: initial_type
          cases:
            0: initial_type_0
            1: initial_type_1
            2: initial_type_2
            3: initial_type_3
            4: initial_type_4
            5: initial_type_5
            6: initial_type_6
    types:
      initial_type_0:
        doc: No initial data
      initial_type_1:
        seq:
          # Skip unknown u2
          - size: 2
          - id: cell_x
            type: u1
          - id: cell_y
            type: u1
          # Skip unknown u4
          - size: 4
      initial_type_2:
        seq:
          # Skip unknown u2
          - size: 2
          # Skip unknown s2
          - size: 2
          # Skip unknown s2
          - size: 2
          # Skip unknown u4
          - size: 4
      initial_type_3:
        seq:
          # Skip unknown u4
          - size: 4
      initial_type_4:
        seq:
          - id: cell_world
            type: ref_id
          # TODO: check if these are actually in x-y-z order
          - id: pos_x
            type: f4
          - id: pos_y
            type: f4
          - id: pos_z
            type: f4
          - id: rot_x
            type: f4
          - id: rot_y
            type: f4
          - id: rot_z
            type: f4
      initial_type_5:
        seq:
          - id: cell_world
            type: ref_id
          # TODO: check if these are actually in x-y-z order
          - id: pos_x
            type: f4
          - id: pos_y
            type: f4
          - id: pos_z
            type: f4
          - id: rot_x
            type: f4
          - id: rot_y
            type: f4
          - id: rot_z
            type: f4
          # Skip unknown u1
          - size: 1
          - id: base_object
            type: ref_id
      initial_type_6:
        seq:
          - id: cell_world
            type: ref_id
          # TODO: check if these are actually in x-y-z order
          - id: pos_x
            type: f4
          - id: pos_y
            type: f4
          - id: pos_z
            type: f4
          - id: rot_x
            type: f4
          - id: rot_y
            type: f4
          - id: rot_z
            type: f4
          - id: starting_cell_world
            type: ref_id
          # Skip unknown s2
          - size: 2
          # Skip unknown s2
          - size: 2
    instances:
      change_type:
        value: _parent.change_form_type
      change_flags:
        value: _parent.change_flags
      form_id:
        value: _parent.form_id
      initial_type:
        # For comments see https://github.com/mickdekkers/tesv-ksy/blob/a3f2e61fa61c70457a7d2fdbaec78eda6584fc53/ess.ksy#L622-L683
        value: >
          ((change_type == e_change_form_type::cell) ?
            (
              ((change_flags & (1 << 30) == 0) ?
                0 :
                ((change_flags & (1 << 29) != 0) ?
                  1 :
                  ((change_flags & (1 << 28) != 0) ?
                    2 :
                    ((change_flags & (1 << 30) != 0) ?
                      3 :
                      0
                    )
                  )
                )
              )
            ) :
            ((change_type == e_change_form_type::refr or
              change_type == e_change_form_type::achr or
              change_type == e_change_form_type::pmis or
              change_type == e_change_form_type::pgre or
              change_type == e_change_form_type::pbea or
              change_type == e_change_form_type::pfla or
              change_type == e_change_form_type::phzd or
              change_type == e_change_form_type::pbar or
              change_type == e_change_form_type::pcon or
              change_type == e_change_form_type::parw) ?
              (
                ((form_id.byte0 == 0xFF) ?
                  5 :
                  (((change_flags & (1 << 25) != 0) or (change_flags & (1 << 3) != 0)) ?
                    6 :
                    (((change_flags & (1 << 2) != 0) or (change_flags & (1 << 1) != 0)) ?
                      4 :
                      0
                    )
                  )
                )
              ) :
              0
            )
          )
enums:
  e_misc_stat:
    0: general
    1: quest
    2: combat
    3: magic
    4: crafting
    5: crime
    6: dlc
  e_crime_type:
    0: theft
    1: pickpocketing
    2: trespassing
    3: assault
    4: murder
    6: lycanthropy
  e_change_form_type:
    0: refr
    1: achr
    2: pmis
    3: pgre
    4: pbea
    5: pfla
    6: cell
    7: info
    8: qust
    9: npc_
    10: acti
    11: tact
    12: armo
    13: book
    14: cont
    15: door
    16: ingr
    17: ligh
    18: misc
    19: appa
    20: stat
    21: mstt
    22: furn
    23: weap
    24: ammo
    25: keym
    26: alch
    27: idlm
    28: note
    29: eczn
    30: clas
    31: fact
    32: pack
    33: navm
    34: woop
    35: mgef
    36: smqn
    37: scen
    38: lctn
    39: rela
    40: phzd
    41: pbar
    42: pcon
    43: flst
    44: lvln
    45: lvli
    46: lvsp
    47: parw
    48: ench
