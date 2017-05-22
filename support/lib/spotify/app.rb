module Spotify
  class App
    def self.state
      oascript('tell application "Spotify" to player state as string')
    end

    def self.status
      artist = oascript('tell application "Spotify" to artist of current track as string')
      album = oascript('tell application "Spotify" to album of current track as string')
      track = oascript('tell application "Spotify" to name of current track as string')
      duration = oascript(<<-EOF)
        tell application "Spotify"
        set durSec to (duration of current track / 1000) as text
        set tM to (round (durSec / 60) rounding down) as text
        if length of ((durSec mod 60 div 1) as text) is greater than 1 then
            set tS to (durSec mod 60 div 1) as text
        else
            set tS to ("0" & (durSec mod 60 div 1)) as text
        end if
        set myTime to tM as text & ":" & tS as text
        end tell
        return myTime
      EOF
      position = oascript(<<-EOF)
        tell application "Spotify"
        set pos to player position
        set nM to (round (pos / 60) rounding down) as text
        if length of ((round (pos mod 60) rounding down) as text) is greater than 1 then
            set nS to (round (pos mod 60) rounding down) as text
        else
            set nS to ("0" & (round (pos mod 60) rounding down)) as text
        end if
        set nowAt to nM as text & ":" & nS as text
        end tell
        return nowAt
      EOF

      {
        state: state,
        artist: artist,
        album: album,
        track: track,
        duration: duration,
        position: position,
        percent_done: percent_done(position, duration)
      }
    end

    def self.play_pause!
      oascript('tell application "Spotify" to playpause')
    end

    def self.pause!
      oascript('tell application "Spotify" to pause')
    end

    def self.play_uri!(uri)
      oascript("tell application \"Spotify\" to play track \"#{uri}\"")
    end

    def self.next!
      oascript('tell application "Spotify" to next track')
    end

    def self.set_pos!(pos)
      oascript("tell application \"Spotify\" to set player position to #{pos}")
    end

    def self.previous!
      oascript(<<-EOF)
      tell application "Spotify"
          set player position to 0
          previous track
      end tell
      EOF
    end

    def self.replay!
      oascript('tell application "Spotify" to set player position to 0')
    end

    def self.percent_done(position, duration)
      seconds = ->(parts) do
        acc = 0
        multiplier = 1
        while part = parts.shift
          acc += part.to_f * multiplier
          multiplier *= 60
        end
        acc
      end
      pos_parts = position.split(':').reverse
      dur_parts = duration.split(':').reverse
      seconds.call(pos_parts) / seconds.call(dur_parts)
    end

    def self.oascript(command)
      `osascript -e '#{command}'`.strip
    end
  end
end
