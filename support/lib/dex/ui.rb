module Dex
  module UI
    autoload :ANSI,           'dex/ui/ansi'
    autoload :Glyph,          'dex/ui/glyph'
    autoload :Color,          'dex/ui/color'
    autoload :Box,            'dex/ui/box'
    autoload :Frame,          'dex/ui/frame'
    autoload :Progress,       'dex/ui/progress'
    autoload :Prompt,         'dex/ui/prompt'
    autoload :Terminal,       'dex/ui/terminal'
    autoload :Formatter,      'dex/ui/formatter'
    autoload :Spinner,        'dex/ui/spinner'

    # TODO: this, better
    SpinGroup = Spinner::SpinGroup

    # TODO: test
    def self.glyph(handle)
      Dex::UI::Glyph.lookup(handle)
    end

    # TODO: test
    def self.resolve_color(input)
      case input
      when Symbol
        Dex::UI::Color.lookup(input)
      else
        input
      end
    end

    def self.confirm(question)
      Dex::UI::Prompt.confirm(question)
    end

    def self.ask(question, **kwargs)
      Dex::UI::Prompt.ask(question, **kwargs)
    end

    def self.resolve_text(input)
      return input if input.nil?
      Dex::UI::Formatter.new(input).format
    end

    def self.fmt(input, enable_color: true)
      Dex::UI::Formatter.new(input).format(enable_color: enable_color)
    end

    def self.frame(*args, &block)
      Dex::UI::Frame.open(*args, &block)
    end

    def self.spinner(*args, &block)
      Dex::UI::Spinner.spin(*args, &block)
    end

    def self.with_frame_color(color, &block)
      Dex::UI::Frame.with_frame_color_override(color, &block)
    end

    def self.log_output_to(path)
      if Dex::UI::StdoutRouter.duplicate_output_to
        raise "multiple logs not allowed"
      end
      Dex::UI::StdoutRouter.duplicate_output_to = File.open(path, 'w')
      yield
    ensure
      f = Dex::UI::StdoutRouter.duplicate_output_to
      f.close
      Dex::UI::StdoutRouter.duplicate_output_to = nil
    end

    def self.raw
      prev = Thread.current[:no_dexui_frame_inset]
      Thread.current[:no_dexui_frame_inset] = true
      yield
    ensure
      Thread.current[:no_dexui_frame_inset] = prev
    end
  end
end

require 'dex/ui/stdout_router'
