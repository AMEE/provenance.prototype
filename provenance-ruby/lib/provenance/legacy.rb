module Prov
  class LegacyFile < SvnFile
    def initialize(repo,path)
      @folder=File.dirname(path)
      super(repo,path)
      construct_model
    end
    attr_accessor :folder
    def steps
      begin
      @steps=construct_steps.enum_with_index.collect do |b,i|
        TextStep.new(self,i,b)
      end.reject{|x|x.blank?}
      rescue => err
        $log.warn("Error #{err} while parsing #{self.class.to_s.
          underscore.humanize.downcase} for #{File.dirname(path)}")
        []
      end
    end
    def step x
      c=called x
      "prov:process #{c.reject{|x|x.blank?}.
      map{|s| "prov:in #{s}"}.join(" ")} prov:out csv_files:#{folder}"
    end
    def called x
      return [] unless x
      m=x.enum_for(:scan,/\[+([^\]\[]*?)\|(.*?)\]+/).select{|match|
        match[0]=~URI.regexp
      }.map{|match|
        "#{match[0].strip} called \"#{match[1].strip}\""
      }
     return m unless m.empty?
      return x.enum_for(:scan,URI.regexp).map{|match|
        begin
          add=URI.parse($&)
        rescue URI::InvalidURIError
          add=nil
        end
        add.nil?||(add.path.blank?&&add.host.blank?) ? nil : $&
      }
    end
  end

  class DataCsvFile < LegacyFile
    def construct_model
      begin
      @item_definition=ItemDefinition.from_file(File.join(File.dirname(path),'itemdef.csv'))
      @data=DataTable.from_file(path,@id)
      rescue => err
        $log.warn("Error #{err} while reading data files for #{File.dirname(path)}")
      end
    end
    def construct_steps
      return [] unless data
      data.items.map{|i|i.get('source')}.uniq.map do |source|  
          step source    
      end
    end
    def filename
      "data.csv"
    end
    attr_reader :data
  end

  class MetaYmlFile < LegacyFile
    def construct_model
      begin
      @meta=YAML.load_file(path)
      rescue => err
        $log.warn("Error #{err} while reading metadata file for #{File.dirname(path)}")
      end
    end
    def construct_steps
      return [] unless meta&&meta['provenance']
      sources=meta['provenance']
      sources=sources.join(" ") if sources.is_a? Array #undo yamlism
      step sources
    end
    def filename
      "meta.yml"
    end
    attr_reader :meta
  end
end