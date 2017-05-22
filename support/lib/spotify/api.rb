require 'spotify/app'
require 'helpers/doc'

module Spotify
  class Api
    PLAY = "▶"
    STOP = "◼"

    SPOTIFY_SEARCH_API = "https://api.spotify.com/v1/search"

    class << self
      doc <<-EOF
      Changes to the next song

      {{bold:Usage:}}
        {{command:spotify next}}
      EOF
      def next
        puts "Playing next song"
        Spotify::App.next!
      end

      doc <<-EOF
      Changes to the previous song

      {{bold:Usage:}}
        {{command:spotify previous}}
      EOF
      def previous
        puts "Playing previous song"
        Spotify::App.prev!
      end

      doc <<-EOF
      Sets the position in the song

      {{bold:Usage:}}
        {{command:spotify set_pos 60}}
      EOF
      def set_pos
        puts "Setting position to #{ARGV[1]}"
        Spotify::App.set_pos!(ARGV[1])
      end

      doc <<-EOF
      Replays the current song

      {{bold:Usage:}}
        {{command:spotify replay}}
      EOF
      def replay
        puts "Restarting song"
        Spotify::App.replay!
      end
      
      doc <<-EOF
      Play/Pause the current song, or play a specified artist,
      track, album, or uri
      
      {{bold:Usage:}}
        {{command:spotify play artist [name]}}
        {{command:spotify play track [name]}}
        {{command:spotify play album [name]}}
        {{command:spotify play uri [spotify uri]}}
      EOF
      def play_pause
        args = ARGV[1..-1]

        if args.empty?
          # no specifying paremeter, this is a standard play/pause
          Spotify::App.play_pause!
          status
          return
        end

        arg = args.shift
        type = arg == 'song' ? 'track' : arg

        Dex::UI.frame("Searching for #{type}", timing: false) do
          play_uri = case type
          when 'album', 'artist', 'track'
            results = search_and_play(type: type, query: args.join(' '))
            results.first
          when 'uri'
            args.first
          end
          puts "Results found, playing"
          Spotify::App.play_uri!(play_uri)
          sleep 0.05 # Give time for the app to switch otherwise status may be stale
        end

        status
      end

      doc <<-EOF
      Pause/stop the current song

      {{bold:Usage:}}
        {{command:spotify pause}}
        {{command:spotify stop}}
      EOF
      def pause
        Spotify::App.pause!
        status
      end

      doc <<-EOF
      Show the current song

      {{bold:Usage:}}
        {{command:spotify status}}
      EOF
      def status
        stat = Spotify::App.status

        time = "#{stat[:position]} / #{stat[:duration]}"
        state_sym = case stat[:state]
        when 'playing'
          PLAY
        else
          STOP
        end
        # 3 for padding around time, and symbol, and space for the symbol, 2 for frame
        width = Dex::UI::Terminal.width - time.size - 5

        Dex::UI.frame(stat[:track], timing: false) do
          puts Dex::UI.resolve_text([
            "{{bold:Artist:}} #{stat[:artist]}",
            "{{bold:Album:}} #{stat[:album]}",
          ].join("\n"))
          puts [
            Dex::UI::Progress.progress(stat[:percent_done], width),
            state_sym,
            time
          ].join(' ')
        end
      end

      doc <<-EOF
      Display Help

      {{bold:Usage:}}
       {{command:spotify}}
       {{command:spotify help}}
      EOF
      def help(mappings)
        Dex::UI.frame('Spotify CLI', timing: false) do
          puts "CLI interface for Spotify"
        end

        mappings.group_by { |_,v| v }.each do |k, v|
          v.reject! { |mapping| mapping.first == k.to_s }
          doc = get_doc(self.class, k.to_s).strip_heredoc

          Dex::UI.frame(k, timing: false) do
            puts puts Dex::UI.resolve_text(doc)
            next if v.empty?
            puts Dex::UI.resolve_text("{{bold:Aliases:}}")
            v.each { |mapping| puts Dex::UI.resolve_text(" - {{info:#{mapping.first}}}") }
          end
        end
      end

      private

      def search_and_play(args)
        type = args[:type]
        type2 = args[:type2] || type
        query = args[:query]
        limit = args[:limit] || 1
        puts "Searching #{type}s for: #{query}";

        curl_cmd = <<-EOF
        curl -s -G #{SPOTIFY_SEARCH_API} --data-urlencode "q=#{query}" -d "type=#{type}&limit=#{limit}&offset=0" -H "Accept: application/json" \
        | grep -E -o "spotify:#{type2}:[a-zA-Z0-9]+" -m #{limit}
        EOF

        `#{curl_cmd}`.strip.split("\n")
      end
    end
  end
end
