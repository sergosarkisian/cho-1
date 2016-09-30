#!/usr/bin/env ruby
require 'json'
require 'erb'
require "/media/sysdata/rev5/techpool/ontology/management/rev5/naming_os.rb"

@data=Hash.new { |h,k| h[k] = Hash.new(&h.default_proc) }
fqdn=ARGV[0]

templates = "#{File.absolute_path(File.dirname(__FILE__))}"
path="/media/sysdata/rev5/_context/conf/bareos/backup/"
json_loc="#{path}/#{View}/#{SrvType}"

if File.exist?("#{templates}/#{fqdn}.json")
    state = Hash.new { |h,k| h[k] = Hash.new(&h.default_proc) }
    state = JSON.parse(File.read("#{templates}/#{fqdn}.json"))
    
    state["fqdn"] = fqdn
    state["fdPort"]=9102 if defined?(state["fdPort"])
    state["fdMaxConcJobs"]=1 if defined?(state["fdMaxConcJobs"])
    state["workDir"]="/var/lib/bareos" if defined?(state["workDir"])

    Dir.glob("#{templates}/../*.erb").each do  |file|
        template = File.read(file)

                    #FileUtils.mkdir_p "#{deploy_dst.join("/")}"
                    File.open("#{templates}/#{File.basename(file,File.extname(file))}", 'w') { |file| file.write(ERB.new(template).result) }

        end
    end
