doc: Pairs of failed ingredient combinations in alchemy.
doc-ref: http://en.uesp.net/wiki/Tes5Mod:Save_File_Format/Ingredient_Shared
meta:
  id: ingredient_shared
  license: MIT
  endian: le
  imports:
    - common/ref_id
seq:
  - id: count
    type: u4
  - id: ingredients_combined
    type: ingredient_combination
    repeat: expr
    repeat-expr: count
types:
  ingredient_combination:
    seq:
      - id: ingredient_0
        type: ref_id
      - id: ingredient_1
        type: ref_id
