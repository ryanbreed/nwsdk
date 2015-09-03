require 'spec_helper'
describe Nwsdk::Values do
  include_context "values"
  context 'when initializing' do
    let(:empty_values) { Nwsdk::Values.new }
    describe "#initialize" do
      it 'initializes with parameter defaults' do
        expect(empty_values).to be_a(Nwsdk::Values)
        expect(empty_values.limit).to eq(10000)
        expect(empty_values.key_name).to eq('service')
        expect(empty_values.flags).to eq(
          ["sort-total","sessions","order-descending"]
        )
      end

      it 'initializes with keyword args' do
        expect(configured_values).to be_a(Nwsdk::Values)
        expect(configured_values.limit).to eq(100)
        expect(configured_values.key_name).to eq('ip.src')
        expect(configured_values.flags).to eq(
          ["sort-values","order-ascending"]
        )
      end

      it_behaves_like "configured with endpoint and condition"
    end
  end
  context 'when making REST requests' do
    describe '#build_request' do

      let( :req ) { configured_values.build_request }

      it 'sets the request payload' do
        rendered=req.payload.to_s
        expect(rendered).to eq(
          "msg=values&where=(service%3D80)&time1=2015-Aug-24%2000%3A00%3A00&" +
          "time2=2015-Aug-24%2023%3A59%3A59&size=100&" +
          "flags=sort-values%2Corder-ascending&fieldName=ip.src"
        )
      end
    end
  end
end
