#!/usr/bin/env ruby

require_relative 'load'
require_relative 'install'
require_relative 'one_password'
require 'fileutils'

module Dotfiles
  class Setup < Runner
    INSTALL_BREW_COMMAND = '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" < /dev/null'

    class << self
      def call
        @phases = []
        
        FileUtils.mkdir_p(File.expand_path('~/src/github.com/jules2689'))

        add_phase("Install Homebrew & Setup Auth") { install_homebrew_and_auth }
        add_phase("Restore/Setup SSH Keys") { restore_setup_ssh }
        add_phase("Restore/Setup GPG Keys") { restore_setup_gpg }
        add_phase("Run Install Script for Dotfiles") { install_script }
        add_phase("Finalize installation") { run_various }

        CLI::UI::StdoutRouter.enable
        run_phases
      end

      private

      def install_homebrew_and_auth
        Dir.chdir(Dotfiles::REPO) do
          if confirm('Do you want to run Homebrew install scripts?') && !system("which brew")
            system(INSTALL_BREW_COMMAND)
          end
          OnePassword.setup
          setup_gh
        end
      end

      def brew_install
        Dir.chdir(Dotfiles::REPO) do
          return if `brew bundle check`.include?('are satisfied')
          run("brew bundle install")
        end
      end      

      def setup_gh
        run("brew install gh > /dev/null 2>&1") # Install this first so we can start setup
        return if `gh auth status 2>&1`.include?("Logged in to github.com")
        system("gh auth login --hostname github.com --web")
      end

      def install_script
        Install.call
      end

      def run_various
        puts "Setting some default system settings"
        run("DevToolsSecurity -enable")
        run("chsh -s /bin/bash")
        run("git config --global init.defaultBranch main")
        run("ssh-keyscan -H github.com >> ~/.ssh/known_hosts")
      end

      def restore_setup_ssh
        case ask('Do you want to restore existing or setup new SSH keys?', options: %w(setup restore skip))
        when 'restore'
          public_key = OnePassword.run_cmd("op get document \"id_rsa.pub - SSH Key\"")
          private_key = OnePassword.run_cmd("op get document \"id_rsa - SSH Key\"")

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
          puts line
          key = line.match(/gpg: key (\w+) marked as ultimately trusted/)
          if key.nil? || key[1].nil?
            puts 'Cannot find key from the command. Follow https://help.github.com/en/articles/generating-a-new-gpg-key to find the key that was generated'
            key = ask('What was the key that was generated?')
          end
          key = key[1]
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
    end
  end
end

Dotfiles::Setup.call
