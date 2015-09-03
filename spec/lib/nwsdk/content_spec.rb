require 'spec_helper'
describe Nwsdk::Content do
  include_context "contents"

  context 'when initializing' do
    let(:empty_content) {Nwsdk::Content.new}
    describe '#initialize' do
      it 'initializes with default parameters' do
        expect(empty_content).to be_a(Nwsdk::Content)
        expect(empty_content.output_dir).to eq('tmp')
        expect(empty_content.exclude_types).to be_empty
        expect(empty_content.include_types).to be_empty
      end
      it 'initializes with keyword arguments' do
        expect(configured_content.output_dir).to eq('/data/extracts')
        expect(configured_content.include_types).to eq(["exe","dll"])
        expect(configured_content.exclude_types).to eq(
          ["doc","html","jpg","png","gif","css"]
        )
      end

      it_behaves_like "configured with endpoint and condition"
    end
  end
  context 'when making REST requests' do

    describe '#build_params' do
      it 'builds a plain parameter list with no inclusions/exclusions' do
        expect(configured_content.build_params(100)).to eq({
            session: 100,
            maxSize: 0,
            render:  107,
            excludeFileTypes: "doc;html;jpg;png;gif;css",
            includeFileTypes: "exe;dll"
        })
      end
      it 'adds exclusions only if set' do
        cont=Nwsdk::Content.new(
          endpoint:  configured_endpoint,
          condition: service_condition_utc,
          exclude_types: %w{ html htm gif jpg}
        )
        expect(cont.build_params(100)).to eq({
          :session => 100,
          :maxSize => 0,
          :render  => 107,
          :excludeFileTypes=>"html;htm;gif;jpg"
        })
      end

      it 'adds inclusions only if set' do
        cont=Nwsdk::Content.new(
          endpoint:  configured_endpoint,
          condition: service_condition_utc,
          include_types: %w{ exe dll }
        )
        expect(cont.build_params(100)).to eq({
          :session => 100,
          :maxSize => 0,
          :render  => 107,
          :includeFileTypes => "exe;dll"
        })
      end
    end

    describe '#build_request' do
      it 'sets parameters in the request payload' do
        req = configured_content.build_request(101)
        rendered=req.payload.to_s
        expect(rendered).to eq(
          "session=101&maxSize=0&render=107&includeFileTypes=exe%3Bdll&" +
          "excludeFileTypes=doc%3Bhtml%3Bjpg%3Bpng%3Bgif%3Bcss"
        )
      end
    end

    describe '#each_session_file' do
      it 'yields multiple files from a single response'
      it 'yields no files from an empty response'
      it 'yields no files from unsuccessful requests'
    end
    
  end
end
