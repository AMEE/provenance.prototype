require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe QueryTemplate do
  include QueryTemplate
  attr_reader :options,:repository
  before :all do
    @options=flexmock(:query=><<-HERE
      working
      <%= repository.query(:predicate=>RDF.type).map do |s|
        "Solution: \#{s.subject}"
        end
       %>
    HERE
    )
    @repository=RDF::Repository.new
    @repository.insert RDF::Statement.new("bob",RDF.type,AMEE.test)
  end
  it "should desc" do
   @q=query
   @q.should match /working/
   @q.should match /bob/
  end
end

describe Provenance do
  it "should parse a query file" do
    @p=Provenance.new("-b -q #{Resources}/test_template.erb")
    @p.exec
    @p.doquery.should match /working/
    @p.doquery.should match Regexp.escape "http://jira.amee.com/browse/ST-49?focusedCommentId=12470"
  end
end