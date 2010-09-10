# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Options do
  include Options

  it "should parse jira issue switch" do
   parse_options("-i EX-1")
   options.add.should be_true
   options.delete.should be_true
   options.jira.should be_true
   options.infile.should be_nil
   options.category.should be_nil
   options.db_fetch.should be_false
   options.out.should be_nil
  end
  it "should parse text file switch" do
    parse_options("--file #{Resources}/something.prov")
    options.add.should be_true
    options.delete.should be_true
    options.jira.should be_false
    options.infile.path.should eql "#{Resources}/something.prov"
    options.category.should be_nil
    options.db_fetch.should be_false
    options.out.should be_nil
  end
  it "should parse apicsv switch" do
    parse_options("--category /home/heating")
    options.add.should be_true
    options.delete.should be_true
    options.jira.should be_false
    options.infile.should be_nil
    options.category.should eql '/home/heating'
    options.db_fetch.should be_false
    options.out.should be_nil
  end
  it "should parse -d" do
   parse_options("-d -i EX-1")
   options.add.should be_false
   options.delete.should be_true
   options.jira.should be_true
   options.db_fetch.should be_false
   options.out.should be_nil
  end
  it "should parse -x" do
   parse_options("-x -i EX-1")
   options.add.should be_false
   options.delete.should be_false
   options.jira.should be_true
   options.db_fetch.should be_false
   options.out.should be_nil
  end
  it "should parse -b" do
   parse_options("-b")
   options.add.should be_false
   options.delete.should be_false
   options.jira.should be_false
   options.db_fetch.should be_true
   options.out.should be_nil
  end
  it "should parse --in" do
   parse_options("--in #{Resources}/ST-50.xml")
   options.add.should be_false
   options.delete.should be_false
   options.jira.should be_false
   options.db_fetch.should be_false
   options.out.should be_nil
   options.in.path.should eql "#{Resources}/ST-50.xml"
  end
  it "should parse output formats" do
    parse_options("-o -i EX-1")
    options.add.should be_true
    options.delete.should be_true
    options.jira.should be_true
    options.db_fetch.should be_false
    options.out.should eql :rdfxml
    parse_options("--out n3 EX-1")
    options.out.should eql :n3
    parse_options("--out ntriples EX-1")
    options.out.should eql :ntriples
    parse_options("--out rdfxml EX-1")
    options.out.should eql :rdfxml
  end
end

