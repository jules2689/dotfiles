require 'dex/ui'

module Dex
  module UI
    module Spinner
      PERIOD = 0.1 # seconds

      begin
        runes = ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏']
        colors = [Dex::UI::Color::CYAN.code] * 5 + [Dex::UI::Color::MAGENTA.code] * 5
        raise unless runes.size == colors.size
        GLYPHS = colors.zip(runes).map(&:join)
      end

      def self.spin(title, &block)
        sg = SpinGroup.new
        sg.add(title, &block)
        sg.wait
      end

      class SpinGroup
        def initialize
          @m = Mutex.new
          @consumed_lines = 0
          @tasks = []
        end

        class Task
          attr_reader :title, :exception, :success, :stdout, :stderr

          def initialize(title, &block)
            @title = title
            @thread = Thread.new do
              cap = Dex::UI::StdoutRouter::Capture.new(with_frame_inset: false, &block)
              begin
                cap.run
              ensure
                @stdout = cap.stdout
                @stderr = cap.stderr
              end
            end

            @done      = false
            @exception = nil
            @success   = false
          end

          def check
            return true if @done
            return false if @thread.alive?

            @done = true
            begin
              status = @thread.join.status
              @success = (status == false)
            rescue => exc
              @exception = exc
              @success = false
            end

            @done
          end

          def render(index, force = true)
            return full_render(index) if force
            partial_render(index)
          end

          private

          def full_render(index)
            inset + glyph(index) + Dex::UI::Color::RESET.code + ' ' + Dex::UI.resolve_text(title)
          end

          def partial_render(index)
            Dex::UI::ANSI.cursor_forward(inset_width) + glyph(index) + Dex::UI::Color::RESET.code
          end

          def glyph(index)
            if @done
              @success ? Dex::UI::Glyph::CHECK.to_s : Dex::UI::Glyph::X.to_s
            else
              GLYPHS[index]
            end
          end

          def inset
            @inset ||= Dex::UI::Frame.prefix
          end

          def inset_width
            @inset_width ||= Dex::UI::ANSI.printing_width(inset)
          end
        end

        def add(title, &block)
          @m.synchronize do
            @tasks << Task.new(title, &block)
          end
        end

        def wait
          idx = 0

          loop do
            all_done = true

            @m.synchronize do
              Dex::UI.raw do
                @tasks.each.with_index do |task, int_index|
                  nat_index = int_index + 1
                  task_done = task.check
                  all_done = false unless task_done

                  if nat_index > @consumed_lines
                    print(task.render(idx, true) + "\n")
                    @consumed_lines += 1
                  else
                    offset = @consumed_lines - int_index
                    move_to   = Dex::UI::ANSI.cursor_up(offset) + "\r"
                    move_from = "\r" + Dex::UI::ANSI.cursor_down(offset)

                    print(move_to + task.render(idx, idx.zero?) + move_from)
                  end
                end
              end
            end

            break if all_done

            idx = (idx + 1) % GLYPHS.size
            sleep(PERIOD)
          end

          debrief
        end

        def debrief
          @m.synchronize do
            @tasks.each do |task|
              next if task.success

              e = task.exception
              out = task.stdout
              err = task.stderr

              Dex::UI::Frame.open('Task Failed: ' + task.title, color: :red) do
                if e
                  puts"#{e.class}: #{e.message}"
                  puts "\tfrom #{e.backtrace.join("\n\tfrom ")}"
                end

                Dex::UI::Frame.divider('STDOUT')
                out = "(empty)" if out.strip.empty?
                puts out

                Dex::UI::Frame.divider('STDERR')
                err = "(empty)" if err.strip.empty?
                puts err
              end
            end
            @tasks.all?(&:success)
          end
        end
      end
    end
  end
end
