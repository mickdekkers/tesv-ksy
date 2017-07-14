meta:
  id: wstring
  license: MIT
  endian: le
  encoding: "windows-1252"
seq:
  - id: size
    type: u2
  - id: string
    type: str
    size: size
