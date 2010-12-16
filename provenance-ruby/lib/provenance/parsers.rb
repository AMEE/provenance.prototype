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
    x.gsub!("apicsvs:/","apicsvs:") #remove extraneous slash
    presub(x,'svn:internal/api_csvs/')
  end

  prefix :anonymous do |x|
    presub(x,Parser.context+"/anonymous/") do |x|
      CGI.escape x
    end
  end

  prefix :nouri do |x|
    presub(x,"http://xml.amee.com/provenance/global/anonymous/") do |x|
      CGI.escape x
    end
  end

  prefix :amee do |x|
    x.gsub!("amee:/","amee:") #remove extraneous slash
    presub(x,'http://live.amee.com/data/')
  end

  prefix :svn do |x|
    #if x.to_s.split(/\//)[0]=~/[0-9]+/
    #  presub(x,'http://svn.amee.com/!svn/bc/')
    #else
    # improve this to lookup latest svn number
    presub(x,'http://svn.amee.com/') do |path|
      path.gsub(/^\d*\//,'')
    end
    #end
  end

  parse :browser do |x|
    if x=~/Shiretoko/
      "http://xml.amee.com/browsers/#{x}"
    else
      x
    end
  end

  #Don't treat fragment for XLS as part of unique identifier
  parse :xlsfragment do |x|
    if x=~/\.xls/&&x.respond_to?(:gsub)
      x.gsub(/#.*?$/,'')
    else
      x
    end
  end

  parse :pdffragment do |x|
    if x=~/\.pdf/&&x.respond_to?(:gsub)
      x.gsub(/#.*?$/,'')
    else
      x
    end
  end

  parse :uri do |x|
    if x.class != RDF::URI && (x=~/http\:\/\// || x=~/https\:\/\// || x=~/ftp\:\/\// || x=~/mailto/ || x=~/file\:\/\//)
      if x=~/[\s"]/
        x=x.split("/").map{|x| x=~/http/ ? x : CGI.escape(x)}.join("/")
      end
      RDF::URI.new(x)
    else
      x
    end
  end
end
