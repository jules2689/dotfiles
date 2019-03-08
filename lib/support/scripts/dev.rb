#!/usr/bin/env ruby --disable-gems

def write_to_fd(cmd)
  fd_path = File.expand_path('~/dotfiles/fd_9')
  fd = IO.sysopen(fd_path, 'w')
  io = IO.new(fd)
  io.write("#{cmd}\n")
  io.close
end

def parse_repo(repo)
  require 'uri'

  # Handles https and ORG/REPO formats
  host, path = begin
    uri = URI.parse(repo)
    [uri.host || 'github.com', uri.path]
  rescue URI::InvalidURIError
    ["github.com", repo.split(":").last]
  end

  org, repo = path.split('/', 2)

  # Default to personal repos
  if repo.nil?
    repo = org
    org = "jules2689"
  end

  # TODO: Support HTTPS as well
  url = "git@#{host}:#{File.join(org, repo)}"
  url = "#{url}.git" unless url.end_with?('.git')
  [url, host, org, repo]
end

def run_cd(args)
  org, repo = args.shift.split('/', 2)

  # Default to personal repos
  if repo.nil?
    repo = org
    org = "jules2689"
  end

  query = File.join(org, repo)
  options = `find $HOME/src/github.com/* -type d -maxdepth 1 | fzf -f #{query}`.split("\n")

  if options.empty?
    puts "Nothing found for #{args.first}"
  else
    write_to_fd("cd #{options.first.strip}")
  end
end

def run_clone(args)
  url, host, org, repo = parse_repo(args.first)
  org_path = File.expand_path("~/src/#{host}/#{org}/")

  require 'fileutils'
  FileUtils.mkdir_p(org_path)

  puts "Cloning #{url}"
  system("git clone #{url} #{File.join(org_path, repo)}")
  write_to_fd("cd #{File.join(org_path, repo)}")
end

case cmd = ARGV.shift
when nil
  puts "No command specified"
  exit 1
when 'clone'
  run_clone(ARGV)
when 'cd'
  run_cd(ARGV)
else
  puts "Unsupported command #{cmd}"
  exit 1
end
