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
    @repository.insert RDF::Statement.new("bob",RDF.type,Prov::AMEE.test)
  end
  it "should desc" do
   @q=doquery
   @q.should match /working/
  end
end

describe Provenance do
  it "should parse a query file" do
    @p=Provenance.new("-q #{Resources}/test_template.erb -x -c 12470 -i ST-49")
    @p.exec
    @p.doquery.should match /working/
    @p.doquery.should match Regexp.escape "http://jira.amee.com/browse/ST-49?focusedCommentId=12470"
  end
  it "should parse a db query file" do
    @p=Provenance.new("--dbq #{Resources}/db_test_query.rb")
    lambda{@p.exec}.should_not raise_error
    @p.triples.should_not be_empty
  end
  it "should parse a sparql query file" do
    @p=Provenance.new("--sparql #{Resources}/sparql_test_query.rq")
    lambda{@p.exec}.should_not raise_error
    @p.triples.should_not be_empty
  end
  it "should parse a db query file with a sparql endpoint" do
    @p=Provenance.new("--database sesame-sparql --dbq #{Resources}/db_test_query.rb")
    lambda{@p.exec}.should_not raise_error
    @p.triples.should_not be_empty
  end
  it "should parse a sparql db query file with a sparql endpoint" do
    @p=Provenance.new("--database sesame-sparql --sparql #{Resources}/sparql_test_query.rq")
    @p.exec
    @p.triples.should_not be_empty
  end
  it "should develop an induced subgraph from exemplar account from category" do
    @p=Provenance.new("--file #{Resources}/sample_account.prov"+
        " --category-subgraph transport/car/generic/ghgp")
    @p.exec
    @p.triples.should_not be_empty
  end
  it "should develop an induced subgraph from exemplar account from url" do
    @p=Provenance.new("--file #{Resources}/sample_account.prov"+
        " --subgraph file:///Users/jamespjh/devel/amee/provenance.prototype/provenance-ruby/spec/resources/sample_account.prov?offset=0")
    @p.exec
    @p.triples.should_not be_empty
  end

end