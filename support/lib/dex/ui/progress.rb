require 'dex/ui'

module Dex
  module UI
    module Progress
      FILLED_BAR = Dex::UI::Glyph.new("◾", 0x2588,  Color::CYAN)
      UNFILLED_BAR = Dex::UI::Glyph.new("◽", 0x2588,  Color::WHITE)

      def self.progress(percent, width)
        filled = (percent * width).ceil
        unfilled = width - filled
        Dex::UI.resolve_text [
          (FILLED_BAR.to_s * filled),
          (UNFILLED_BAR.to_s * unfilled)
        ].join
      end
    end
  end
end
