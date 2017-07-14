doc-ref: http://en.uesp.net/wiki/Tes5Mod:Save_File_Format#File_Location_Table
meta:
  id: file_location_table
  license: MIT
  endian: le
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
