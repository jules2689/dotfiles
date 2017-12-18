#!/usr/bin/env ruby

require_relative 'load'

class Downloader
  def self.download
    CLI::UI::StdoutRouter.enable

    CLI::UI::Frame.open('XCode Command Line Tools') do
      if system('xcode-select -p')
        puts "{{v}} command line tools already installed"
      else
        CLI::UI::Spinner.spin("Installing Command Line Tools") do
          # Create the placeholder file that's checked by CLI updates' .dist code in Apple's SUS catalog
          FileUtils.touch("/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress")
          # find the CLI Tools update
          prod = `softwareupdate -l | grep "\*.*Command Line" | head -n 1 | awk -F"*" '{print $2}' | sed -e 's/^ *//' | tr -d '\n'`
          system("softwareupdate -i \"#{prod}\" -v")
        end
      end
    end

    base = File.expand_path("~/src/github.com/jules2689")
    repo_dir = File.join(base, 'dotfiles')
    FileUtils.mkdir_p(base)
    system("git clone https://github.com/jules2689/dotfiles.git #{repo_dir}")
    Dir.chdir(repo_dir) do
      system("git remote set-url origin git@github.com:jules2689/dotfiles.git")
    end
  end
end
