require 'minitest/autorun'
require '../lib/guzzler.rb'

class GuzzlerTest < MiniTest::Test

  def test_new_guzzler_vehicle_only_works_if_code_valid
    exception = assert_raises(ArgumentError) { Guzzler::Vehicle.new('sdfsd')}
    assert_equal( "Vehicle code is not a valid vehicle", exception.message )
  end

  def test_years_returns_years_array
    years_array = (1984..(Time.new.year + 1)).map(&:to_s).reverse
    assert_equal years_array, Guzzler::Vehicle.years
  end

  def test_makes_returns_makes_array
    year = Guzzler::Vehicle.years.sample
    refute_empty(Guzzler::Vehicle.makes(year))
  end

  def test_models_returns_models_array
    year = Guzzler::Vehicle.years.sample
    make = Guzzler::Vehicle.makes(year).sample

    refute_empty(Guzzler::Vehicle.models(year, make))
  end

  def test_vehicle_options_returns_vehicle_options_array
    year = Guzzler::Vehicle.years.sample
    make = Guzzler::Vehicle.makes(year).sample
    model = Guzzler::Vehicle.models(year, make).sample

    refute_empty(Guzzler::Vehicle.vehicle_options(year, make, model))
  end

  def test_fetch_vehicle_returns_vehicle_data
    vehicle = Guzzler::Vehicle.fetch_vehicle(34429)
    assert(vehicle.key?('vehicle'))
  end

  def test_verify_vehicle_code
    assert(Guzzler::Vehicle.verify_vehicle_code(34429))
    assert(Guzzler::Vehicle.verify_vehicle_code('34428'))
    refute(Guzzler::Vehicle.verify_vehicle_code('sdsdffds'))
  end

  def test_fuel_eco_with_no_args
    #Default arguments will be set (driving_type: 'combo', unit: 'mpg', round: true)
    vehicle = Guzzler::Vehicle.new(34409)
    assert_equal("19.0", vehicle.fuel_eco)
  end

  def test_fuel_eco_with_one_arg
    fuel_eco = Guzzler::Vehicle.new(34409).fuel_eco(unit: 'kpg')
    assert_equal("30.6", fuel_eco)
  end

  def test_fuel_eco_with_two_args
    fuel_eco = Guzzler::Vehicle.new(34410).fuel_eco(driving_type: 'city', unit: 'mpg')
    assert_equal("16.0", fuel_eco)
  end
end
