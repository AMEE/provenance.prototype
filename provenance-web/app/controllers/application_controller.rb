# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include MyAmeeAuthenticatedSystem
  helper :all # include all helpers, all the time
  def current_url
    request.protocol + request.host_with_port + request.request_uri
  end
end
