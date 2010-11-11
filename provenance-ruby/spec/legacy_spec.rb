require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
describe 'MetaYmlFile' do
  it "should parse a meta.yml" do
    @d=MetaYmlFile.new(Connection::Subversion.connect,File.join(SubversionTestCategory,'meta.yml'))
    @d.steps.first.body.should eql "prov:process prov:in http://www.ghgprotocol.org/calculation-tools/all-tools called \"GHGP  Protocol\" prov:out csv_files:/transport/car/generic/ghgp/us"
  end
end

describe 'DataCsvFile' do
  it "should parse a csv file" do
    @d=DataCsvFile.new(Connection::Subversion.connect,File.join(SubversionTestCategory,'data.csv'))
    @d.steps.first.body.should eql "prov:process prov:in http://www.ghgprotocol.org/calculation-tools/all-tools prov:out csv_files:/transport/car/generic/ghgp/us"
    @d.steps.length.should eql 1
  end
end

describe 'legacy' do
  it "should execute command" do
    @p=Provenance.new("-x --legacy #{SubversionTestCategory}")
    @p.exec
    @p.triples.should_not be_empty
  end
end
