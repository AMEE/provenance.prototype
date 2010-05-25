
Home=File.join(File.dirname(File.dirname(__FILE__)))

def configfile(mod)
  File.join(Home,'config',"#{mod}.yml")
end

def config(mod)
    YAML.load_file configfile(mod)
end

yc=Log4r::YamlConfigurator
yc['HOME']=Home
yc.load_yaml_file configfile('log')
$log=Log4r::Logger['Main']
$log.debug('Provenance started')