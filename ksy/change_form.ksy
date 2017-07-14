doc-ref: http://en.uesp.net/wiki/Tes5Mod:Save_File_Format#Change_Form
meta:
  id: change_form
  license: MIT
  endian: le
  imports:
    - common/ref_id
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
types:
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
        doc-ref: http://en.uesp.net/wiki/Tes5Mod:ChangeFlags#Initial_type
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
