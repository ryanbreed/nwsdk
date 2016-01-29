require 'spec_helper'
require 'spec_variants'
describe Nwsdk::Helpers do
  include_context 'conditions'
  include_context "endpoints"
  include_context 'variants'

  include Nwsdk::Helpers
  describe "#decode_value" do
    it 'parses signed int8s' do
      expect(decode_value(variant_int8)).to eq(-100)
    end
    it 'parses sighned int16s' do
      expect(decode_value(variant_int16)).to eq(-10000)
    end
    it 'parses signed int32s' do
      expect(decode_value(variant_int32)).to eq(-100000)
    end
    it 'parses signed int64s' do
      expect(decode_value(variant_int64)).to eq(-1152921504606846976)
    end
    it 'parses unsigned int8s' do
      expect(decode_value(variant_uint8)).to eq(100)
    end
    it 'parses unsigned int16s' do
      expect(decode_value(variant_uint16)).to eq(10000)
    end
    it 'parses unsigned int32s' do
      expect(decode_value(variant_uint32)).to eq(100000)
    end
    it 'parses unsigned int64s' do
      expect(decode_value(variant_uint64)).to eq(1152921504606846976)
    end
    it 'parses unsigned int128s' do
      expect(decode_value(variant_uint128)).to eq(1329227995784915872903807060280344576)
    end
    it 'parses float32s' do
      expect(decode_value(variant_float32)).to eq(100000.5)
    end
    it 'parses float64s' do
      expect(decode_value(variant_float64)).to eq(1152921504606846976.5)
    end
    it 'parses times' do
      expect(decode_value(variant_time)).to eq(Time.at(1440889152).utc)
      #- Time.at(1440889152).gmtoff)
    end
    it 'parses IPv4 Addresses' do
      expect(decode_value(variant_ipv4)).to eq(IPAddr.new('192.168.1.1'))
    end
    it 'parses IPv6 Addresses' do
      expect(decode_value(variant_ipv6)).to eq(IPAddr.new('3ffe:505:2::1'))
    end
    it 'returns day of week' do
      expect(decode_value(variant_dow)).to eq('Monday')
    end
    it 'returns strings for everything else' do
      expect(decode_value(variant_text)).to eq('wibble')
      expect(decode_value(variant_mac)).to eq('00:11:22:33:44:55')
    end

  end

  describe '#format_timestamp' do
    it 'formats according to the preferred format string' do
      expect(format_timestamp(start_utc)).to eq('2015-Aug-24 00:00:00')
    end
  end

  describe '#response_successful' do
    # it 'returns true for json/200 results'
    # it 'returns false if the response code is not 200'
    # it 'returns false if the response content-type is not json'
  end

  describe '#get_sessionids' do
    # it 'returns a list of sessionids for a rest requests predicate condition'
  end

  describe '#get_boundary' do
    it 'parses the multipart boundary string' do
      headers=JSON.parse(File.read('spec/fixtures/multipart.headers.json'))
      bound=get_boundary(headers['content_type'])
      expect(bound).to eq('__Ywtap7ZZk8aLN7vyHFuLeGfe3OHjQUgzQaXDg6oQDMnaUgYlwQ6ahmCm9U')
    end
  end

  describe '#count_results' do
    let(:result) {JSON.parse(File.read('spec/fixtures/count_times.json'))}
    it 'returns a hash of keys and totals' do
      #off = Time.new.gmtoff
      expect(count_results(result)).to eq({
        Time.at(1440831600).utc => 135,
        Time.at(1440799200).utc => 106,
        Time.at(1440790200).utc => 87
      })
    end

  end

  describe '#each_multipart_response_entity' do
    let(:data) {File.read('spec/fixtures/multipart.body')}
    let(:boundary) {'__Ywtap7ZZk8aLN7vyHFuLeGfe3OHjQUgzQaXDg6oQDMnaUgYlwQ6ahmCm9U'}
    # it 'yields entity data from a multipart response' do
    #   expect {|b| each_multipart_response_entity(data,boundary,&b) }.to yield_control
    # end
  end
end
