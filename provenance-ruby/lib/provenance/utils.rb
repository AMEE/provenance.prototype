module Prov
  module Utils
    Home=ENV['ProvenanceHome'] || File.join(File.dirname(File.dirname(File.dirname(__FILE__))))
    Install=File.join(File.dirname(File.dirname(File.dirname(__FILE__))))

    def configfile(mod)
      File.join(Home,'config',"#{mod}.yml")
    end

    module_function :configfile

    def config(mod)
      YAML.load_file configfile(mod)
    end

    module_function :config

    def narrow(text,limit=20)
      lines=[]
      while text.length>limit
        line=text[0..limit].split(/[ \/\\\+]/)[0...-1].join(' ')
        break if line.strip.empty?
        lines<<line
        text=text[lines.last.length+1..-1]
      end
      lines<<text
      return lines.map{|x|x.strip}.join("\n")
    end

    yc=Log4r::YamlConfigurator
    yc['HOME']=Home
    yc.load_yaml_file configfile('log')
    $log=Log4r::Logger['Main']
  end

  
end

