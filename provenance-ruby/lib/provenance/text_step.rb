module Prov
  class TextStep < HandlesProvBlock
    include RDF
    attr_reader :file,:offset,:body
    def initialize(file,offset,body)
      super()
      @body=body
      @offset=offset
      @file=file
      parse_body
    end

    def label
      "#{File.basename(file.path)}-#{offset}"
    end

    def url
      # url of the jira comment
      "#{file.url}?offset=#{offset}"
    end

    def account_uri
      "#{file.url}"
    end
  end
end
