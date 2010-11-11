module Prov
  parse :escapes do |x|
    if x.respond_to? :gsub
      x.gsub(/\\/,'')
    else
      x
    end
  end

  prefix :csv_files do |x|
    folder=presub(x,'apicsvs:')
    ["#{folder}/default.js",
      "#{folder}/itemdef.csv",
      "#{folder}/data.csv",
    ]
  end

  prefix :apicsvs do |x|
    presub(x,'svn:internal/api_csvs/')
  end

  prefix :anonymous do |x|
    presub(x,Parser.context+"/")
  end

  prefix :nouri do |x|
    presub(x,"http://xml.amee.com/provenance/global/")
  end

  prefix :amee do |x|
    presub(x,'http://live.amee.com/data/')
  end

  prefix :svn do |x|
    #if x.to_s.split(/\//)[0]=~/[0-9]+/
    #  presub(x,'http://svn.amee.com/!svn/bc/')
    #else
    # improve this to lookup latest svn number
    presub(x,'http://svn.amee.com/')
    #end
  end

  parse :browser do |x|
    if x=~/Shiretoko/
      "http://xml.amee.com/browsers/#{x}"
    else
      x
    end
  end

  parse :uri do |x|
    if x.class != RDF::URI && (x=~/http\:\/\// || x=~/mailto/ || x=~/file\:\/\//)
      RDF::URI.new(x)
    else
      x
    end
  end
end
