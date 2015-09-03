require 'spec_helper'

describe Nwsdk::Query do
  include_context "queries"
  let( :empty_query )   { Nwsdk::Query.new }

  context "when initializing" do
    describe "#initialize" do

      it "initializes with empty arguments" do
        expect(empty_query).to be_a(Nwsdk::Query)
        expect(empty_query.limit).to eq(10000)
        expect(empty_query.keys).to eq(["*"])
      end

      it 'initializes with keyword args' do
        expect(configured_query.limit).to eq(100)
        expect(configured_query.keys).to eq(['sessionid', 'ip.src', 'ip.dst'])
      end

      it_behaves_like "configured with endpoint and condition"
    end
  end

  context 'when performing REST requests' do
    describe "#format_select" do
      it 'formats the select and where clauses' do
        rendered_select=configured_query.format_select
        expect(rendered_select).to eq(
          "select sessionid,ip.src,ip.dst where (service=80)" +
          "&&time='2015-Aug-24 00:00:00'-'2015-Aug-24 23:59:59'"
        )
      end
    end

    describe "#width" do
      it 'is the number of keys' do
        expect(configured_query.width).to eq(3)
      end
      it 'is 100 if the only key is *' do
        expect(empty_query.width).to eq(100)
      end
    end

    describe "#build_request" do
      let(:req) { configured_query.build_request }
      it 'sets the request payload' do
        rendered_payload=req.payload.to_s
        expect(rendered_payload).to eq(
         "msg=query&query=select%20sessionid%2Cip.src%2Cip.dst%20" +
           "where%20(service%3D80)%26%26" +
           "time%3D'2015-Aug-24%2000%3A00%3A00'" +
           "-'2015-Aug-24%2023%3A59%3A59'&size=300"
        )
      end
    end
  end
end
