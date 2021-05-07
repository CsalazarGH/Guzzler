require 'uri'
require 'net/http'
require 'openssl'
require 'json'
require 'crack'
require 'resolv-replace'

class FuelEcoAPI
  def self.years
    url = URI('https://www.fueleconomy.gov/ws/rest/vehicle/menu/year')
    data_response = http_response(url)

    #[{"text"=>"2022", "value"=>"2022"}] -> ["2022"]
    year_make_model_options_values(data_response)
  end

  def self.makes(year)
    url = URI("https://www.fueleconomy.gov/ws/rest/vehicle/menu/make?year=#{year}")
    data_response = http_response(url)

    # [{"text"=>"Acura", "value"=>"Acura"}] -> ["Acura"]
    year_make_model_options_values(data_response)
  end

  def self.models(year, make)
    url = URI("https://www.fueleconomy.gov/ws/rest/vehicle/menu/model?year=#{year}&make=#{make}")
    data_response = http_response(url)

    # [{"text"=>"Avalon", "value"=>"Avalon"}] -> ["Avalon"]
    year_make_model_options_values(data_response)
  end

  def self.vehicle_options(year, make, model)
    url = URI("https://www.fueleconomy.gov/ws/rest/vehicle/menu/options?year=#{year}&make=#{make}&model=#{model}")
    data_response = http_response(url)

    data_response['menuItems']['menuItem']
  end

  def self.fetch_vehicle(vehicle_code)
    url = URI("https://www.fueleconomy.gov/ws/rest/vehicle/#{vehicle_code}")
    data_response = http_response(url)
  end

  def self.verify_vehicle_code(vehicle_code)
    fetch_vehicle(vehicle_code).has_key?('vehicle')
  end

  def self.fetch_fuel_economy(vehicle_code, driving_type)
    driving_type_converter = {'city' => 'city08U', 'highway' => 'highway08', 'combo' => 'comb08' }
    driving_type = driving_type_converter[driving_type]

    data_response = fetch_vehicle(vehicle_code)

    data_response['vehicle'][driving_type]
  end

  private

  def self.http_response(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    @response = http.request(request)
    Crack::XML.parse(@response.read_body)
  end

  def self.year_make_model_options_values(hash)
    if hash['menuItems']['menuItem'].is_a?(Array)
      hash['menuItems']['menuItem'].map {|hash| hash['value']}
    else
      [hash['menuItems']['menuItem']['value']]
    end
  end
end