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

require 'json'

json_str = STDIN.gets
parsed_resp = JSON.parse(json_str)

log_path = File.join(
  File.expand_path('~/.jobs/logs'),
  parsed_resp['job']['command'],
  Time.now.strftime('%Y/%m/%d/%H-%M'),
  parsed_resp['job']['status'] + "_log.log"
)

output = <<~EOF
STDOUT:

#{parsed_resp['stdout']}

STDERR:

#{parsed_resp['stderr']}

JSON:

#{json_str}
EOF

File.write(log_path, output)