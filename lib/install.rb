#!/usr/bin/env ruby

require_relative 'load'

module Dotfiles
  class Install < Runner
    class << self
      def call
        @phases = []

        add_phase("Setup/Backup Secret Keys") { backup_secret_keys }     
        add_phase("Setup Bash Profile") { bash_profile }           
        add_phase("Setup Vim") { vim }                    
        add_phase("Clean dotfiles") { clean_dotfiles }         
        add_phase("Symlink dotfiles to system") { symlink_dotfiles }       
        add_phase("Setup SSH Config") { ssh_config }             
        add_phase("Setup Git Completion") { git_completion }         
        add_phase("Restore Secrets Keys") { restore_secrets_keys }   

        print_setup
        run_phases
      end

      private

      def backup_secret_keys
        return unless File.exist?(File.join(DOTFILES, ".keys.bash")
        puts "Backing up keys"
        FileUtils.cp "#{DOTFILES}/.keys.bash", "#{HOME}/.keys.bash"
      end

      def bash_profile
        FileUtils.rm_rf("#{HOME}/.bash_profile")
        FileUtils.ln_s("#{REPO}/support/.bash_profile", "#{HOME}/.bash_profile")
      end

      def clean_dotfiles
        FileUtils.rm_rf("#{HOME}/dotfiles")
        FileUtils.mkdir("#{HOME}/dotfiles")
      end

      def symlink_dotfiles
        FileUtils.mkdir_p("#{HOME}/dotfiles/scripts/")

        Dir.chdir("#{REPO}/support/scripts") do
          Dir.glob('*') do |file|
            puts "Symlinking #{file} to ${HOME}/dotfiles/scripts/#{file}"
            FileUtils.ln_s file "${HOME}/dotfiles/scripts/#{File.basename(file)}", force: true
          end
        end

        Dir.chdir("#{REPO}/support") do
          Dir.glob('*.*.bash') do |file|
            puts "Symlinking #{file} to ${HOME}/dotfiles/scripts/#{file}"
            FileUtils.ln_s file "${HOME}/dotfiles/scripts/#{File.basename(file)}", force: true
          end
        end
      end

      def vim
        FileUtils.ln_s "#{REPO}/support/.vim/*". "#{HOME}/.vim", force: true
        FileUtils.ln_s "#{REPO}/support/.vimrc", "#{HOME}/.vimrc", force: true
        FileUtils.ln_s "#{REPO}/support/.vimrc", "#{HOME}/.vim/init.vim", force: true

        FileUtils.mkdir_p("#{HOME}/.config")
        FileUtils.ln_s "#{HOME}/.vim", "#{HOME}/.config/nvim"

        # TODO
        # bash support/vim_plugins.sh
      end

      def restore_secrets_keys
        FileUtils.touch "#{HOME}/dotfiles/.keys.bash" rescue nil

        # Restore any backed up keys
        if File.exist?("#{HOME}/.keys.bash")
          puts "Restoring keys and removing backup"
          FileUtils.cp "#{HOME}/.keys.bash", "#{HOME}/dotfiles/.keys.bash"
          FileUtils.rm "#{HOME}/.keys.bash"
        end
      end

      def git_completion
        puts "Installing Git Completion"
        FileUtils.cp "#{REPO}/support/git_completion.sh", "#{HOME}/.git-completion.bash"
      end

      def ssh_config
        puts "Restoring SSH Config"
        FileUtils.cp "#{REPO}/support/ssh_config", "#{HOME}/.ssh/config"
      end
    end
  end
end
