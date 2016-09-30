#!//usr/bin/ruby
## TODO
#
# size compar
# ext compar
# file mask
# files count & size -> per dir or total

#tasks - reflink create, reflinks delete, logs delete, directory sizes


require 'json'

task_name=ARGV[0]
json=File.read("/etc/faster/cmdb/techpool/_ruby/tasker/data/#{task_name}.json")
type = JSON.parse(json,:symbolize_names => true)
curr_time = Time.now.to_i

puts type

files_obj = Hash.new
dirs_size = Hash.new

Dir.glob(type[:scope]).each do |o| 
	
		stat = File.stat(o)		
		mtime = stat::mtime.to_i
		abs = curr_time - mtime
				
		ss = abs + type[:modifiers][:time][:correction_s]
		mm = ss/60
		hh = mm/60
		dd = hh/24
		w = dd/7
		m = w/4
		
		
		files_obj[o] ||= Hash.new
		files_obj[o][:mtime_unix] = mtime	
		files_obj[o][:mtime_abs] = abs
		files_obj[o][:ss] = ss
		files_obj[o][:mm] = mm
		files_obj[o][:hh] = hh
		files_obj[o][:dd] = dd
		files_obj[o][:w] = w
		files_obj[o][:m] = m

		abs_path = File.expand_path(o)	#PERF
		dirs_size[abs_path] = 12
		files_obj[o][:abs_path] = abs_path		
		if File.file?(o)
			files_obj[o][:type] = "file"
			
			files_obj[o][:dirname] = File.dirname(o)
			files_obj[o][:parentdir] = files_obj[o][:dirname].split("/").last
			files_obj[o][:filename] = File.basename(o)			
			dirs_size[abs_path] = 	dirs_size[abs_path] + 2
			#puts " Dir size - #{dirs_size[abs_path]}"
			files_obj[o][:ext] = File.extname(o)
			size = stat::size
			size_m = size/1024/1024
			size_g = size_m/1024
			files_obj[o][:size] = size
			files_obj[o][:size_m] = size_m
			files_obj[o][:size_g] = size_g
			
		end
		
		if File.directory?(o)
			files_obj[o][:type] = "dir"
			#puts dirs_size
		end

end		


files_obj.each do |k,v|
	case type[:modifiers][:time][:exp].to_sym
		when :gt
		do_operation = 1 if v[type[:modifiers][:time][:units].to_sym] > type[:modifiers][:time][:value]
		
		when :gte
		do_operation = 1 if v[type[:modifiers][:time][:units].to_sym] >= type[:modifiers][:time][:value]

		when :lt
		do_operation = 1 if v[type[:modifiers][:time][:units].to_sym] < type[:modifiers][:time][:value]
		
		when :lte
		do_operation = 1 if v[type[:modifiers][:time][:units].to_sym] <= type[:modifiers][:time][:value]

	end
	if do_operation
		#require "#{Dir.getwd}/tasks/#{type[:operation]}.rb"
		require "/etc/faster/cmdb/techpool/_ruby/tasker/tasks/#{type[:operation]}.rb"
		send(type[:operation],k,v)
	end
		
end

