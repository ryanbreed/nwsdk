require 'spec_helper'

describe Nwsdk::Packets do
  include_context "packets"

  context "when initializing" do
    describe "#initialize" do
      let(:empty) { empty_packets }
      let(:with_kwargs) {
        Nwsdk::Packets.new(group: 10000, file_prefix: 'spec_pcap')
      }
      it 'initializes default values' do
        expect(empty.group).to eq(1000)
        expect(empty.file_prefix).to eq('pcap')
      end
      it 'initializes with keyword args' do
        expect(with_kwargs.group).to eq(10000)
        expect(with_kwargs.file_prefix).to eq('spec_pcap')
      end
      it_behaves_like "configured with endpoint and condition"
    end
  end
  context 'when building REST requests' do
    describe "#build_request" do
      let(:req) { configured_packets.build_request( sessions=[1,2,3,4,5]) }
      it 'sets the endpoint to sdk/packets' do
        expect(req.url).to eq("https://broker.local:50103/sdk/packets")
      end
      it 'sets the payload to the list of sessionids' do
        expect(req.payload.to_s).to eq("sessions=1%2C2%2C3%2C4%2C5")
      end
    end
  end
end
