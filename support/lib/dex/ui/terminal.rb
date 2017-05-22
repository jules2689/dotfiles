require 'dex/ui'
require 'io/console'

module Dex
  module UI
    module Terminal
      def self.width
        if console = IO.console
          console.winsize[1]
        else
          80
        end
      rescue Errno::EIO
        80
      end
    end
  end
end
