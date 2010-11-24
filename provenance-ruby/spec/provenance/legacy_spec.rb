require File.expand_path(File.dirname(File.dirname(__FILE__)) + '/spec_helper')
describe 'MetaYmlFile' do
  before :each do
    @d=flexmock MetaYmlFile.new(Connection::Subversion.connect,
      File.join(SubversionTestCategory,'meta.yml'))
  end
  it "should parse a meta.yml" do
    @d.steps.first.body.should eql "prov:process prov:in "+
      "http://www.ghgprotocol.org/calculation-tools/all-tools called"+
      " \"GHGP  Protocol\" prov:out amee:/transport/car/generic/ghgp/us"
    @d.steps.
      first.newuri.should eql RDF::URI.new("http://svn.amee.com/internal/api_csvs#{SubversionTestCategory}/meta.yml#provenance?offset=0.3")
  end
  it "should parse basic source" do
    @d.should_receive("meta").
      and_return('provenance' => "http://foo.bar/baz")
    @d.steps.length.should eql 1
    @d.steps.first.body.should eql "prov:process prov:in http://foo.bar/baz"+
      " prov:out amee:/transport/car/generic/ghgp/us"
  end
  it "should parse [|] source" do
    @d.should_receive("meta").
      and_return('provenance' =>  "[http://foo.bar/baz | wibble ]")
    @d.steps.length.should eql 1
    @d.steps.first.body.should eql "prov:process prov:in http://foo.bar/baz"+
      " called \"wibble\" prov:out amee:/transport/car/generic/ghgp/us"
  end
  it "should parse multiple [|] sources" do
    @d.should_receive("meta").
      and_return('provenance' =>  ["[http://foo.bar/baz | wibble ]",
      "http://foo.bar/biz | wobble"])
    @d.steps.length.should eql 1
    @d.steps.first.body.should eql "prov:process prov:in http://foo.bar/baz"+
      " called \"wibble\" prov:out amee:/transport/car/generic/ghgp/us"
  end
  it "should parse multiple sources" do
    @d.should_receive("meta").and_return('provenance'  => ["http://foo.bar/baz",
        "http://foo.bar/biz"])
    @d.steps.length.should eql 1
    @d.steps.first.body.should eql "prov:process prov:in http://foo.bar/baz "+
      "prov:in http://foo.bar/biz prov:out "+
      "amee:/transport/car/generic/ghgp/us"
  end
end

describe 'DataCsvFile' do
  before :each do
    @d=flexmock DataCsvFile.new(Connection::Subversion.connect,
      File.join(SubversionTestCategory,'data.csv'))
  end
  it "should parse a csv file" do
     @d.steps.first.body.should eql "prov:process prov:in "+
      "http://www.ghgprotocol.org/calculation-tools/all-tools prov:out "+
      "amee:/transport/car/generic/ghgp/us"
    @d.steps.length.should eql 1
  end
  it "should parse basic source" do
    @d.should_receive("data.items").
      and_return([flexmock(:get => "http://foo.bar/baz")])
    @d.steps.length.should eql 1
    @d.steps.first.body.should eql "prov:process prov:in http://foo.bar/baz "+
      "prov:out amee:/transport/car/generic/ghgp/us"
  end
  it "should parse [|] source" do
    @d.should_receive("data.items").
      and_return([flexmock(:get => "[http://foo.bar/baz | wibble ]")])
    @d.steps.length.should eql 1
    @d.steps.first.body.should eql "prov:process prov:in http://foo.bar/baz "+
      "called \"wibble\" prov:out amee:/transport/car/generic/ghgp/us"
  end
  it "should parse multiple [|] source with first one no alternative " do
    @d.should_receive("data.items").
      and_return([flexmock(:get => "[[wibble]],[[http://foo.bar/biz | wobble ]]")])
    @d.steps.length.should eql 1
    @d.steps.first.body.should eql "prov:process prov:in http://foo.bar/biz "+
      "called \"wobble\" prov:out amee:/transport/car/generic/ghgp/us"
  end
  it "should parse multiple [|] sources" do
    @d.should_receive("data.items").
      and_return([flexmock(:get => "[[http://foo.bar/baz | wibble ]],[[http://foo.bar/biz | wobble ]]")])
    @d.steps.length.should eql 1
    @d.steps.first.body.should eql "prov:process prov:in http://foo.bar/baz "+
      "called \"wibble\" prov:in http://foo.bar/biz called \"wobble\" "+
      "prov:out amee:/transport/car/generic/ghgp/us"
  end
  it "should parse multiple sources" do
    @d.should_receive("data.items").
      and_return([flexmock(:get => "http://foo.bar/baz http://foo.bar/biz")])
    @d.steps.length.should eql 1
    @d.steps.first.body.should eql "prov:process prov:in http://foo.bar/baz "+
      "prov:in http://foo.bar/biz "+
      "prov:out amee:/transport/car/generic/ghgp/us"
  end
  it "should parse multiple sources with cruft" do
    @d.should_receive("data.items").
      and_return([flexmock(:get => "UK: http://foo.bar/baz ; IE: http://foo.bar/biz ")])
    @d.steps.length.should eql 1
    @d.steps.first.body.should eql "prov:process prov:in http://foo.bar/baz "+
      "prov:in http://foo.bar/biz "+
      "prov:out amee:/transport/car/generic/ghgp/us"
  end
end

describe 'legacy' do
  it "should execute command" do
    @p=Provenance.new("-x --legacy #{SubversionTestCategory}")
    @p.exec
    @p.triples.should_not be_empty
  end

end
