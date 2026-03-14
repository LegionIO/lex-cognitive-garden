# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveGarden
      module Helpers
        class GardenEngine
          def initialize
            @plants = {}
            @plots  = {}
          end

          def plant_seed(plant_type:, domain:, content:, health: nil, water_level: nil)
            raise ArgumentError, 'plant limit reached' if @plants.size >= Constants::MAX_PLANTS

            p = Plant.new(plant_type: plant_type, domain: domain, content: content,
                          health: health, water_level: water_level)
            @plants[p.id] = p
            p
          end

          def create_plot(soil_type: :loamy, fertility: nil, sunlight: nil)
            raise ArgumentError, 'plot limit reached' if @plots.size >= Constants::MAX_PLOTS

            plot = Plot.new(soil_type: soil_type, fertility: fertility, sunlight: sunlight)
            @plots[plot.id] = plot
            plot
          end

          def sow(plant_id:, plot_id:)
            fetch_plant(plant_id)
            plot = fetch_plot(plot_id)
            plot.sow(plant_id)
          end

          def grow_plant(plant_id:, rate: Constants::GROWTH_RATE)
            plant = fetch_plant(plant_id)
            plant.grow!(rate: rate)
            plant
          end

          def water_plant(plant_id:, amount: 0.2)
            plant = fetch_plant(plant_id)
            plant.water!(amount: amount)
            plant
          end

          def wilt_all!
            @plants.each_value(&:wilt!)
          end

          def grow_all!
            @plants.each_value(&:grow!)
          end

          def pollinate(plant_a_id:, plant_b_id:)
            a = fetch_plant(plant_a_id)
            b = fetch_plant(plant_b_id)
            a.pollinate!
            b.pollinate!
            { plant_a: a, plant_b: b }
          end

          def plants_by_type
            counts = Constants::PLANT_TYPES.to_h { |t| [t, 0] }
            @plants.each_value { |p| counts[p.plant_type] += 1 }
            counts
          end

          def healthiest(limit: 5)
            @plants.values.sort_by { |p| -p.health }.first(limit)
          end

          def sickest(limit: 5)
            @plants.values.sort_by(&:health).first(limit)
          end

          def flourishing_plants
            @plants.values.select(&:flourishing?)
          end

          def withered_plants
            @plants.values.select(&:withered?)
          end

          def thirsty_plants
            @plants.values.select(&:thirsty?)
          end

          def mature_plants
            @plants.values.select(&:mature?)
          end

          def avg_health
            return 0.0 if @plants.empty?

            (@plants.values.sum(&:health) / @plants.size).round(10)
          end

          def garden_report
            {
              total_plants: @plants.size,
              total_plots:  @plots.size,
              by_type:      plants_by_type,
              flourishing:  flourishing_plants.size,
              withered:     withered_plants.size,
              thirsty:      thirsty_plants.size,
              mature:       mature_plants.size,
              avg_health:   avg_health
            }
          end

          def all_plants
            @plants.values
          end

          def all_plots
            @plots.values
          end

          private

          def fetch_plant(id)
            @plants.fetch(id) { raise ArgumentError, "plant not found: #{id}" }
          end

          def fetch_plot(id)
            @plots.fetch(id) { raise ArgumentError, "plot not found: #{id}" }
          end
        end
      end
    end
  end
end
