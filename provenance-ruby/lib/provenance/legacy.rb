module Prov
  class LegacyFile < SvnFile
    def initialize(repo,path)
      @folder=File.dirname(path)
      super(repo,path)
      construct_model
    end
    attr_accessor :folder
    def steps
      @steps=construct_steps.enum_with_index.collect do |b,i|
        TextStep.new(self,i,b)
      end
    end
    def called x
      
      m=/\[+(.*)\|(.*?)\]+/.match x
      return x[URI.regexp] unless m
      "#{m[1]} called \"#{m[2]}\""
    end
  end

  class DataCsvFile < LegacyFile
    def construct_model
      @item_definition=ItemDefinition.from_file(File.join(File.dirname(path),'itemdef.csv'))
      @data=DataTable.from_file(path,@id)
    end
    def construct_steps
      @data.items.map{|i|i.get('source')}.uniq.map do |source|
        "prov:process prov:in #{called source} prov:out csv_files:#{folder}"
      end
    end
    def filename
      "data.csv"
    end
    attr_reader :data
  end

  class MetaYmlFile < LegacyFile
    def construct_model
      @meta=YAML.load_file(path)
    end
    def construct_steps
      "prov:process prov:in #{called meta['provenance']} prov:out csv_files:#{folder}"
    end
    def filename
      "meta.yml"
    end
    attr_reader :meta
  end
end