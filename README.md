# Guzzler

A simple ruby gem for accessing fuel economy info from https://fueleconomy.gov/ws

**To install app:**

1. `gem install guzzler`

2. `bundle install`

**Getting Vehicle Options & Vehicle Cod:**

1. Get all years that FuelEconomy.gov API supports:
  `Guzzler::Vehicle.years` (returns an array)
  
2. Get all makes for a specific year:
  `Guzzler::Vehicle.makes(year)`
   
   Example: 
   `Guzzler::Vehicle.makes(2017)
=> ["Acura", "Alfa Romeo", "Aston Martin", "Audi", "Bentley", "BMW", "Buick", "BYD", "Cadillac", "Chevrolet", "Chrysler", "Dodge", "Ferrari", "Fiat", "Ford", "Genesis", "GMC", "Honda", "Hyundai", "Infiniti", "Jaguar", "Jeep", "Kia", "Lamborghini", "Land Rover", "Lexus", "Lincoln", "Lotus", "Maserati", "Mazda", "McLaren Automotive", "Mercedes-Benz", "MINI", "Mitsubishi", "Nissan", "Porsche", "Ram", "Rolls-Royce", "Roush Performance", "smart", "Subaru", "Tesla", "Toyota", "Volkswagen", "Volvo"]`
3. Get all models for a specific year and make: 
  `Guzzler::Vehicle.models(year, make)`
  
    Example: 
    `Guzzler::Vehicle.models(2019, 'toyota') => ["4Runner 2WD", "4Runner 4WD", "86", "Avalon", "Avalon Hybrid", "Avalon Hybrid XLE",....]` (array shortened for         brevity)
  
4. Get all vehicle options (trims) for a specific year, make, model: `Guzzler::Vehicle.new(2000, 'honda', 'civic')`

     Example:
    `Guzzler::Vehicle.vehicle_options(2000, 'honda', 'civic')
     => [{"text"=>"Auto 4-spd, 4 cyl, 1.6 L, SOHC-VTEC", "value"=>"15672"}, {"text"=>"Auto 4-spd, 4 cyl, 1.6 L", "value"=>"15673"}, {"text"=>"Man 5-spd, 4 cyl, 1.6      L", "value"=>"15674"}, {"text"=>"Man 5-spd, 4 cyl, 1.6 L, SOHC-VTEC", "value"=>"15675"}, {"text"=>"Man 5-spd, 4 cyl, 1.6 L, DOHC-VTEC", "value"=>"15676"}]` (value being the vehicles id number).
     
5. Get all vehicle information for specific vehicle : `Guzzler::Vehicle.fetch_vehicle(vehicle_code)` (returns hash object)

6. To manually verify a vehicle code is valid : `Guzzler::Vehicle.verify_vehicle_code(vehicle_code)` (returns boolean value)

**Getting fuel eco Information:**

1. Instantiating a new vehicle:
`Guzzler::Vehicle.new(vehicle_code)`, will not instantiate unless the vehicle code is valid.
2. Getting fuel eco Info:

The method for accessing fuel economy info is `fuel_eco`. `fuel_eco` is an instance method that accepts three different arguments. (Developer can supply any combination or no arguments). 

  - Arguments and their different options:
    1. `driving_type: ['city', 'highway', 'combo']` (default: `'combo'`)
    2. `unit: ['mpg', 'kpg']` (default: `'mpg'`)
    3. `round: [true, false]` (default: `true`)

FuelEconomy.gov supports alternative fuels for accessing fuel eco info for vehciles (E85, race gas, etc). `fuel_eco` currently returns the fuel eco info for the main fuel type for the vehicle. 

Examples :

`Guzzler::Vehicle.new(34429).fuel_eco(driving_type: 'highway', unit: 'kpg') => "48.3"`

`Guzzler::Vehicle.new(34409).fuel_eco(driving_type: 'city', round: false) => "18.1532"`

`Guzzler::Vehicle.new(34409).fuel_eco => "19.0"`
   
