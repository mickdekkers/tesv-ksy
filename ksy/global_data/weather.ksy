doc-ref: "http://en.uesp.net/wiki/Tes5Mod:Save_File_Format/Weather"
meta:
  id: weather
  license: MIT
  endian: le
  imports:
    - common/ref_id
seq:
  - id: climate
    type: ref_id
  - id: weather
    type: ref_id
  - id: prev_weather
    doc: Only during weather transition. In other cases it equals zero.
    type: ref_id
  - id: unk_weather_1
    type: ref_id
  - id: unk_weather_2
    type: ref_id
  - id: regn_weather
    type: ref_id
  - id: cur_time
    doc: Current in-game time in hours
    type: f4
  - id: beg_time
    doc: Time of current weather beginning
    type: f4
  - id: weather_pct
    doc: A value from 0.0 to 1.0 describing how far in the current weather has transitioned
    type: f4
  # Skip unknown data
  - size: 4 * 8
  - id: flags
    type: u1
