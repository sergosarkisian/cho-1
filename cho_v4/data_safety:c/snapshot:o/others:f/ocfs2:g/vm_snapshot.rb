 ## TODO
require 'date'
require 'fileutils'
require 'open3'

def vm_snapshot(file,opts)
	if opts[:type] == "file"
		time = Time.now
		path = "/media/storage/snapshots/manual/#{opts[:parentdir]}/daily/#{time.strftime("%d.%m")}"
		FileUtils.mkdir_p(path) unless File.exists?(path)
		command = "reflink #{file} -p -t /media/storage/snapshots/manual/#{opts[:parentdir]}/daily/#{time.strftime("%d.%m")}/ -S __mod-#{Time.at(opts[:mtime_unix]).strftime("%d.%m.%y-%H:%M:%S")}__snap-#{time.strftime("%d.%m.%y-%H:%M:%S")}"
		puts command
		puts "#{opts}\n\n"
		Open3.popen3(command)
	end
end
