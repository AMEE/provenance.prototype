require File.expand_path(File.dirname(File.dirname(__FILE__)) + '/spec_helper')

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
    #this will also load up the db with some stuff ready for other tests
    @p=Provenance.new("-q #{Resources}/test_template.erb -c 12470 -i ST-49")
    @p.exec
    @p.doquery.should match /working/
    @p.doquery.should match Regexp.escape "http://jira.amee.com/browse/ST-49?focusedCommentId=12470"
  end
  it "should give right results in graph query on a comment" do
    @p=Provenance.new("--report artifact_graph -x -c 14135 -i SC-47")
    @p.exec
    dpath="transport/car/generic/ghgp/us"
    curi="http://jira.amee.com/browse/SC-47?focusedCommentId=14135"
    [
      [curi,RDF.type,OPM.Process],
      ["amee:#{dpath}",RDF.type,Prov::AMEE.category],
      [curi+"#1",OPM.cause,"apicsvs:#{dpath}/default.js"],
      [curi+"#2",OPM.cause,"apicsvs:#{dpath}/itemdef.csv"],
      [curi+"#3",OPM.cause,"apicsvs:#{dpath}/data.csv"],
      [curi+"#4",OPM.effect,"amee:#{dpath}"],
      [curi+"#1",OPM.effect,curi],
      [curi+"#2",OPM.effect,curi],
      [curi+"#3",OPM.effect,curi],
      [curi+"#4",OPM.cause,curi]
    ].each do |ss|
      @p.triples.should include *Statemented::enum_substatement(*ss).to_a
    end
    @p.doquery.should match "http://svn.amee.com/internal/api_csvs/transport/car/generic/ghgp/us/default.js\"->\"http://live.amee.com/data/transport/car/generic/ghgp/us\""
    @p.doquery.should match "http://svn.amee.com/internal/api_csvs/transport/car/generic/ghgp/us/data.csv\"->\"http://live.amee.com/data/transport/car/generic/ghgp/us\""
    @p.doquery.should match "http://svn.amee.com/internal/api_csvs/transport/car/generic/ghgp/us/itemdef.csv\"->\"http://live.amee.com/data/transport/car/generic/ghgp/us\""
  end
  it "should parse a db query file" do
    @p=Provenance.new("--dbq #{Resources}/db_test_query.rb")
    @p.exec
    @p.triples.should_not be_empty
  end
  it "should parse a sparql query file" do
    @p=Provenance.new("--sparql #{Resources}/sparql_test_query.rq")
    @p.exec
    @p.triples.should_not be_empty
  end
#  it "should parse a db query file with a sparql endpoint" do
#    @p=Provenance.new("--database sesame-sparql --dbq #{Resources}/db_test_query.rb")
#    @p.exec
#    @p.triples.should_not be_empty
#  end
#  it "should parse a sparql db query file with a sparql endpoint" do
#    @p=Provenance.new("--database sesame-sparql --sparql #{Resources}/sparql_test_query.rq")
#    @p.exec
#    @p.triples.should_not be_empty
#  end
  it "should develop an induced subgraph from exemplar account from category" do
    @p=Provenance.new("--file #{Resources}/sample_account.prov"+
        " --category-subgraph transport/car/generic/ghgp/us")
    @p.exec
    @p.triples.should_not be_empty
  end
  it "should develop an induced subgraph from exemplar account from sparql ep" do
    @p=Provenance.new("--database sesame-sparql -b"+
        " --category-subgraph transport/car/generic/ghgp/us")
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