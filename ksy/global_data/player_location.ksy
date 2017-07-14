doc-ref: "http://en.uesp.net/wiki/Tes5Mod:Save_File_Format/Player_Location"
meta:
  id: player_location
  license: MIT
  endian: le
  imports:
    - common/ref_id
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
