#!/usr/bin/env ruby

require_relative 'load'
require_relative 'install'
require 'fileutils'

module Dotfiles
  class Setup < Runner
    INSTALL_BREW_COMMAND = '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" < /dev/null'

    class << self
      def call
        @phases = []
        
        FileUtils.mkdir_p(File.expand_path('~/src/github.com/jules2689'))

        add_phase("Install Homebrew & Setup Auth") { install_homebrew_and_auth }
        add_phase("Restore App Settings") { restore_preferences }
        add_phase("Restore/Setup SSH Keys") { restore_setup_ssh }
        add_phase("Restore/Setup GPG Keys") { restore_setup_gpg }
        add_phase("Run Install Script for Dotfiles") { install_script }
        add_phase("Finalize installation") { run_various }

        CLI::UI::StdoutRouter.enable
        print_setup
        run_phases
        print_finalization
      end

      private

      def confirm(message)
        if ENV["CI"]
          true
        else
          CLI::UI::Prompt.confirm(message)
        end
      end

      def ask(message, options: nil)
        if ENV["CI"]
          return "default@default.com" if options.nil?
          options.first
        else
          CLI::UI::Prompt.ask(message, options: options)
        end
      end

      def install_homebrew_and_auth
        Dir.chdir(Dotfiles::REPO) do
          system(INSTALL_BREW_COMMAND) if confirm('Do you want to run Homebrew install scripts?') && !system("which brew")
          setup_onepassword
          setup_gh
        end
      end

      def brew_install
        Dir.chdir(Dotfiles::REPO) do
          return if `brew bundle check`.include?('are satisfied')
          run("brew bundle install")
        end
      end

      def setup_onepassword
        run("brew install 1password > /dev/null 2>&1") # Install this first so we can start setup
        return if ENV["OP_SESSION"]
        email = ask('What is your 1Password email?')
        env_var = `op signin my.1password.com #{email} --raw`.chomp
        ENV["OP_SESSION"] = env_var
      end

      def setup_gh
        run("brew install gh > /dev/null 2>&1") # Install this first so we can start setup
        return if `gh auth status 2>&1`.include?("Logged in to github.com")
        system("gh auth login --hostname github.com --web")
      end

      def restore_preferences
        FileUtils.cp(
          "#{Dotfiles::REPO}/lib/provision/preferences/com.googlecode.iterm2.plist",
          "#{Dotfiles::HOME}/Library/Preferences/com.googlecode.iterm2.plist"
        )
      end

      def install_script
        Install.call
      end

      def run_various
        puts "Setting some default system settings"
        run("DevToolsSecurity -enable")
      end

      def restore_setup_ssh
        case ask('Do you want to restore existing or setup new SSH keys?', options: %w(setup restore skip))
        when 'restore'
          public_key = `op get document "id_rsa.pub - SSH Key"`.chomp
          private_key = `op get document "id_rsa - SSH Key"`.chomp

          FileUtils.mkdir_p(File.expand_path("~/.ssh"))
          File.write(File.expand_path("~/.ssh/id_rsa.pub"), public_key)
          File.write(File.expand_path("~/.ssh/id_rsa"), private_key)
          FileUtils.chmod(0600, File.expand_path("~/.ssh/id_rsa"))
        when 'setup'
          if confirm('Create SSH key in ~/.ssh/id_rsa - overwriting any existing ones?')
            email = ask('What email should be used for this SSH key?')
            system("ssh-keygen -t rsa -b 4096 -C \"#{email}\" -f ~/.ssh/id_rsa -q -N \"\"")
            system("pbcopy < ~/.ssh/id_rsa.pub")

            puts 'Please add the SSH Key to GitHub, it has been copied to your clipboard'
            puts 'Opening GitHub now'
            sleep(2)
            system('open https://github.com/settings/ssh/new')
          end
        end
      end

      def restore_setup_gpg
        case ask('Do you want to setup new GPG keys?', options: %w(setup skip))
        when 'setup'
          # Initial Setup
          full_name = ask('What name should be associated with this GPG key?')
          email = ask('What email should be used for this GPG key? (Make sure it is verified on GitHub)')
          File.write('/tmp/gpg_conf', <<~EOF)
          Key-Type: 1
          Key-Length: 4096
          Subkey-Type: 1
          Subkey-Length: 4096
          Name-Real: #{full_name}
          Name-Email: #{email}
          Expire-Date: 0
          EOF

          # Generate GPG Keys
          line = nil
          spin_group = CLI::UI::SpinGroup.new
          spin_group.add('Generating Key') do
            line = `gpg --batch --gen-key /tmp/gpg_conf 2>&1`.lines.first
          end
          spin_group.wait

          # Extract data
          key = line.match(/gpg: key (\w+) marked as ultimately trusted/)[1]
          if key.nil?
            puts 'Cannot find key from the command. Follow https://help.github.com/en/articles/generating-a-new-gpg-key to find the key that was generated'
            key = ask('What was the key that was generated?')
          end
          system("gpg --armor --export #{key} | pbcopy")

          run("git config --global commit.gpgsign true")
          run("git config --global user.signingkey #{key[-16..-1]}")

          # Add to GitHub
          puts 'Please add the GPG Key to GitHub, it has been copied to your clipboard'
          puts 'Opening GitHub now'
          sleep(2)
          system("open https://github.com/settings/gpg/new")
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
