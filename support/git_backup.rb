#!/bin/ruby

require 'fileutils'
require 'json'

def backup
  git_repos = []
  Dir["/Users/juliannadeau/Development/*/*/*/.git"].each do |file|
    url = /url = (.*)\.git/.match(File.read(file + "/config"))
    if !url.nil?
      git_repos << {
        "path" => "~/Development" + file.gsub(/^.*\/Development|\/\.git/,''),
        "repo" => url[0].gsub(/url = /,'')
      }
    end
  end

  paths = git_repos.collect { |g| g["path"].gsub(/\/\w+$/,'') }
  { "paths" => paths, "repos" => git_repos }
end

def restore(json)
  json["paths"].each do |path|
    FileUtils.mkdir_p(path)
  end

  json["repos"].each do |repo|
    system("git clone #{repo["repo"]} #{repo["path"]}")
  end
end

if ARGV[0] == "restore"
  json = JSON.parse(File.read(ARGV[1]))
  restore(json)
else
  dir = ARGV[0]
  File.open(dir, 'w') { |file| file.write(backup.to_json) }
end
