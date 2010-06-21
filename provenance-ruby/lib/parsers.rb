parse :escapes do |x|
  if x.respond_to? :gsub
    x.gsub(/\\/,'')
  else
    x
  end
end

parse :svn do |x|
  if x=~/svn\:/
    x.sub(/svn\:/,'http://svn.amee.com/!svn/bc/')
  else
    x
  end
end

parse :browser do |x|
  if x=~/Shiretoko/
   "http://xml.amee.com/browsers/#{x}"
  else
    x
  end
end

parse :uri do |x|
  if x.class != RDF::URI && (x=~/http\:\/\// || x=~/mailto/)
    RDF::URI.new(x)
  else
    x
  end
end