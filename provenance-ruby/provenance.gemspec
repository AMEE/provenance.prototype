require 'rake'
$gemspec=Gem::Specification.new do |s|
  s.name = "provenance"
  s.version = "0.1.1"
  s.date = "2010-09-17"
  s.summary = "Command line tool for the provenance toolbox"
  s.email = "james.hetherington@amee.com"
  s.homepage = "http://www.amee.com"
  s.has_rdoc = true
  s.authors = ["James Hetherington"]
  s.files = FileList["lib/**/*.rb", "bin/*", "[A-Z]*",
   "config/jira.example.yml","config/log.yml","config/svn.example.yml",
   "config/sesame.yml"].to_a
  s.bindir="#{$root}bin"
  s.executables = ['provenance','provenance_daemon']
  s.add_dependency("activesupport", "~>2.3.9")
  s.add_dependency("rdf")
  s.add_dependency("rdf-raptor")
  s.add_dependency("rdf-sesame")
  s.add_dependency("log4r")
  s.add_dependency("jira4r")
  s.add_dependency("sparql-client")
  s.add_dependency("daemons")
  s.requirements << "svn-wc, required ruby svn bindings.
        get with sudo apt-get install libsvn-ruby
      "
end
