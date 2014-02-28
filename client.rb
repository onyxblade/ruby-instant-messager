#encoding : UTF-8
require 'gtk2'
require 'socket'  
require 'thread'

module Server
  def self.body
    @body
  end
  def self.connect 
    @body = TCPSocket.open('localhost', 2000)
  end
end

gtk = Gtk::Builder.new
gtk.add_from_file('r.glade')
gtk['window1'].signal_connect('destroy') { Gtk.main_quit }
gtk['window2'].signal_connect('destroy') { Gtk.main_quit }
gtk['window2'].visible = true

gtk['button_connect'].signal_connect('clicked') do
  Server.connect
  Server.body.send(gtk['nickname'].text, 0)
  gtk['window2'].visible = false
  gtk['window1'].visible = true
  gtk['recv_content'].text = "Server Linked.\n"
  Thread.new do
    loop{ gtk['recv_content'].text += "#{Server.body.recv(150, 0)}\n"}
  end
end

gtk['button_send'].signal_connect('clicked') do
  Server.body.send(gtk['send_content'].text, 0)
  gtk['send_content'].text = ''
end

gtk['window1'].signal_connect('delete_event') do
  Server.body.close
  false
end

Gtk.main