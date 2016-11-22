#!/usr/bin/env ruby
require 'json'
require 'erb'
@data=Hash.new { |h,k| h[k] = Hash.new(&h.default_proc) }
fqdn=ARGV[0]

dev = "#{File.absolute_path(File.dirname(__FILE__))}"

if File.exist?("#{dev}/#{fqdn}.json")
    state = Hash.new { |h,k| h[k] = Hash.new(&h.default_proc) }
    state = JSON.parse(File.read("#{dev}/#{fqdn}.json"))
    
    state["fqdn"] = fqdn
    state["fdPort"]=9102 if defined?(state["fdPort"])
    state["fdMaxConcJobs"]=1 if defined?(state["fdMaxConcJobs"])
    state["workDir"]="/var/lib/bareos" if defined?(state["workDir"])

    Dir.glob("#{dev}/../*.erb").each do  |file|
        template = File.read(file)

                    #FileUtils.mkdir_p "#{deploy_dst.join("/")}"
                    File.open("#{dev}/#{File.basename(file,File.extname(file))}", 'w') { |file| file.write(ERB.new(template).result) }

        end
    end
