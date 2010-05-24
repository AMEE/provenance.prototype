$TESTING=true
$:.push File.join(File.dirname(__FILE__), '..', 'lib')

require 'provenance'
Spec::Runner.configure do |config|
  config.mock_with :flexmock
end