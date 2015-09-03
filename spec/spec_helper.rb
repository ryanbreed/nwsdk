$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'nwsdk'
require 'simplecov'
SimpleCov.start


shared_context "endpoints" do
  let(:configured_endpoint) {
    Nwsdk::Endpoint.configure('spec/fixtures/spec_config.json')
  }
  let(:unconfigured_endpoint) {
    Nwsdk::Endpoint.new(
      host: "broker.local",
      user: "admin", pass: "netwitness"
    )
  }
end

shared_context "conditions" do
  let(:tz_local)        { "-05:00" } # deep in the heart!
  let(:start_local)     { Time.new(2015,8,24,0,0,0,tz_local) }
  let(:end_local)       { Time.new(2015,8,24,23,59,59,tz_local) }
  let(:service_condition_local)  { Nwsdk::Condition.new(
    start: start_local, end: end_local, where: 'service=80'
  )}

  let(:start_utc)   { Time.utc(2015,8,24,0,0,0) }
  let(:end_utc)     { Time.utc(2015,8,24,23,59,59) }
  let(:service_condition_utc)    { Nwsdk::Condition.new(
    start: start_utc, end: end_utc, where: 'service=80'
  )}

  let(:empty_condition) { Nwsdk::Condition.new(
    start: start_utc, end: end_utc
  ) }
end

shared_context "contents" do
  include_context "endpoints"
  include_context "conditions"
  let(:configured_content) {
    Nwsdk::Content.new(
      endpoint: configured_endpoint,
      condition: service_condition_utc,
      output_dir: '/data/extracts',
      include_types: %w{ exe dll },
      exclude_types: %w{ doc html jpg png gif css }
    )
  }
end

shared_context "packets" do
  include_context "endpoints"
  include_context "conditions"
  let(:empty_packets)  {Nwsdk::Packets.new()}
  let(:configured_packets) {
    Nwsdk::Packets.new(
      endpoint: configured_endpoint,
      condition: service_condition_utc
    )
  }
end

shared_context "queries" do
  include_context "endpoints"
  include_context "conditions"
  let(:configured_query) {
    Nwsdk::Query.new(
      endpoint: configured_endpoint,
      condition: service_condition_utc,
      limit: 100,
      keys: %w{ sessionid ip.src ip.dst }
    )
  }
end

shared_context "values" do
  include_context "endpoints"
  include_context "conditions"
  let(:configured_values) {
    Nwsdk::Values.new(
      endpoint: configured_endpoint,
      condition: service_condition_utc,
      limit: 100,
      flags: %w{ sort-values order-ascending },
      key_name: "ip.src"
    )
  }
end

shared_context "timelines" do
  include_context "endpoints"
  include_context "conditions"
  let(:configured_timeline) {
    Nwsdk::Timeline.new(
      endpoint:  configured_endpoint,
      condition: service_condition_utc,
      flags:     %w{ sessions },
      limit:     100
    )
  }
end

shared_examples "configured with endpoint and condition" do
  include_context "endpoints"
  include_context "conditions"
  let(:configured) {described_class.new(
    endpoint:  configured_endpoint,
    condition: service_condition_utc
  )}
  it 'takes an endpoint parameter' do
    expect(configured.endpoint).to be_a(Nwsdk::Endpoint)
  end
  it 'takes a condition parameter' do
    expect(configured.condition).to be_a(Nwsdk::Condition)
  end
end
