#!/bin/ruby
require 'open3'
mountpoint = ARGV[0]

if not mountpoint =~/\//
    puts "Please enter a mountpoint"
    abort
end

rescan = ARGV[1]
if rescan == "Yes"
    %x(btrfs quota rescan -w  #{mountpoint})
end

qList=%x(btrfs qgroup show -pcre --gbytes #{mountpoint}|awk '{print $1", "$6", "$7", "$2", "$3}'|grep iB).split("\n")
subList=%x(btrfs subvolume list #{mountpoint}|awk '{print $2", "$7", "$9}').split("\n")
subListHash = Hash.new
qListHash = Hash.new
formatPath = '%-60s %-8s %-12s %-12s'
formatSpace = '%-60s %-8s %-12s %-12s'

subList.each do |line|
    lineSplitted=line.split(", ")
    subListHash[lineSplitted[0].to_i] = Hash.new
    subListHash[lineSplitted[0].to_i]["parent"]=lineSplitted[1]
    subListHash[lineSplitted[0].to_i]["relpath"]=lineSplitted[2]
    snapBasePath="#{mountpoint}/#{lineSplitted[2]}_snap"
    stdin, stdout, stderr = Open3.popen3("ls -a #{snapBasePath}|grep \"\.\" -c")
    subListHash[lineSplitted[0].to_i]["snappath"]=stdout.read.to_i
end

qList.each do |line|
    lineSplitted=line.split(", ")
    qLeaf=lineSplitted[0].split("/")[0].to_i
    qId=lineSplitted[0].split("/")[1].to_i
    qListHash[qLeaf] ||= Hash.new
    qListHash[qLeaf][qId] ||= Hash.new    
    qListHash[qLeaf][qId]["parent"]=lineSplitted[1]
    qListHash[qLeaf][qId]["child"]=lineSplitted[2]    
    qListHash[qLeaf][qId]["rfer"]=lineSplitted[3]    
    qListHash[qLeaf][qId]["excl"]=lineSplitted[4]  
end


qListHash[0].each do |k,v|
    if subListHash.key?(k) 
        if not (subListHash[k]["snappath"] == 0)
            snapBasePath="#{mountpoint}/#{subListHash[k]["relpath"].chomp("_snap")}"
            snapBaseID=%x(btrfs subvolume show #{snapBasePath}|grep "Subvolume ID:"|awk '{print $3}').to_i
            puts "\n###########################################################################################"
            puts formatPath % ['## Path', 'ID', '1', '2']
            puts formatPath % [snapBasePath, snapBaseID, "", ""]
            puts "\n"
            puts formatPath % ['## Category', 'Count', 'Shared', 'Excl']
            snapUnitDigit=1
            if qListHash.key?(snapUnitDigit) 
                stdin, stdout, stderr = Open3.popen3("ls -a #{snapBasePath}_snap/#{snapUnitDigit}.*/|grep \"_w\" -c")
                snapcount = stdout.read.to_i                
                puts formatSpace % ["Registred", snapcount, qListHash[snapUnitDigit]["#{snapBaseID}0000".to_i]["rfer"], qListHash[snapUnitDigit]["#{snapBaseID}0000".to_i]["excl"]] if qListHash[snapUnitDigit].key?("#{snapBaseID}0000".to_i)
            end
            snapUnitDigit=2
            if qListHash.key?(snapUnitDigit) 
                stdin, stdout, stderr = Open3.popen3("ls -a #{snapBasePath}_snap/#{snapUnitDigit}.*/|grep \"_w\" -c")
                snapcount = stdout.read.to_i                                
                puts formatSpace % ["Unsorted", snapcount, qListHash[snapUnitDigit]["#{snapBaseID}0000".to_i]["rfer"], qListHash[snapUnitDigit]["#{snapBaseID}0000".to_i]["excl"]] if qListHash[snapUnitDigit].key?("#{snapBaseID}0000".to_i) 
            end
            snapUnitDigit=3
            if qListHash.key?(snapUnitDigit) 
                stdin, stdout, stderr = Open3.popen3("ls -a #{snapBasePath}_snap/#{snapUnitDigit}.*/|grep \"_w\" -c")
                snapcount = stdout.read.to_i                                
                puts formatSpace % ["Minutely", snapcount, qListHash[snapUnitDigit]["#{snapBaseID}0000".to_i]["rfer"], qListHash[snapUnitDigit]["#{snapBaseID}0000".to_i]["excl"]] if qListHash[snapUnitDigit].key?("#{snapBaseID}0000".to_i)  
            end            
            snapUnitDigit=4            
            if qListHash.key?(snapUnitDigit) 
                stdin, stdout, stderr = Open3.popen3("ls -a #{snapBasePath}_snap/#{snapUnitDigit}.*/|grep \"_w\" -c")
                snapcount = stdout.read.to_i                                
                puts formatSpace % ["Hourly", snapcount, qListHash[snapUnitDigit]["#{snapBaseID}0000".to_i]["rfer"], qListHash[snapUnitDigit]["#{snapBaseID}0000".to_i]["excl"]] if qListHash[snapUnitDigit].key?("#{snapBaseID}0000".to_i)  
            end
            snapUnitDigit=5            
            if qListHash.key?(snapUnitDigit) 
                stdin, stdout, stderr = Open3.popen3("ls -a #{snapBasePath}_snap/#{snapUnitDigit}.*/|grep \"_w\" -c")
                snapcount = stdout.read.to_i                                
                puts formatSpace % ["Daily", snapcount, qListHash[snapUnitDigit]["#{snapBaseID}0000".to_i]["rfer"], qListHash[snapUnitDigit]["#{snapBaseID}0000".to_i]["excl"]] if qListHash[snapUnitDigit].key?("#{snapBaseID}0000".to_i)  
            end
            snapUnitDigit=6            
            if qListHash.key?(snapUnitDigit) 
                stdin, stdout, stderr = Open3.popen3("ls -a #{snapBasePath}_snap/#{snapUnitDigit}.*/|grep \"_w\" -c")
                snapcount = stdout.read.to_i                
                puts formatSpace % ["Weekly", snapcount, qListHash[snapUnitDigit]["#{snapBaseID}0000".to_i]["rfer"], qListHash[snapUnitDigit]["#{snapBaseID}0000".to_i]["excl"]] if qListHash[snapUnitDigit].key?("#{snapBaseID}0000".to_i) 
            end
            snapUnitDigit=7            
            if qListHash.key?(snapUnitDigit) 
                stdin, stdout, stderr = Open3.popen3("ls -a #{snapBasePath}_snap/#{snapUnitDigit}.*/|grep \"_w\" -c")
                snapcount = stdout.read.to_i                
                puts formatSpace % ["Monthly", snapcount, qListHash[snapUnitDigit]["#{snapBaseID}0000".to_i]["rfer"], qListHash[snapUnitDigit]["#{snapBaseID}0000".to_i]["excl"]] if qListHash[snapUnitDigit].key?("#{snapBaseID}0000".to_i) 
            end
            snapUnitDigit=8
            if qListHash.key?(snapUnitDigit) 
                stdin, stdout, stderr = Open3.popen3("ls -a #{snapBasePath}_snap/#{snapUnitDigit}.*/|grep \"_w\" -c")
                snapcount = stdout.read.to_i                
                puts formatSpace % ["Manual", snapcount, qListHash[snapUnitDigit]["#{snapBaseID}0000".to_i]["rfer"], qListHash[snapUnitDigit]["#{snapBaseID}0000".to_i]["excl"]] if qListHash[snapUnitDigit].key?("#{snapBaseID}0000".to_i)                       
            end
            snapUnitDigit=9
            if qListHash.key?(snapUnitDigit) 
                stdin, stdout, stderr = Open3.popen3("ls -a #{snapBasePath}_snap/#{snapUnitDigit}.*/|grep \"_w\" -c")
                snapcount = stdout.read.to_i                
                puts formatSpace % ["Trash", snapcount, qListHash[snapUnitDigit]["#{snapBaseID}0000".to_i]["rfer"], qListHash[snapUnitDigit]["#{snapBaseID}0000".to_i]["excl"]] if qListHash[snapUnitDigit].key?("#{snapBaseID}0000".to_i)           
            end
            snapUnitDigit=10
            if qListHash.key?(snapUnitDigit) 
                stdin, stdout, stderr = Open3.popen3("ls -a #{snapBasePath}_snap/#{snapUnitDigit}.*/|grep \"_w\" -c")
                snapcount = stdout.read.to_i                            
                puts formatSpace % ["## OVERALL ##", snapcount, qListHash[snapUnitDigit]["#{snapBaseID}0000".to_i]["rfer"], qListHash[snapUnitDigit]["#{snapBaseID}0000".to_i]["excl"]] if qListHash[snapUnitDigit].key?("#{snapBaseID}0000".to_i)           
            end
            puts "\n###########################################################################################"            
        end
    end
end

