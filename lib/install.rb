#!/usr/bin/env ruby

require_relative 'load'

module Dotfiles
  class Install < Runner
    class << self
      def call
        @phases = []

        add_phase("Setup Bash Profile") { bash_profile }           
        add_phase("Clean dotfiles") { clean_dotfiles }         
        add_phase("Symlink dotfiles to system") { symlink_dotfiles }       
        add_phase("Setup SSH & GPG Config") { ssh_gpg_config }
        add_phase("Setup Git Completion") { git_completion }         

        run_phases
      end

      private

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
            from = "#{Dir.pwd}/#{file}"
            to = "#{Dotfiles::HOME}/dotfiles/scripts/#{file}"
            puts "Symlinking #{from} to #{to}"
            FileUtils.ln_s(
              from,
              to,
              force: true
            )
          end
        end

        Dir.chdir("#{Dotfiles::REPO}/lib/support") do
          Dir.glob('.*.bash') do |file|
            puts "Symlinking #{file} to #{Dotfiles::HOME}/dotfiles/scripts/#{file}"
            FileUtils.cp file, "#{Dotfiles::HOME}/dotfiles/#{File.basename(file)}"
          end
        end
      end

      def git_completion
        puts "Installing Git Completion"
        FileUtils.cp "#{Dotfiles::REPO}/lib/support/git_completion.sh", "#{Dotfiles::HOME}/.git-completion.bash"
      end

      def ssh_gpg_config
        puts "Restoring SSH Config"
        FileUtils.cp "#{Dotfiles::REPO}/lib/support/ssh_config", "#{Dotfiles::HOME}/.ssh/config"

        puts "Restoring GPG Config"
        FileUtils.ln_s "#{Dotfiles::REPO}/lib/support/gpg/gpg-agent.conf",
          "#{Dotfiles::HOME}/.gnupg/gpg-agent.conf", force: true
        FileUtils.ln_s "#{Dotfiles::REPO}/lib/support/gpg/gpg.conf",
          "#{Dotfiles::HOME}/.gnupg/gpg.conf", force: true
      end
    end
  end
end
