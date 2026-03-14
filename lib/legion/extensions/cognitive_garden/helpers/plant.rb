# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveGarden
      module Helpers
        class Plant
          attr_reader :id, :plant_type, :domain, :content,
                      :stage, :planted_at
          attr_accessor :health, :water_level

          STAGE_THRESHOLDS = { seed: 0.0, sprout: 0.2, sapling: 0.4,
                               mature: 0.7, ancient: 0.9 }.freeze

          def initialize(plant_type:, domain:, content:,
                         health: nil, water_level: nil)
            validate_plant_type!(plant_type)
            @id          = SecureRandom.uuid
            @plant_type  = plant_type.to_sym
            @domain      = domain.to_sym
            @content     = content.to_s
            @health      = (health || 0.5).to_f.clamp(0.0, 1.0).round(10)
            @water_level = (water_level || 0.5).to_f.clamp(0.0, 1.0).round(10)
            @stage       = resolve_stage
            @planted_at  = Time.now.utc
          end

          def grow!(rate: Constants::GROWTH_RATE)
            boost = @water_level > 0.3 ? rate.abs : rate.abs * 0.3
            @health = (@health + boost).clamp(0.0, 1.0).round(10)
            @water_level = (@water_level - Constants::WATER_DECAY).clamp(0.0, 1.0).round(10)
            @stage = resolve_stage
          end

          def water!(amount: 0.2)
            @water_level = (@water_level + amount.abs).clamp(0.0, 1.0).round(10)
          end

          def wilt!(rate: Constants::WILT_RATE)
            @health = (@health - rate.abs).clamp(0.0, 1.0).round(10)
            @stage = resolve_stage
          end

          def prune!(amount: 0.1)
            @health = (@health - amount.abs).clamp(0.0, 1.0).round(10)
            @health = (@health + (amount.abs * 0.5)).clamp(0.0, 1.0).round(10)
            @stage = resolve_stage
          end

          def pollinate!(bonus: Constants::POLLINATION_BONUS)
            @health = (@health + bonus).clamp(0.0, 1.0).round(10)
            @stage = resolve_stage
          end

          def flourishing?
            @health >= 0.8
          end

          def withered?
            @health < 0.2
          end

          def thirsty?
            @water_level < 0.2
          end

          def mature?
            %i[mature ancient].include?(@stage)
          end

          def health_label
            Constants.label_for(Constants::HEALTH_LABELS, @health)
          end

          def to_h
            {
              id:           @id,
              plant_type:   @plant_type,
              domain:       @domain,
              content:      @content,
              health:       @health,
              water_level:  @water_level,
              stage:        @stage,
              health_label: health_label,
              flourishing:  flourishing?,
              withered:     withered?,
              thirsty:      thirsty?,
              planted_at:   @planted_at
            }
          end

          private

          def validate_plant_type!(val)
            return if Constants::PLANT_TYPES.include?(val.to_sym)

            raise ArgumentError,
                  "unknown plant type: #{val.inspect}; " \
                  "must be one of #{Constants::PLANT_TYPES.inspect}"
          end

          def resolve_stage
            STAGE_THRESHOLDS.to_a.reverse.each do |stage, threshold|
              return stage if @health >= threshold
            end
            :seed
          end
        end
      end
    end
  end
end
