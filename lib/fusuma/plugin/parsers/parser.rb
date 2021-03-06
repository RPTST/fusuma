# frozen_string_literal: true

require_relative '../base'

module Fusuma
  module Plugin
    module Parsers
      # Parser change record and tag in event
      # Inherite this base class
      class Parser < Base
        # Parse Event and convert Record and Tag
        # if `#parse_record` return nil, this method will return original event
        # @param event [Event]
        # @return [Event]
        def parse(event)
          event.tap do |e|
            next if e.tag != source

            new_record = parse_record(e.record)
            next unless new_record

            e.record = new_record
            e.tag = tag
          end
        end

        # Set source for tag from config.yml.
        # DEFAULT_SOURCE is defined in each Parser plugins.
        def source
          @source ||= config_params(:source) || self.class.const_get('DEFAULT_SOURCE')
        end

        def tag
          self.class.name.split('::').last.underscore
        end

        # parse Record object
        # @param _record [Record]
        # @return [Record, nil]
        def parse_record(_record)
          nil
        end
      end
    end
  end
end
