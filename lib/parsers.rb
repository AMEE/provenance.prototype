parse :svn do |x|
  if x=~/svn\:/
    x.sub(/svn:/,'http://svn.amee.com/!svn/bc/')
  else
    x
  end
end

parse :uri do |x|
  if x.class != RDF::URI
    RDF::URI.new(x)
  else
    x
  end
end