require 'dex/ui'

module Dex
  module UI
    class Color
      attr_reader :sgr, :name, :code
      def initialize(sgr, name)
        @sgr  = sgr
        @code = Dex::UI::ANSI.sgr(sgr)
        @name = name
      end

      RED     = new('31', :red)
      GREEN   = new('32', :green)
      YELLOW  = new('33', :yellow)
      BLUE    = new('34', :blue)
      MAGENTA = new('35', :magenta)
      CYAN    = new('36', :cyan)
      WHITE   = new('97', :white)
      RESET   = new('0',  :reset)
      BOLD    = new('1',  :bold)

      MAP = {
        red:     RED,
        green:   GREEN,
        yellow:  YELLOW,
        blue:    BLUE,
        magenta: MAGENTA,
        cyan:    CYAN,
        reset:   RESET,
        bold:    BOLD,
      }.freeze

      class InvalidColorName < ArgumentError
        def initialize(name)
          @name = name
        end

        def message
          keys = Color.available.map(&:inspect).join(',')
          "invalid color: #{@name.inspect} " \
            "-- must be one of Dex::UI::Color.available (#{keys})"
        end
      end

      def self.lookup(name)
        MAP.fetch(name)
      rescue KeyError
        raise InvalidColorName, name
      end

      def self.available
        MAP.keys
      end
    end
  end
end
