#!/usr/bin/env ruby

module Dotfiles
  class OnePassword < Runner
    class << self
      def setup
        run("brew install 1password > /dev/null 2>&1") # Install this first so we can start setup
        return if ENV["OP_SESSION"]

        email = get_value_from_mac_keychain("onepassword.email")
        if email.empty?
          email = ask('What is your 1Password email?')
          set_value_in_mac_keychain("onepassword.email", email)
        end

        key = get_value_from_mac_keychain("onepassword.secret_key")
        if key.empty?
          key = ask('What is your secret key?')
          set_value_in_mac_keychain("onepassword.secret_key", key)
        end

        env_var = `op signin my.1password.com #{email} #{key} --raw`.chomp
        ENV["OP_SESSION"] = env_var
        @op_token = env_var
      end

      def run_cmd(cmd)
        `eval $(op signin --session #{@op_token}) && #{cmd}`.chomp
      end

      def set_value_in_mac_keychain(key, value)
        system("security add-generic-password -a \"#{key}\" -s dotfiles -w \"#{value}\"")
      end

      def get_value_from_mac_keychain(key)
        `security find-generic-password -a "#{key}" -w 2> /dev/null`.chomp
      end
    end
  end
end
