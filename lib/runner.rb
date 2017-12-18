#!/usr/bin/env ruby

class Runner
  HOME = File.expand_path("~")
  DOTFILES = File.join(HOME, 'dotfiles')
  REPO = File.expand_path('../../', __FILE__)

  def self.add_phase(title, &block)
    @phases << [title, &block]
  end

  def self.run_phases
    CLI::UI::StdoutRouter.enable
    @phrases.each_with_index do |(title, block), idx|
      CLI::UI::Frame.open("[#{idx + 1}/#{@phases.size}] #{title}") do
        block.call
      end
    end
  end
end
