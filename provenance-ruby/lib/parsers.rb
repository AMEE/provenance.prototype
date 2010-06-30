parse :escapes do |x|
  if x.respond_to? :gsub
    x.gsub(/\\/,'')
  else
    x
  end
end



parse :csv_files do |x|
  if x=~/csv_files\:/
     folder=x.sub(/csv_files\:/,'apicsvs:')
     ["#{folder}/default.js",
      "#{folder}/itemdef.csv",
      "#{folder}/data.csv",
     ]
  else
    x
  end
end

parse :apicsvs do |x|
  if x=~/apicsvs\:/
     x.sub(/apicsvs\:/,'svn:internal/api_csvs/')
  else
    x
  end
end

parse :amee do |x|
  if x=~/amee\:/
     x.sub(/amee\:/,'http://live.amee.com/data/')
  else
    x
  end
end

parse :svn do |x|
  if x=~/svn\:/
    if x.split(/\//)[0]=~/[0-9]+/
      x.sub(/svn\:/,'http://svn.amee.com/!svn/bc/')
    else
      # improve this to lookup latest svn number
      x.sub(/svn\:/,'http://svn.amee.com/')
    end
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