# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Options do
  include Options

  it "should parse no switches" do
   parse_options("EX-1")
   options.add.should be_true
   options.delete.should be_true
   options.jira.should be_true
   options.db_fetch.should be_false
   options.out.should be_nil
  end
  it "should parse -d" do
   parse_options("-d EX-1")
   options.add.should be_false
   options.delete.should be_true
   options.jira.should be_true
   options.db_fetch.should be_false
   options.out.should be_nil
  end
  it "should parse -x" do
   parse_options("-x EX-1")
   options.add.should be_false
   options.delete.should be_false
   options.jira.should be_true
   options.db_fetch.should be_false
   options.out.should be_nil
  end
  it "should parse -b" do
   parse_options("-b EX-1")
   options.add.should be_false
   options.delete.should be_false
   options.jira.should be_false
   options.db_fetch.should be_true
   options.out.should be_nil
  end
  it "should parse output formats" do
    parse_options("-o EX-1")
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

