#!/usr/bin/env ruby

require_relative 'load'
require_relative 'install'
require 'fileutils'

module Dotfiles
  class Setup < Runner
    INSTALL_BREW_COMMAND = 'ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null'

    class << self
      def call
        @phases = []
        
        FileUtils.mkdir_p(File.expand_path('~/src/github.com/jules2689'))

        add_phase("Install Homebrew & Packages") { install_homebrew }
        add_phase("Log into 1Password") { log_into_onepassword }
        add_phase("Restore App Settings") { restore_preferences }
        add_phase("Restore SSH Keys") { restore_ssh }
        add_phase("Restore GPG Keys") { restore_gpg }
        add_phase("Install Jobber") { install_jobber }
        add_phase("Run Install Script for Dotfiles") { install_script }
        add_phase("Finalize installation") { run_various }

        CLI::UI::StdoutRouter.enable
        print_setup
        run_phases
        print_finalization
      end

      private

      def install_homebrew
        return unless CLI::UI::Prompt.confirm('Do you want to run Homebrew install scripts?')
        Dir.chdir(Dotfiles::REPO) do
          system(INSTALL_BREW_COMMAND) unless system("which brew")
          
          return if `brew bundle check`.include?('are satisfied')
          run("brew bundle install")
        end
      end

      def log_into_onepassword
        puts "Sign into iCloud to synchronize 1Password. Enter anything to continue installation"
        unless CLI::UI::Prompt.confirm('Is iCloud logged in? Is 1Password synced?')
          raise 'Sync iCloud and 1Password to continue'
        end
      end

      def restore_preferences
        FileUtils.cp(
          "#{Dotfiles::REPO}/lib/provision/preferences/com.googlecode.iterm2.plist",
          "#{Dotfiles::HOME}/Library/Preferences/com.googlecode.iterm2.plist"
        )
      end

      def install_jobber
        return if File.exist?('/usr/local/libexec/jobbermaster')
        puts "Setting up Jobber."
        run("mkdir -p ~/src/github.com/jules2689")
        run("cd ~/src/github.com/jules2689 && git clone https://github.com/jules2689/jobber.git")
        run("cd ~/src/github.com/jules2689/jobber && make check && sudo make install DESTDIR=/")

        puts "Installing Daemon"
        run("sudo cp #{File.join(__dir__, 'support', 'jobber', 'jobber.plist')} /Library/LaunchDaemons/com.juliannadeau.jobber.plist")
      end

      def install_script
        Install.call
      end

      def run_various
        puts "Setting some default system settings"
        run("DevToolsSecurity -enable")
      end

      def restore_ssh
        puts "Please copy your SSH keys from 1Password to ~/Desktop/.ssh"
        CLI::UI::Prompt.confirm('Did you copy your SSH keys from 1Password to ~/Desktop/.ssh?')

        FileUtils.mkdir_p(File.expand_path("~/.ssh"))
        Dir.glob("#{Dotfiles::HOME}/Desktop/ssh/*") do |file|
          path = File.expand_path("~/.ssh/#{File.basename(file)}")
          next if File.exist?(path)
          FileUtils.cp(file, path)
        end
      end

      def restore_gpg
        puts "Please copy your GPG keys from 1Password to ~/Desktop/gpg"
        CLI::UI::Prompt.confirm('Did you copy your GPG keys from 1Password to ~/Desktop/gpg?')

        if File.exist?("#{Dotfiles::HOME}/Desktop/gpg")
          run("gpg --import #{Dotfiles::HOME}/Desktop/gpg/julian-secret-gpg.key")
          run("gpg --import-ownertrust #{Dotfiles::HOME}/Desktop/gpg/julian-ownertrust-gpg.txt")

          FileUtils.rm_rf "#{Dotfiles::HOME}/Desktop/gpg"

          run("git config --global commit.gpgsign true")
          run("git config --global user.signingkey CAD41019602B5DC8") # TODO: GENERIC
        end
      end

      def print_setup
        CLI::UI::Frame.open('', timing: false) do
          puts "  ____       _   _   _                              ____                            _              "
          puts " / ___|  ___| |_| |_(_)_ __   __ _   _   _ _ __    / ___|___  _ __ ___  _ __  _   _| |_ ___ _ __   "
          puts " \\___ \\ / _ | __| __| | '_ \\ / _' | | | | | '_ \\  | |   / _ \\| '_ ' _ \\| '_ \\| | | | __/ _ | '__|  "
          puts "  ___) |  __| |_| |_| | | | | (_| | | |_| | |_) | | |__| (_) | | | | | | |_) | |_| | ||  __| |     "
          puts " |____/ \\___|\\__|\\__|_|_| |_|\\__, |  \\__,_| .__/   \\____\\___/|_| |_| |_| .__/ \\__,_|\\__\\___|_|     "
          puts "                             |___/        |_|                          |_|                         "
        end
      end

      def print_finalization
        CLI::UI::Frame.open('') do
          puts "How to finalize the installation"
          puts "================================="
          puts "1. Restart terminal"
          puts "2. Sign into Firefox, Spotify, Slack, XCode."
          puts "3. Fix the screenshot shortcut in keyboard settings."
        end
      end
    end
  end
end

Dotfiles::Setup.call
