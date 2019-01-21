#!/usr/bin/env ruby

require_relative 'load'

module Dotfiles
  class Install < Runner
    class << self
      def call
        @phases = []

        add_phase("Setup/Backup Secret Keys") { backup_secret_keys }     
        add_phase("Setup Bash Profile") { bash_profile }           
        add_phase("Setup Jobber") { symlink_jobber }
        add_phase("Setup Vim") { vim }                    
        add_phase("Clean dotfiles") { clean_dotfiles }         
        add_phase("Symlink dotfiles to system") { symlink_dotfiles }       
        add_phase("Setup SSH Config") { ssh_config }             
        add_phase("Setup Git Completion") { git_completion }         
        add_phase("Restore Secrets Keys") { restore_secrets_keys }   

        run_phases
      end

      private

      def backup_secret_keys
        return unless File.exist?(File.join(DOTFILES, ".keys.bash"))
        puts "Backing up keys"
        FileUtils.cp "#{Dotfiles::DOTFILES}/.keys.bash", "#{Dotfiles::HOME}/.keys.bash"
      end

      def bash_profile
        from = "#{Dotfiles::REPO}/lib/support/.bash_profile"
        to = "#{Dotfiles::HOME}/.bash_profile"
        puts "Relinking ~/.bash_profile #{from} to #{to}"
        FileUtils.ln_s(from, to, force: true)
      end

      def clean_dotfiles
        puts "Remaking ~/dotfiles"
        FileUtils.rm_rf("#{Dotfiles::HOME}/dotfiles")
        FileUtils.mkdir("#{Dotfiles::HOME}/dotfiles")
      end

      def symlink_dotfiles
        FileUtils.mkdir_p("#{Dotfiles::HOME}/dotfiles/scripts/")

        Dir.chdir("#{Dotfiles::REPO}/lib/support/scripts") do
          Dir.glob('*') do |file|
            puts "Symlinking #{file} to #{Dotfiles::HOME}/dotfiles/scripts/#{file}"
            FileUtils.ln_s file, "#{Dotfiles::HOME}/dotfiles/scripts/#{File.basename(file)}", force: true
          end
        end

        Dir.chdir("#{Dotfiles::REPO}/lib/support") do
          Dir.glob('.*.bash') do |file|
            puts "Symlinking #{file} to #{Dotfiles::HOME}/dotfiles/scripts/#{file}"
            FileUtils.cp file, "#{Dotfiles::HOME}/dotfiles/#{File.basename(file)}"
          end
        end
      end

      def symlink_jobber
        from = "#{Dotfiles::REPO}/lib/support/jobber/.jobber"
        to = "#{Dotfiles::HOME}/.jobber"
        puts "Relinking ~/.jobber #{from} to #{to}"
        FileUtils.ln_s(from, to, force: true)
      end

      def vim
        FileUtils.mkdir_p "#{Dotfiles::HOME}/.vim"

        FileUtils.ln_s "#{Dotfiles::REPO}/support/.vimrc", "#{Dotfiles::HOME}/.vimrc", force: true
        FileUtils.ln_s "#{Dotfiles::REPO}/support/.vimrc", "#{Dotfiles::HOME}/.vim/init.vim", force: true

        FileUtils.mkdir_p("#{Dotfiles::HOME}/.config")
        FileUtils.ln_s "#{Dotfiles::HOME}/.vim", "#{Dotfiles::HOME}/.config/nvim", force: true

        run("bash #{Dotfiles::REPO}/lib/support/vim_plugins.sh")
      end

      def restore_secrets_keys
        FileUtils.touch "#{Dotfiles::HOME}/dotfiles/.keys.bash" rescue nil

        # Restore any backed up keys
        if File.exist?("#{Dotfiles::HOME}/.keys.bash")
          puts "Restoring keys and removing backup"
          FileUtils.cp "#{Dotfiles::HOME}/.keys.bash", "#{Dotfiles::HOME}/dotfiles/.keys.bash"
          FileUtils.rm "#{Dotfiles::HOME}/.keys.bash"
        end
      end

      def git_completion
        puts "Installing Git Completion"
        FileUtils.cp "#{Dotfiles::REPO}/lib/support/git_completion.sh", "#{Dotfiles::HOME}/.git-completion.bash"
      end

      def ssh_config
        puts "Restoring SSH Config"
        FileUtils.cp "#{Dotfiles::REPO}/lib/support/ssh_config", "#{Dotfiles::HOME}/.ssh/config"
      end
    end
  end
end
