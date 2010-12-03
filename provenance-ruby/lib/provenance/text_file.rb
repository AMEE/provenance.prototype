module Prov
  class TextFile
  
    attr_reader :file,:text

    def initialize(file)
      @file=file
      @text=File.read(file.path)
    end

    delegate :path,:to=>:file

    def steps
      @steps=text.split(/\n\n/).enum_with_index.collect do |b,i|
        TextStep.new(self,i,b)
      end
    end

    def uri
      url
    end

    def author
      nil
    end

    def url
      # url of the text file
      "file://#{file.path}"
    end
  end
end
