module Jira4R
  JiraTool.class_eval do
    def driver()
      if not @driver
        @logger.info( "Connecting driver to #{@endpoint_url}" )

        service_classname = "Jira4R::V#{@version}::JiraSoapService"
        # this next line is what we monkey to remove the puts
        @logger.info "Service: #{service_classname}"
        service = eval(service_classname)
        @driver = service.send(:new, @endpoint_url)

        if not ( @http_realm.nil? or @http_username.nil? or @http_password.nil? )
          @driver.options["protocol.http.basic_auth"] << [ @http_realm, @http_username, @http_password ]
        end
      end
      @driver
    end

  end
end
