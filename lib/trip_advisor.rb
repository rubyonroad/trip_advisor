require 'ostruct'
require 'rest-client'

require_relative "trip_advisor/version"
require_relative "trip_advisor/configuration"
require_relative "trip_advisor/hotel"

module TripAdvisor
  extend Configuration
  API_VERSION = '2.0'
  API_URL = "http://api.tripadvisor.com/api/partner/"

  def self.find(coordinates: nil, query: nil, category: nil, field: {})
    result = location_mapper(coordinates, query, category)
    result['data'].find do |element|
      element[field.keys.first.to_s].to_s == field.values.first.to_s
    end
  end

  def self.hotel(name, id)
    result = location_hotels(id)['data'].find{|e| e['name'] == name}
    TripAdvisor::Hotel.new result if result
  end

  def self.location_hotels(id)
    JSON.parse(RestClient.get(location_hotels_path(id)))
  end

  def self.location_mapper(coordinates, query, category=nil)
    JSON.parse(RestClient.get(location_mapper_path(coordinates, query, category)))
  end

  def self.map_hotel(id)
    RestClient.get map_hotels_path(id)
  end

  def self.map_hotels_path(id)
    API_URL + API_VERSION + "/map/#{id.delete(' ')}/hotels?key=#{key}"
  end

  def self.location_mapper_path(id, query, category= 'hotels')
    normalize_url API_URL + API_VERSION + "/location_mapper/#{id.delete(' ')}?key=#{key}-mapper&category=#{category}&q=#{query}"
  end

  def self.location_hotels_path(id)
    normalize_url API_URL + API_VERSION + "/location/#{id.delete(' ')}/hotels?key=#{key}"
  end

  def self.root
    File.expand_path('../..',__FILE__)
  end

  def self.normalize_url(url)
    URI.parse(url).to_s
  end

end
