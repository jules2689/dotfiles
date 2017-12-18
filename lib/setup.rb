#!/usr/bin/env ruby

require_relative 'load'
require_relative 'install'

module Dotfiles
  class Setup < Runner
    class << self
      def main
        @phases = []

        add_phase "Install Homebrew & Packages" { install_homebrew }
        add_phase "Log into Dropbox" { log_into_dropbox }
        add_phase "Restore App Settings" { restore_preferences }
        add_phase "Restore SSH and GPG Keys" { restore_ssh_gpg }
        add_phase "Install Dev" { install_dev }
        add_phase "Setup Ruby" { install_ruby }
        add_phase "Run Install Script for Dotfile" { install_script }
        add_phase "Finalize installation" { run_various }

        print_setup
        run_phases
        print_finalization
      end

      private

      def install_homebrew
        Dir.chdir(REPO) do
          system("brew bundle install")
        end
      end

      def log_into_dropbox
        puts "Sign into Dropbox to synchronize 1Password. Enter anything to continue installation"
        gets
      end

      def restore_preferences
        FileUtils.cp(
          "#{REPO}/provision/preferences/com.googlecode.iterm2.plist",
          "#{HOME}/Library/Preferences/com.googlecode.iterm2.plist"
        )
        system("defaults read com.googlecode.iterm2")
      end

      def install_dev
        puts "Setting up Dev."
        system("eval \"$(curl -sS https://dev.shopify.io/up)\"")
      end

      def install_ruby
        response = Net::HTTP.get_response(URI("https://www.ruby-lang.org/en/downloads/releases/"))
        ruby = response.body.scan(/Ruby ([\d\.]*?)</).flatten.sort.reverse.take(1)
        system("ruby-install ruby-#{ruby.strip}")
        File.write("#{HOME}/.ruby-version", ruby.strip)
      end

      def install_script
        Installer.call
      end

      def run_various
        FileUtils.ln_s "#{REPO}/support/.mackup.cfg", "#{HOME}/.mackup.cfg", force: true
        puts "Setting some default system settings"
        system("DevToolsSecurity -enable")
      end

      def restore_ssh_gpg
        puts "Get the SSH keys from 1Password"
        puts "Put them in ~/.ssh. Write anything to continue"
        gets

        puts "Get the GPG keys from 1Password"
        puts "Put the files in ~/Desktop/gpg. Write anything to continue"
        gets

        system("gpg --import #{HOME}/Desktop/gpg/julian-secret-gpg.key")
        system("gpg --import-ownertrust #{HOME}/Desktop/gpg/julian-ownertrust-gpg.txt")

        FileUtils.rm_rf "#{HOME}/Desktop/gpg"

        system("git config --global commit.gpgsign true")
        system("git config --global user.signingkey CAD41019602B5DC8") # TODO: GENERIC
      end

      def print_setup
        CLI::UI::Frame.open('') do
          puts "  ____       _   _   _                              ____                            _              "
          puts " / ___|  ___| |_| |_(_)_ __   __ _   _   _ _ __    / ___|___  _ __ ___  _ __  _   _| |_ ___ _ __   "
          puts " \___ \ / _ | __| __| | '_ \ / _' | | | | | '_ \  | |   / _ \| '_ ' _ \| '_ \| | | | __/ _ | '__|  "
          puts "  ___) |  __| |_| |_| | | | | (_| | | |_| | |_) | | |__| (_) | | | | | | |_) | |_| | ||  __| |     "
          puts " |____/ \___|\__|\__|_|_| |_|\__, |  \__,_| .__/   \____\___/|_| |_| |_| .__/ \__,_|\__\___|_|     "
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
