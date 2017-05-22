require 'dex/ui'
require 'readline'

module Dex
  module UI
    module Prompt
      class << self
        def ask(question, options: nil, default: nil, is_file: nil, allow_empty: true)
          if (default && !allow_empty) || (options && (default || is_file))
            raise(ArgumentError, 'conflicting arguments')
          end

          if default
            puts_question("#{question} (empty = #{default})")
          else
            puts_question(question)
          end

          if options
            return ask_options(options)
          end

          loop do
            line = readline(is_file: is_file)

            if line.empty? && default
              write_default_over_empty_input(default)
              return default
            end

            if !line.empty? || allow_empty
              return line
            end
          end
        end

        def confirm(question)
          puts_question(question + ' {{yellow:[y/n]}}')

          loop do
            line = readline(is_file: false)
            char = line[0].downcase
            return true  if char == 'y'
            return false if char == 'n'
          end
        end

        private

        def write_default_over_empty_input(default)
          Dex::UI.raw do
            STDERR.puts(
              Dex::UI::ANSI.cursor_up(1) +
              "\r" +
              Dex::UI::ANSI.cursor_forward(4) + # TODO: width
              default +
              Dex::UI::Color::RESET.code
            )
          end
        end

        def puts_question(str)
          Dex::UI.with_frame_color(:blue) do
            STDOUT.puts(Dex::UI.fmt('{{?}} ' + str))
          end
        end

        def ask_options(options)
          puts_question("Your options are:")
          options.each_with_index do |v, idx|
            puts_question("#{idx + 1}) #{v}")
          end
          puts_question("Choose a number between 1 and #{options.length}")

          buf = -1
          available = (1..options.length).to_a
          until available.include?(buf.to_i)
            buf = readline(is_file: false)

            if buf.nil?
              STDERR.puts
              next
            end

            if buf.is_a?(String)
              buf = buf.chomp
            end
            buf = -1 if buf.empty?
            buf = -1 if buf.to_i.to_s != buf
          end

          options[buf.to_i - 1]
        end

        def readline(is_file: false)
          if is_file
            Readline.completion_proc = Readline::FILENAME_COMPLETION_PROC
            Readline.completion_append_character = ""
          else
            Readline.completion_proc = proc { |*| nil }
            Readline.completion_append_character = " "
          end

          # because Readline is a C library, Dex::UI's hooks into $stdout don't
          # work. We could work around this by having Dex::UI use a pipe and a
          # thread to manage output, but the current strategy feels like a
          # better tradeoff.
          prefix = Dex::UI.with_frame_color(:blue) { Dex::UI::Frame.prefix }
          prompt = prefix + Dex::UI.fmt('{{blue:> }}{{yellow:')

          begin
            Readline.readline(prompt, true).chomp
          rescue Interrupt
            Dex::UI.raw { STDERR.puts('^C' + Dex::UI::Color::RESET.code) }
            raise
          end
        end
      end
    end
  end
end
