#!/usr/bin/env ruby

require_relative 'load'
require_relative 'install'

module Dotfiles
  class Setup < Runner
    class << self
      def call
        @phases = []

        add_phase("Install Homebrew & Packages") { install_homebrew }
        add_phase("Log into Dropbox") { log_into_dropbox }
        add_phase("Restore App Settings") { restore_preferences }
        add_phase("Restore SSH and GPG Keys") { restore_ssh_gpg }
        add_phase("Install Dev") { install_dev }
        add_phase("Setup Ruby") { install_ruby }
        add_phase("Run Install Script for Dotfiles") { install_script }
        add_phase("Finalize installation") { run_various }

        CLI::UI::StdoutRouter.enable
        print_setup
        run_phases
        print_finalization
      end

      private

      def install_homebrew
        Dir.chdir(Dotfiles::REPO) do
          return if `brew bundle check`.include?('are satisfied')
          run("brew bundle install")
        end
      end

      def log_into_dropbox
        puts "Sign into Dropbox to synchronize 1Password. Enter anything to continue installation"
        # gets
      end

      def restore_preferences
        FileUtils.cp(
          "#{Dotfiles::REPO}/lib/provision/preferences/com.googlecode.iterm2.plist",
          "#{Dotfiles::HOME}/Library/Preferences/com.googlecode.iterm2.plist"
        )
      end

      def install_dev
        return if File.exist?('/opt/dev')
        puts "Setting up Dev."
        run("eval \"$(curl -sS https://dev.shopify.io/up)\"")
      end

      def install_ruby
        response = Net::HTTP.get_response(URI("https://www.ruby-lang.org/en/downloads/releases/"))
        ruby = response.body.scan(/Ruby ([\d\.]*?)</).flatten.sort.reverse.take(1).first
        unless File.exist?("/opt/rubies/#{ruby.strip}")
          CLI::UI::Spinner.spin("Installing Ruby #{ruby}") do
            run("ruby-install ruby-#{ruby.strip}")
          end
        end
        File.write("#{Dotfiles::HOME}/.ruby-version", ruby.strip)
      end

      def install_script
        Install.call
      end

      def run_various
        FileUtils.ln_s "#{Dotfiles::REPO}/support/.mackup.cfg", "#{Dotfiles::HOME}/.mackup.cfg", force: true
        puts "Setting some default system settings"
        run("DevToolsSecurity -enable")
      end

      def restore_ssh_gpg
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
          puts "1. Sign into Google Drive and Dropbox."
          puts "2. Sign into Chrome, Spotify, Slack, Xcode."
          puts "3. Fix the screenshot shortcut in keyboard settings."
          puts "4. Run `mackup restore`"
        end
      end
    end
  end
end

Dotfiles::Setup.call
