meta:
  id: vsval
  title: Variable-sized value
  license: MIT
  endian: le
# Thanks to @koczkatamas
seq:
  - id: byte1
    type: u1
  - id: byte2
    type: u1
    if: (byte1 & 0b11) >= 1
  - id: byte34
    type: u2
    if: (byte1 & 0b11) >= 2
instances:
  value:
    value: >
      (byte1 >> 2) |
      (((byte1 & 0b11) >= 1) ? (byte2 << 6) : 0) |
      (((byte1 & 0b11) >= 2) ? (byte34 << 14) : 0)
