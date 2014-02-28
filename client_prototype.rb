# encoding: utf-8
require 'socket'  
require 'thread'
hostname = 'localhost'
port = 2000

server = TCPSocket.open(hostname, port)
puts 'linked'
Thread.new do 
  loop{ puts server.recv(150,0)+"\n" }
end
loop{
  server.send( gets.chomp , 0)
}