# -*- coding: utf-8 -*-
require 'socket'
require 'rubygems'
require 'json'
require 'pp'

module Zabbix
  class Sender
    def self.send(host, serv='x', port=10051, &blk)
      s = new serv, port
      s.to host, &blk
    end
    
    def initialize(serv='x', port=10051)
      @serv, @port = serv, port
    end
    
    def to(host, &blk)
      raise ArgumentError, "need block" unless block_given?
      begin
        @keep = true
        @data = {}
        instance_eval &blk
        unless @data.empty?
          connect @data.map { |(key, value)|
                              { :host => host.to_s, :key => key.to_s, :value => value.to_s }
                            }
        end
      ensure
        @keep = @data = nil
      end
    end
    
    def send(*args)
      return register args if @keep
      host  = args.shift
      key   = args.shift
      value = args.shift
      connect :host => host.to_s, :key => key.to_s, :value => value.to_s
    end
    
    def register(args)
      key   = args.shift
      value = args.shift
      @data[key] = value
    end
    
    def connect(data)
      sock = nil
      begin
        sock = TCPSocket.new @serv, @port
        sock.write rawdata(data)
        parse sock.read
      ensure
        sock.close if sock
      end
    end
    
    def parse(response)
      JSON.parse response[13 .. -1]
    end
    
    def rawdata(data)
      data = [data] unless data.instance_of? Array
      baggage = {
        :request => 'sender data',
        :data    => data,
        }.to_json
      'ZBXD' + [1, u64le(baggage.bytesize)].flatten.pack("C*") + baggage
    end
    
    def u64le(integer)
      ary = []
      8.times do |n|
        ary << ((integer >> (n * 8)) & 0xFF)
      end
      ary
    end
    

  end
end

