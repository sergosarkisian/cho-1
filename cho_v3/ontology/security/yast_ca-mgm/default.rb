#!/usr/bin/ruby
require 'json'
operation = ARGV[0]

@curr_path = File.expand_path File.dirname(__FILE__)

case operation
    when "cert"
        cert_json = File.read("#{@curr_path}/cert.json")
        @json= Hash.new
        @json = JSON.parse(cert_json)
        @result = Hash.new
        ca_params = File.read("/var/lib/CAM/#{@json["caname"]}/openssl.cnf.tmpl")        
        
        search = [
            "organizationalUnitName_default",
            "organizationName_default",
            "stateOrProvinceName_default",
            "localityName_default",
            "countryName_default",
            ]
        scan_delimiter = ".*"        
        search_delimiter = "="
        
        regex_map = {
            /\\n/       => '',
            /\[/        => '',
            /\]/        => '',    
            /\"/        => '',                
            /\s+/       => '',            
        }        
        
        #Some parse magic
        search_results = ca_params.scan(/(#{search.join("#{scan_delimiter}|")}#{scan_delimiter})/).to_s
        regex_map.each_pair {|f,t| search_results.gsub! f, t}
        search_results.split(",").map {|i| value = i.split(search_delimiter); @result[value[0]] = value[1]}
        #Some parse magic      

         %x[ /sbin/yast ca_mgm createCertificate caname=#{@json["caname"]} type=#{@json["type"]} cn=#{@json["cn"]} email=#{@json["email"]} ou=#{@result["organizationalUnitName_default"]} o=#{@result["organizationName_default"]} st=#{@result["stateOrProvinceName_default"]} l=#{@result["localityName_default"]} c=#{@result["countryName_default"]} days=#{@json["days"]} keyLength=2048 keyPasswd=#{@json["keyPasswd"]} capasswd=#{@json["capasswd"]} ]
        

    when "ca"
        ca_json = File.read("#{@curr_path}/ca.json")
        @json= Hash.new
        @json = JSON.parse(ca_json)
        
         %x[ /sbin/yast ca_mgm createCA caname=#{@json["caname"]} cn=#{@json["cn"]} email=#{@json["email"]} ou=#{@json["ou"]} o=#{@json["o"]} l=#{@json["l"]} st=#{@json["st"]} c=#{@json["c"]} days=#{@json["days"]} keyLength=2048 keyPasswd=#{@json["keyPasswd"]} ]

	when "export"

		cert_name = File.readlines("/var/lib/CAM/#{caname}/cam.txt").select{|l| l.match /#{user}@#{user_domain}/}.last.split(" ")[0]
		cert_index = File.readlines("/var/lib/CAM/#{caname}/index.txt").select{|l| l.match /#{user}@#{user_domain}/}.last.split(" ")[2]

		%x[ /sbin/yast ca_mgm exportCertificate caname=#{caname} capasswd=#{capasswd} certname=#{cert_index}:#{cert_name} keyPasswd=qwe123 file=/etc/openvpn/client/#{user}.pem certFormat=PEM_CERT_KEY]
        
end