doc-ref: "http://en.uesp.net/wiki/Tes5Mod:Save_File_Format/Created_Objects"
meta:
  id: created_objects
  license: MIT
  endian: le
  imports:
    - common/vsval
    - common/ref_id
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
types:
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
