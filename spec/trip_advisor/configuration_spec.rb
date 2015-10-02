require 'spec_helper'

describe TripAdvisor::Configuration do
  describe '.configure' do
    let(:ta_key) {'secure kay'}

    it 'set the key' do
      TripAdvisor.configure do |config|
        config.key = ta_key
      end
      expect(TripAdvisor.key).to eq ta_key
    end
  end
end
