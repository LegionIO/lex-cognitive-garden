# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveGarden
      module Runners
        module CognitiveGarden
          extend self

          def plant_seed(plant_type:, domain:, content:,
                         health: nil, water_level: nil, engine: nil, **)
            eng = resolve_engine(engine)
            p   = eng.plant_seed(plant_type: plant_type, domain: domain, content: content,
                                 health: health, water_level: water_level)
            { success: true, plant: p.to_h }
          rescue ArgumentError => e
            { success: false, error: e.message }
          end

          def create_plot(soil_type: :loamy, fertility: nil, sunlight: nil, engine: nil, **)
            eng  = resolve_engine(engine)
            plot = eng.create_plot(soil_type: soil_type, fertility: fertility, sunlight: sunlight)
            { success: true, plot: plot.to_h }
          rescue ArgumentError => e
            { success: false, error: e.message }
          end

          def grow(plant_id:, rate: nil, engine: nil, **)
            eng = resolve_engine(engine)
            p   = eng.grow_plant(plant_id: plant_id, rate: rate || Helpers::Constants::GROWTH_RATE)
            { success: true, plant: p.to_h }
          rescue ArgumentError => e
            { success: false, error: e.message }
          end

          def water(plant_id:, amount: nil, engine: nil, **)
            eng = resolve_engine(engine)
            p   = eng.water_plant(plant_id: plant_id, amount: amount || 0.2)
            { success: true, plant: p.to_h }
          rescue ArgumentError => e
            { success: false, error: e.message }
          end

          def list_plants(engine: nil, plant_type: nil, **)
            eng     = resolve_engine(engine)
            results = eng.all_plants
            results = results.select { |p| p.plant_type == plant_type.to_sym } if plant_type
            { success: true, plants: results.map(&:to_h), count: results.size }
          end

          def garden_status(engine: nil, **)
            eng = resolve_engine(engine)
            { success: true, report: eng.garden_report }
          end

          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)

          private

          def resolve_engine(engine)
            engine || default_engine
          end

          def default_engine
            @default_engine ||= Helpers::GardenEngine.new
          end
        end
      end
    end
  end
end
