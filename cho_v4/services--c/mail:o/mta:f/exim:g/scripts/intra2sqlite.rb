#!/usr/bin/ruby

require 'json'
require 'open-uri'
require 'sqlite3'

exit 1 if not ARGV[1]
url = ARGV[0]
type = ARGV[1]

aliases = Array.new
del = Array.new
sql = Array.new
#db = SQLite3::Database.new( "#{sqlite_path}/mail.sqlite" )

if type == "csv"
	csv = open("#{url}").read.split("\n")

	csv.each do |v| 
        cur_alias = v.split(" ")[0].split("@")[0]
        if cur_alias =~ /^--/
            del << cur_alias[2..-1]         
        else
            aliases << cur_alias            
        end
    end
	
end

sum_aliases = aliases - del

n=1000
sum_aliases.each do |v|
    sql <<  "(#{n}, 'intra_auto', 1, '#{v}', 1, 'help', 'smtp', FALSE),"
	n = n+1
end

puts sql
# db.transaction 
# db.execute_batch( sql.join(" ") )
# db.commit