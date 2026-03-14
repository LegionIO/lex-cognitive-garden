# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveGarden
      module Helpers
        class Plot
          attr_reader :id, :soil_type, :plant_ids, :created_at
          attr_accessor :fertility, :sunlight

          def initialize(soil_type: :loamy, fertility: nil, sunlight: nil)
            validate_soil!(soil_type)
            @id        = SecureRandom.uuid
            @soil_type = soil_type.to_sym
            @fertility = (fertility || soil_fertility).to_f.clamp(0.0, 1.0).round(10)
            @sunlight  = (sunlight || 0.6).to_f.clamp(0.0, 1.0).round(10)
            @plant_ids = []
            @created_at = Time.now.utc
          end

          def sow(plant_id)
            return :already_planted if @plant_ids.include?(plant_id)

            @plant_ids << plant_id
            :sown
          end

          def uproot(plant_id)
            return :not_found unless @plant_ids.include?(plant_id)

            @plant_ids.delete(plant_id)
            :uprooted
          end

          def fertilize!(amount: 0.1)
            @fertility = (@fertility + amount.abs).clamp(0.0, 1.0).round(10)
          end

          def deplete!(amount: 0.05)
            @fertility = (@fertility - amount.abs).clamp(0.0, 1.0).round(10)
          end

          def paradise?
            @fertility >= 0.8
          end

          def barren?
            @fertility < 0.2
          end

          def plant_count
            @plant_ids.size
          end

          def fertility_label
            Constants.label_for(Constants::FERTILITY_LABELS, @fertility)
          end

          def to_h
            {
              id:              @id,
              soil_type:       @soil_type,
              fertility:       @fertility,
              sunlight:        @sunlight,
              fertility_label: fertility_label,
              plant_count:     plant_count,
              paradise:        paradise?,
              barren:          barren?,
              created_at:      @created_at
            }
          end

          private

          def validate_soil!(val)
            return if Constants::SOIL_TYPES.include?(val.to_sym)

            raise ArgumentError,
                  "unknown soil type: #{val.inspect}; " \
                  "must be one of #{Constants::SOIL_TYPES.inspect}"
          end

          def soil_fertility
            { fertile: 0.9, loamy: 0.7, sandy: 0.4, clay: 0.5, rocky: 0.2 }
              .fetch(@soil_type, 0.5)
          end
        end
      end
    end
  end
end
