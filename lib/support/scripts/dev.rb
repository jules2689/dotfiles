#!/usr/bin/env ruby --disable-gems

def write_to_fd(cmd)
	fd_path = File.expand_path('~/dotfiles/fd_9')
	fd = IO.sysopen(fd_path, 'w')
	io = IO.new(fd)
	io.write("#{cmd}\n")
	io.close
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

case cmd = ARGV.shift
when nil
  puts "No command specified"
  exit 1
when 'cd'
	run_cd(ARGV)
else
  puts "Unsupported command #{cmd}"
  exit 1
end
