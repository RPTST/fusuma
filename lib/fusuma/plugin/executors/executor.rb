# frozen_string_literal: true

require_relative '../base'

module Fusuma
  module Plugin
    # executor class
    module Executors
      # Inherite this base
      class Executor < Base
        # check executable
        # @param _event [Event]
        # @return [TrueClass, FalseClass]
        def executable?(_event)
          raise NotImplementedError, "override #{self.class.name}##{__method__}"
        end

        # execute something
        # @param _event [Event]
        # @return [nil]
        def execute(_event)
          raise NotImplementedError, "override #{self.class.name}##{__method__}"
        end
      end
    end
  end
end
