require 'spec_helper'

describe Nwsdk::Endpoint do
  include_context "endpoints"

  context "when initializing" do
    describe ".initialize" do
      it 'assumes enpoint type is broker' do
        expect(unconfigured_endpoint.port).to eq(50103)
      end
      it 'initializes from keyword args' do
        sdk=Nwsdk::Endpoint.new(
          host: "broker.local", port: 50103,
          user: "admin", pass: "netwitness"
        )
        expect(sdk).to be_a(Nwsdk::Endpoint)
        expect(sdk.host).to eq("broker.local")
        expect(sdk.port).to eq(50103)
        expect(sdk.user).to eq('admin')
        expect(sdk.pass).to eq('netwitness')
      end
      
      it 'can use a type arg instead of port' do
        sdk=Nwsdk::Endpoint.new(
          host: "broker.local", type: :broker,
          user: "admin", pass: "netwitness"
        )
        expect(sdk).to be_a(Nwsdk::Endpoint)
        expect(sdk.port).to eq(50103)
      end
    end

    describe ".configure" do
      let(:sdk) {Nwsdk::Endpoint.configure('spec/fixtures/spec_config.json')}
      it "configures the endpoint from a json config" do
        expect(sdk).to be_a(Nwsdk::Endpoint)
      end
    end

    describe '#uri' do
      it 'returns the full url for the default endpoint' do
        expect(configured_endpoint.uri).to eq("https://broker.local:50103/sdk")
      end
      it 'returns the full url for the packet endpoint' do
        rendered_uri=configured_endpoint.uri('sdk/packets')
        expect(rendered_uri).to eq("https://broker.local:50103/sdk/packets")
      end
      it 'returns the full url for the content endpoint' do
        rendered_uri=configured_endpoint.uri('sdk/content')
        expect(rendered_uri).to eq("https://broker.local:50103/sdk/content")
      end
    end

    describe '#get_req' do
      let(:req) {configured_endpoint.get_request }
      it 'returns a RestClient::Request' do
        expect(req).to be_a(RestClient::Request)
      end
      it 'sets the request Accept-Encoding to avoid a gzip bug in RestClient' do
        expect(req.headers["Accept-Encoding"]).to eq(:deflate)
      end
      it 'sets the accept header to application/json' do
        expect(req.headers[:accept]).to eq(:json)
      end
      it 'sets the read_timeout to nil' do
        expect(req.timeout).to be_nil
      end
      it 'sets verify_ssl to VERIFY_NONE' do
        expect(req.verify_ssl).to eq(OpenSSL::SSL::VERIFY_NONE)
      end
      it 'sets empty request parameters by default' do
        expect(req.payload.to_s).to eq("")
      end
      it 'sets empty request parameters by default' do
        req_with_params=configured_endpoint.get_request(params: {msg: 'query'})
        expect(req_with_params.payload.to_s).to eq('msg=query')
      end

    end
  end
end
