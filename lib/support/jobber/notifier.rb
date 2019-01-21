#!/usr/bin/env ruby

# {  
#    "job":{  
#       "command":"/home/dylan/some_program",
#       "name":"MyHourlyJob",
#       "notifyOnError":true,
#       "notifyOnFailure":false,
#       "onError":"Stop",
#       "status":"Failed",
#       "time":"0 0 * * * *"
#    },
#    "startTime":"May 29 15:25:10 2017",
#    "stderr":"Some errors\n",
#    "stderr_base64":false,
#    "stdout":"Quotes: \"adf\"\n",
#    "stdout_base64":false,
#    "succeeded":false,
#    "user":"dylan"
# }

def osascript(script)
system 'osascript', *script.split(/\n/).map { |line| ['-e', line] }.flatten
end

require 'json'

parsed_resp = JSON.parse(STDIN.gets)

msg = if parsed_resp['succeeded']
  "Command succeded"
else
  "Command failed : #{(parsed_resp['stderr'] || "").trucate(15)}"
end

osascript <<-END
  display notification "#{msg}" with title "#{parsed_resp['job']['name']}"
END

