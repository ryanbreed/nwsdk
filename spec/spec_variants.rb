require 'spec_helper'
shared_context 'variants' do
  let(:variant_int8) {
    JSON.parse('
      {
          "id1" : 100,
          "id2" : 108,
          "format" : 1,
          "type" : "nwInt8",
          "flags" : 0,
          "group" : 0,
          "value" : -100
      }
    ')
  }
  let(:variant_int16) {
    JSON.parse('
      {
          "id1" : 100,
          "id2" : 108,
          "format" : 3,
          "type" : "nwInt16",
          "flags" : 0,
          "group" : 0,
          "value" : -10000
      }
    ')
  }
  let(:variant_int32) {
    JSON.parse('
      {
          "id1" : 100,
          "id2" : 108,
          "format" : 5,
          "type" : "nwInt32",
          "flags" : 0,
          "group" : 0,
          "value" : -100000
      }
    ')
  }
  let(:variant_int64) {
    JSON.parse('
      {
          "id1" : 100,
          "id2" : 108,
          "format" : 7,
          "type" : "nwInt64",
          "flags" : 0,
          "group" : 0,
          "value" : -1152921504606846976
      }
    ')
  }
  let(:variant_uint8) {
    JSON.parse('
      {
          "id1" : 100,
          "id2" : 108,
          "format" : 2,
          "type" : "nwUInt8",
          "flags" : 0,
          "group" : 0,
          "value" : 100
      }
    ')
  }
    let(:variant_uint16) {
    JSON.parse('
      {
          "id1" : 100,
          "id2" : 108,
          "format" : 4,
          "type" : "nwUInt16",
          "flags" : 0,
          "group" : 0,
          "value" : 10000
      }
    ')
  }
  let(:variant_uint32) {
    JSON.parse('
      {
          "id1" : 100,
          "id2" : 108,
          "format" : 6,
          "type" : "nwUInt32",
          "flags" : 0,
          "group" : 0,
          "value" : 100000
      }
    ')
  }
  let(:variant_uint64) {
    JSON.parse('
      {
          "id1" : 100,
          "id2" : 108,
          "format" : 8,
          "type" : "nwUInt64",
          "flags" : 0,
          "group" : 0,
          "value" : 1152921504606846976
      }
    ')
  }
  let(:variant_uint128) {
    JSON.parse('
      {
          "id1" : 100,
          "id2" : 108,
          "format" : 9,
          "type" : "nwUInt128",
          "flags" : 0,
          "group" : 0,
          "value" : 1329227995784915872903807060280344576
      }
    ')
  }
  let(:variant_float32) {
    JSON.parse('
      {
          "id1" : 100,
          "id2" : 108,
          "format" : 10,
          "type" : "nwFloat32",
          "flags" : 0,
          "group" : 0,
          "value" : 100000.5
      }
    ')
  }
  let(:variant_float64) {
    JSON.parse('
      {
          "id1" : 100,
          "id2" : 108,
          "format" : 11,
          "type" : "nwFloat64",
          "flags" : 0,
          "group" : 0,
          "value" : 1152921504606846976.5
      }
    ')
  }
  let(:variant_time) {
    JSON.parse('
      {
          "id1" : 100,
          "id2" : 108,
          "format" : 32,
          "type" : "nwTimeT",
          "flags" : 0,
          "group" : 0,
          "value" : 1440889152
      }
    ')
  }
  let(:variant_ipv4) {
    JSON.parse('
      {
          "id1" : 100,
          "id2" : 108,
          "format" : 128,
          "type" : "nwIPv4",
          "flags" : 0,
          "group" : 0,
          "value" : "192.168.1.1"
      }
    ')
  }
  let(:variant_ipv6) {
    JSON.parse('
      {
          "id1" : 100,
          "id2" : 108,
          "format" : 129,
          "type" : "nwIPv6",
          "flags" : 0,
          "group" : 0,
          "value" : "3ffe:505:2::1"
      }
    ')
  }
  let(:variant_text) {
    JSON.parse('
      {
          "id1" : 100,
          "id2" : 108,
          "format" : 65,
          "type" : "nwText",
          "flags" : 0,
          "group" : 0,
          "value" : "wibble"
      }
  ')
}
let(:variant_dow) {
  JSON.parse('
    {
        "id1" : 100,
        "id2" : 108,
        "format" : 33,
        "type" : "nwDayOfWeek",
        "flags" : 0,
        "group" : 0,
        "value" : 1
    }
')
}
let(:variant_mac) {
  JSON.parse('
    {
        "id1" : 100,
        "id2" : 108,
        "format" : 130,
        "type" : "nwMAC",
        "flags" : 0,
        "group" : 0,
        "value" : "00:11:22:33:44:55"
    }
  ')
}
end
