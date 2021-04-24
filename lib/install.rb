#!/usr/bin/env ruby

require_relative 'load'

module Dotfiles
  class Install < Runner
    class << self
      def call
        @phases = []

        add_phase("Setup ZSH") { zsh_files }           
        add_phase("Clean dotfiles") { clean_dotfiles }         
        add_phase("Symlink dotfiles to system") { symlink_dotfiles }       
        add_phase("Setup SSH & GPG Config") { ssh_gpg_config }
        add_phase("Setup Git Completion") { git_completion }         

        run_phases
      end

      private

      def zsh_files
        %w(zshrc zshenv).each do |file|
          from = "#{Dotfiles::REPO}/lib/support/.#{file}"
          to = "#{Dotfiles::HOME}/.#{file}"
          puts "Relinking ~/.#{file} #{from} to #{to}"
          FileUtils.ln_s(from, to, force: true)
        end
      end

      def clean_dotfiles
        puts "Remaking ~/dotfiles"
        FileUtils.rm_rf("#{Dotfiles::HOME}/dotfiles")
        FileUtils.mkdir("#{Dotfiles::HOME}/dotfiles")
      end

      def symlink_dotfiles
        FileUtils.mkdir_p("#{Dotfiles::HOME}/dotfiles/scripts/")

        Dir.chdir("#{Dotfiles::REPO}/lib/support") do
          Dir.glob('.*.zsh') do |file|
            puts "Symlinking #{file} to #{Dotfiles::HOME}/dotfiles/scripts/#{file}"
            FileUtils.cp file, "#{Dotfiles::HOME}/dotfiles/#{File.basename(file)}"
          end
        end
      end

      def git_completion
        puts "Installing Git Completion"
        FileUtils.mkdir_p("#{Dotfiles::HOME}/.zsh")

        bash = Net::HTTP.get_response(URI("https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash"))
        File.write("#{Dotfiles::HOME}/.zsh/.git-completion.bash", bash.body)

        zsh = Net::HTTP.get_response(URI("https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh"))
        File.write("#{Dotfiles::HOME}/.zsh/.git-completion.zsh", zsh.body)
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

if __FILE__ == $0
  Dotfiles::Install.call
end
