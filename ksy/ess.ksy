doc-ref: http://en.uesp.net/wiki/Tes5Mod:Save_File_Format
meta:
  id: tesv_savegame
  title: "Skyrim Save Format"
  application: "The Elder Scrolls V: Skyrim"
  file-extension: ess
  license: MIT
  endian: le
  encoding: "windows-1252"
  imports:
    - header
    - file_location_table
    - form_id_array
    - plugin_info
    - global_data/record
    - change_form
seq:
  - id: magic
    doc: This is always "TESV_SAVEGAME"
    contents: [0x54, 0x45, 0x53, 0x56, 0x5F, 0x53, 0x41, 0x56, 0x45, 0x47, 0x41, 0x4D, 0x45]
  - id: header_size
    type: u4
  - id: header
    type: header
  - id: screenshot_data
    size: 3 * header.shot_width * header.shot_height
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
