require 'dex/ui'

module Dex
  module UI
    module Frame
      class << self
        DEFAULT_FRAME_COLOR = Dex::UI.resolve_color(:cyan)

        # Can be invoked in two ways: block and blockless
        # In block form, the frame is closed automatically when the block returns
        # In blockless form, caller MUST call Frame.close when the frame is
        #   logically done.
        # blockless form is strongly discouraged in cases where block form can be
        #   made to work.
        def open(
          text,
          color: DEFAULT_FRAME_COLOR,
          failure_text: nil,
          success_text: nil,
          timing:       nil
        )
          color = Dex::UI.resolve_color(color)

          unless block_given?
            if failure_text
              raise ArgumentError, "failure_text is not compatible with blockless invocation"
            elsif success_text
              raise ArgumentError, "success_text is not compatible with blockless invocation"
            elsif !timing.nil?
              raise ArgumentError, "timing is not compatible with blockless invocation"
            end
          end

          timing = true if timing.nil?

          t_start = Time.now.to_f
          Dex::UI.raw do
            puts edge(text, color: color, first: Dex::UI::Box::Heavy::TL)
          end
          FrameStack.push(color)

          return unless block_given?

          begin
            success = false
            success = yield
          rescue
            t_diff = timing ? (Time.now.to_f - t_start) : nil
            close(failure_text, color: :red, elapsed: t_diff)
            raise
          else
            t_diff = timing ? (Time.now.to_f - t_start) : nil
            if success != false
              close(success_text, color: color, elapsed: t_diff)
            else
              close(failure_text, color: :red, elapsed: t_diff)
            end
            success
          end
        end

        def close(text, color: DEFAULT_FRAME_COLOR, elapsed: nil)
          color = Dex::UI.resolve_color(color)

          FrameStack.pop
          kwargs = {}
          if elapsed
            kwargs[:right_text] = "(#{elapsed.round(2)}s)"
          end
          Dex::UI.raw do
            puts edge(text, color: color, first: Dex::UI::Box::Heavy::BL, **kwargs)
          end
        end

        def divider(text, color: nil)
          color = Dex::UI.resolve_color(color)
          item  = Dex::UI.resolve_color(FrameStack.pop)

          Dex::UI.raw do
            puts edge(text, color: (color || item), first: Dex::UI::Box::Heavy::DIV)
          end
          FrameStack.push(item)
        end

        def prefix(color: nil)
          pfx = String.new
          items = FrameStack.items
          items[0..-2].each do |item|
            pfx << Dex::UI.resolve_color(item).code << Dex::UI::Box::Heavy::VERT
          end
          if item = items.last
            c = Thread.current[:dexui_frame_color_override] || color || item
            pfx << Dex::UI.resolve_color(c).code \
              << Dex::UI::Box::Heavy::VERT << ' ' << Dex::UI::Color::RESET.code
          end
          pfx
        end

        def with_frame_color_override(color)
          prev = Thread.current[:dexui_frame_color_override]
          Thread.current[:dexui_frame_color_override] = color
          yield
        ensure
          Thread.current[:dexui_frame_color_override] = prev
        end

        private

        def edge(text, color: raise, first: raise, right_text: nil)
          color = Dex::UI.resolve_color(color)
          text  = Dex::UI.resolve_text("{{#{color.name}:#{text}}}")

          prefix = String.new
          FrameStack.items.each do |item|
            prefix << Dex::UI.resolve_color(item).code << Dex::UI::Box::Heavy::VERT
          end
          prefix << color.code << first << (Dex::UI::Box::Heavy::HORZ * 2)
          text ||= ''
          unless text.empty?
            prefix << ' ' << text << ' '
          end

          suffix = String.new
          if right_text
            suffix << ' ' << right_text << ' ' << color.code << (Dex::UI::Box::Heavy::HORZ * 2)
          end

          textwidth = Dex::UI::ANSI.printing_width(prefix + suffix)
          termwidth = Dex::UI::Terminal.width
          termwidth = 30 if termwidth < 30

          if textwidth > termwidth
            suffix = ''
            prefix = prefix[0...termwidth]
            textwidth = termwidth
          end
          padwidth = termwidth - textwidth
          pad = Dex::UI::Box::Heavy::HORZ * padwidth

          prefix + color.code + pad + suffix + Dex::UI::Color::RESET.code + "\n"
        end

        module FrameStack
          ENVVAR = 'DEX_FRAME_STACK'

          def self.items
            ENV.fetch(ENVVAR, '').split(':').map(&:to_sym)
          end

          def self.push(item)
            curr = items
            curr << item.name
            ENV[ENVVAR] = curr.join(':')
          end

          def self.pop
            curr = items
            ret = curr.pop
            ENV[ENVVAR] = curr.join(':')
            ret.nil? ? nil : ret.to_sym
          end
        end
      end
    end
  end
end
