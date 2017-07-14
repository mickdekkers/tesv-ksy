doc-ref: http://en.uesp.net/wiki/Tes5Mod:Save_File_Format#Global_Data
meta:
  id: global_data_record
  license: MIT
  endian: le
  imports:
    - global_data/misc_stats
    - global_data/player_location
    - global_data/global_variables
    - global_data/created_objects
    - global_data/weather
    - global_data/audio
    - global_data/process_lists
    - global_data/magic_favorites
    - global_data/ingredient_shared
seq:
  - id: record_type
    type: u4
    enum: e_record_type
  - id: record_length
    type: u4
  - id: record_data
    size: record_length
    type:
      switch-on: record_type
      cases:
        e_record_type::misc_stats: misc_stats
        e_record_type::player_location: player_location
        e_record_type::global_variables: global_variables
        e_record_type::created_objects: created_objects
        e_record_type::weather: weather
        e_record_type::audio: audio
        e_record_type::process_lists: process_lists
        e_record_type::magic_favorites: magic_favorites
        e_record_type::ingredient_shared: ingredient_shared
enums:
  e_record_type:
    0: misc_stats
    1: player_location
    3: global_variables
    4: created_objects
    6: weather
    7: audio
    100: process_lists
    109: magic_favorites
    112: ingredient_shared
