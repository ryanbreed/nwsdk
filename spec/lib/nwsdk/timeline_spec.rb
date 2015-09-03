require 'spec_helper'
describe Nwsdk::Timeline do
  include_context "timelines"
  let (:empty_timeline) { Nwsdk::Timeline.new() }

  context 'when initializing' do
    describe "#initialize" do
      it 'initializes with default parameters' do
        expect(empty_timeline).to be_a(Nwsdk::Timeline)
        expect(empty_timeline.flags).to eq(['size'])
        expect(empty_timeline.limit).to eq(10000)
      end

      it 'initializes with keyword arguments' do
        expect(configured_timeline.flags).to eq(['sessions'])
        expect(configured_timeline.limit).to eq(100)
      end

      it_behaves_like "configured with endpoint and condition"
    end
  end

  context 'when making REST requests' do
    describe '#build_request' do
      let (:req) { configured_timeline.build_request }

      it 'sets parameters in request payload' do
        rendered_payload=req.payload.to_s
        expect(rendered_payload).to eq(
          "msg=timeline&time1=2015-Aug-24%2000%3A00%3A00&" +
            "time2=2015-Aug-24%2023%3A59%3A59&size=100&" + 
            "timezone=0&flags=sessions&where=(service%3D80)"
        )
      end

    end
  end
end
