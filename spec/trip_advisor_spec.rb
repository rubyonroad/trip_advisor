require 'spec_helper'

describe TripAdvisor do
  it 'has a version number' do
    expect(TripAdvisor::VERSION).not_to be nil
  end

  before do
    TripAdvisor.configure {|config| config.key = ENV['TRIPADVISOR_KEY']}
  end

  describe '.hotel' do
    let(:coordinates) {'8.3077,77.082708'}
    let(:hotel_name) {'Poovar Island Resort'}

    let(:response_data) {%Q{
      {
        "data": [
          {
            "location_id": "319634",
            "name": "Poovar Island Resort",
            "distance": "0.014823635240490718",
            "bearing": "west",
            "address_obj": {
              "street1": "K.P. VII  / 911 Pozhiyoor",
              "street2": "",
              "city": "Puvar",
              "state": "Kerala",
              "country": "India",
              "postalcode": "695 513",
              "address_string": "K.P. VII  / 911 Pozhiyoor, Puvar 695 513 India"
            }
          }
        ]
      }
    } }

    it 'return hotel object' do
      RestClient.stub(:get){response_data}
      expect(TripAdvisor.hotel(coordinates, hotel_name).class).to eq TripAdvisor::Hotel
    end
  end
end
