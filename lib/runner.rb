#!/usr/bin/env ruby

module Dotfiles
  HOME = File.expand_path("~")
  DOTFILES = File.join(HOME, 'dotfiles')
  REPO = File.expand_path('../../', __FILE__)

  class Runner
    class << self
      def add_phase(title, &block)
        @phases << [title, block]
      end

      def run_phases
        CLI::UI::StdoutRouter.enable
        @phases.each_with_index do |(title, block), idx|
          CLI::UI::Frame.open("[#{idx + 1}/#{@phases.size}] #{title}") do
            block.call
          end
        end
      end

      def run(cmd)
        output = ""
        Open3.popen3(cmd) do |_, stdout, stderr, _|
          while line = stdout.gets
            puts line
            output += line
          end
          while line = stderr.gets
            puts line
          end
        end
        output
      end
    end
  end
end
