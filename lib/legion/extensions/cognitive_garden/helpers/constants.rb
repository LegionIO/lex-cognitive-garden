# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveGarden
      module Helpers
        module Constants
          PLANT_TYPES = %i[idea hypothesis theory skill habit].freeze

          GROWTH_STAGES = %i[seed sprout sapling mature ancient].freeze

          SOIL_TYPES = %i[fertile loamy sandy clay rocky].freeze

          MAX_PLANTS  = 500
          MAX_PLOTS   = 50
          GROWTH_RATE = 0.05
          WILT_RATE   = 0.03
          WATER_DECAY = 0.02
          POLLINATION_BONUS = 0.15

          HEALTH_LABELS = [
            [(0.8..),      :flourishing],
            [(0.6...0.8),  :thriving],
            [(0.4...0.6),  :growing],
            [(0.2...0.4),  :wilting],
            [(..0.2),      :withered]
          ].freeze

          FERTILITY_LABELS = [
            [(0.8..),      :paradise],
            [(0.6...0.8),  :rich],
            [(0.4...0.6),  :adequate],
            [(0.2...0.4),  :poor],
            [(..0.2),      :barren]
          ].freeze

          def self.label_for(table, value)
            table.each { |range, label| return label if range.cover?(value) }
            table.last.last
          end
        end
      end
    end
  end
end
