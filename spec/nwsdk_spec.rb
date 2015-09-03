require 'spec_helper'

describe Nwsdk do
  it 'has a version number' do
    expect(Nwsdk::VERSION).not_to be nil
  end

  it 'has a default config hash' do
    expect(Nwsdk::Constants::DEFAULT_CONFIG).not_to be nil
  end
end
