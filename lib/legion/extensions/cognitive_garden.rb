# frozen_string_literal: true

require 'securerandom'

require_relative 'cognitive_garden/version'
require_relative 'cognitive_garden/helpers/constants'
require_relative 'cognitive_garden/helpers/plant'
require_relative 'cognitive_garden/helpers/plot'
require_relative 'cognitive_garden/helpers/garden_engine'
require_relative 'cognitive_garden/runners/cognitive_garden'
require_relative 'cognitive_garden/client'

module Legion
  module Extensions
    module CognitiveGarden
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
