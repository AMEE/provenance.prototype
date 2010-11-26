#!/usr/bin/env ruby
require 'uri'
count=Hash.new(0)
$<.read.scan(URI.regexp){|m|
   count[$&]+=1
}
sorted=count.to_a.sort{
   |x,y| x[1]<=>y[1]
}
sorted.each do |u|
   print "#{u[1]}  #{u[0]}\n"
end
   