# frozen_string_literal: true

require_relative '../base'

module Fusuma
  module Plugin
    # executor class
    module Executors
      # Inherite this base
      class Executor < Base
        BASE_ONESHOT_INTERVAL = 0.5
        BASE_REPEAT_INTERVAL = 0.1

        # reserved words on config.yml
        # @return [Array<Symbol>]
        def self.config_keys
          [name.split('Executors::').last.underscore.gsub('_executor', '').to_sym]
        end

        # check executable
        # @param _event [Events::Event]
        # @return [TrueClass, FalseClass]
        def executable?(_event)
          raise NotImplementedError, "override #{self.class.name}##{__method__}"
        end

        # @param event [Events::Event]
        # @param time [Time]
        # @return [TrueClass, FalseClass]
        def enough_interval?(event)
          return false if @wait_until && event.time < @wait_until

          true
        end

        def update_interval(event)
          @wait_until = event.time + interval(event).to_f
        end

        def interval(event)
          @interval_time ||= {}
          index = event.record.index
          @interval_time[index.cache_key] ||= begin
            config_value =
              Config.search(Config::Index.new([*index.keys, 'interval'])) ||
              Config.search(Config::Index.new(['interval', Detectors::Detector.type(event.tag)]))
            if event.record.trigger == :oneshot
              (config_value || 1) * BASE_ONESHOT_INTERVAL
            else
              (config_value || 1) * BASE_REPEAT_INTERVAL
            end
          end
        end

        # execute somthing
        # @param _event [Event]
        # @return [nil]
        def execute(_event)
          raise NotImplementedError, "override #{self.class.name}##{__method__}"
        end
      end
    end
  end
end
