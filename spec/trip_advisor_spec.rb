require 'spec_helper'

describe TripAdvisor do
  it 'has a version number' do
    expect(TripAdvisor::VERSION).not_to be nil
  end

  before do
    TripAdvisor.configure {|config| config.key = ENV['TRIPADVISOR_KEY']}
  end

  describe '.hotel' do
    let(:location_hotels_response) {File.open(File.join TripAdvisor.root, '/spec/support/fixtures/location-hotels.json' ).read}
    let(:location_id) {JSON.parse(location_hotels_response)['data'].first['location_id']}
    let(:hotel_name) {JSON.parse(location_hotels_response)['data'].first['name']}


    describe '.hotel' do
    before do
      stub_request(:get, "http://api.tripadvisor.com/api/partner/2.0/location/325218/hotels?key=").
        with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => location_hotels_response, :headers => {})
    end

      it 'return hotel object' do
        expect(TripAdvisor.hotel(hotel_name, location_id).class).to eq TripAdvisor::Hotel
      end

      it 'return nil if name not found in request' do
        expect(TripAdvisor.hotel('Fake hotel name', location_id)).to be_nil
      end
    end

  end
end
