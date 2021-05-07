require_relative 'guzzler/fuel_eco_api'

module Guzzler

  class Vehicle < FuelEcoAPI
    def initialize(vehicle_code)
      raise ArgumentError.new("Vehicle code is not a valid vehicle") unless vehicle_code_valid?(vehicle_code)
      @vehicle_code = vehicle_code
    end

    def fuel_eco(**args)  
      valid_arg_options_values = { driving_type: ['city', 'highway', 'combo'],
                                  unit: ['mpg', 'kpg'],
                                  round: [true, false] }
                    
      args.each do |key, value| # confirms arg options are valid, and values for options are valid
        unless valid_arg_options_values.keys.include?(key) && valid_arg_options_values[key].include?(value)
          if !valid_arg_options_values.keys.include?(key)
            raise ArgumentError.new("#{key} is not a valid argument option, please select from these: #{valid_arg_options_values.keys.join(', ')}.")
          else
            valid_value_class = valid_arg_options_values[key].map(&:class).uniq
            raise ArgumentError.new("#{value} is not a valid value for #{key}. 
            Please select from #{valid_arg_options_values[key].join(', ')} (#{valid_value_class.join(',')}).")
          end
        end
      end

      driving_type = args[:driving_type] ||= 'combo'
      unit = args[:unit] ||= 'mpg'
      round =  args[:round] == nil ? true : args[:round]
      
      fuel_economy = get_fuel_economy(driving_type).to_f

      if unit.downcase == 'kpg'
        fuel_economy = convert_mpg_to_kpg(fuel_economy) 
      end

      round ? fuel_economy.round(1).to_s : fuel_economy.to_s
    end

    private

    def vehicle_code_valid?(vehicle_code)
      FuelEcoAPI.verify_vehicle_code(vehicle_code)
    end

    def get_fuel_economy(driving_type)
      FuelEcoAPI.fetch_fuel_economy(@vehicle_code , driving_type)
    end

    def convert_mpg_to_kpg(mpg)
      mpg * 1.609
    end
  end

end
