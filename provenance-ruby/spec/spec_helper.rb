$TESTING=true
$:.push File.join(File.dirname(__FILE__), '..', 'lib')
Resources=File.join(File.dirname(__FILE__),'resources')
require 'provenance'
Spec::Runner.configure do |config|
  config.mock_with :flexmock
end