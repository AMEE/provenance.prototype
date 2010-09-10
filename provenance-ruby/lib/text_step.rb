
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
    "#{file.path.basename}-#{offset}"
  end

  def url
    # url of the jira comment
    "#{file.url}?offset=#{offset}"
  end

  def account_uri
     "#{file.url}"
  end

  def graph_uri
     "#{account_uri}/graph"
  end
end
