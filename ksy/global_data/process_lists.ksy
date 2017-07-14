doc-ref: "http://en.uesp.net/wiki/Tes5Mod:Save_File_Format/Process_Lists"
meta:
  id: process_lists
  license: MIT
  endian: le
  imports:
    - common/vsval
    - common/ref_id
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
types:
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
enums:
  e_crime_type:
    0: theft
    1: pickpocketing
    2: trespassing
    3: assault
    4: murder
    6: lycanthropy
