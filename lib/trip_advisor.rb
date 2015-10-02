require 'ostruct'
require 'rest-client'

require_relative "trip_advisor/version"
require_relative "trip_advisor/configuration"
require_relative "trip_advisor/hotel"

module TripAdvisor
  extend Configuration
  API_VERSION = '2.0'
  API_URL = "http://api.tripadvisor.com/api/partner/"

  def self.hotel *args
     response = ''
    if args.size == 1
      response = RestClient.get map_hotels_path args.first
    elsif args.size == 2
      response = RestClient.get location_mapper_path(args.first, args.last, 'hotels')
    else
      raise 'This method takes either 1 or 2 arguments'
    end
    TripAdvisor::Hotel.new JSON.parse(response)['data'].first
  end

  def self.map_hotels_path(id)
    API_URL + API_VERSION + "/map/#{id.delete(' ')}/hotels?key=#{key}"
  end

  def self.location_mapper_path(id, query, category= 'hotels')
    API_URL + API_VERSION + "/location_mapper/#{id.delete(' ')}?key=#{key}-mapper&category=#{category}&q=#{query}"
  end
end
