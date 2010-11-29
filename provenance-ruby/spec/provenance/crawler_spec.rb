require File.expand_path(File.dirname(File.dirname(__FILE__)) + '/spec_helper')

class RDF::Statement
  def <=>(x)
    to_s<=>x.to_s
  end
end

n=10.times.map{|x|RDF::URI.new "http://test.amee.com/node/#{x}"}
m=10.times.map{|x|RDF::URI.new "http://test.amee.com/attribute/#{x}"}
to=RDF::URI.new "http://test.amee.com/to"
starter=10.times.map{|x|RDF::URI.new "http://test.amee.com/starter/#{x}"}
at=RDF::URI.new "http://test.amee.com/attribute"
Repo=RDF::Repository.new

#     0
#   1    2
#   3  4   5
#     6 7
#       8

Repo << 
  [n[0],to,n[1]] <<
  [n[0],to,n[2]] <<
  [n[1],to,n[3]] <<
  [n[2],to,n[4]] <<
  [n[2],to,n[5]] <<
  [n[4],to,n[6]] <<
  [n[4],to,n[7]] <<
  [n[7],to,n[8]] <<
  [n[3],at,m[1]] <<
  [n[2],at,m[2]] <<
  [n[7],at,m[3]] <<
  [n[6],at,m[4]] <<
  [n[0],at,starter[0]] <<
  [n[2],at,starter[1]] <<
  [n[4],at,starter[3]]

DoubleInducedSubgraph=RDF::Repository.new
DoubleInducedSubgraph <<
  [n[0],to,n[1]] <<
  [n[0],to,n[2]] <<
  [n[1],to,n[3]] <<
  [n[2],to,n[4]] <<
  [n[2],to,n[5]] <<
  [n[4],to,n[6]] <<
  [n[4],to,n[7]] <<
  [n[7],to,n[8]] <<
  [n[3],at,m[1]] <<
  [n[2],at,m[2]] <<
  [n[7],at,m[3]] <<
  #[n[6],at,m[4]] << # this one is not in the double induced subgraph
  #because it is never the intermediate result of a satisfied step
  [n[0],at,starter[0]] <<
  [n[2],at,starter[1]] <<
  [n[4],at,starter[3]]

TwoSubgraph = RDF::Repository.new
TwoSubgraph <<
  [n[0],to,n[2]] <<
  [n[2],to,n[4]] <<
  [n[2],to,n[5]] <<
  [n[4],to,n[6]] <<
  [n[4],to,n[7]] <<
  [n[7],to,n[8]] <<
  [n[2],at,m[2]] <<
  [n[7],at,m[3]] <<
  [n[6],at,m[4]] <<
  [n[2],at,starter[1]]<<
  [n[4],at,starter[3]]

FourSubgraph = RDF::Repository.new
FourSubgraph <<
  [n[2],to,n[4]] <<
  [n[4],to,n[6]] <<
  [n[4],to,n[7]] <<
  [n[7],to,n[8]] <<
  [n[7],at,m[3]] <<
  [n[6],at,m[4]] <<
  [n[4],at,starter[3]]


start=RDF::Query.new{|q|q<<[:end,at,starter[0]]}
startattwo=RDF::Query.new{|q|q<<[:end,at,starter[1]]}
startatfour=RDF::Query.new{|q|q<<[:end,at,starter[3]]}
doublestart=RDF::Query.new{|q|q<<[n[0],to,:middle]<<[:middle,to,:end]}
step=RDF::Query.new{|q|q<<[:start,to,:end]}
doublestep=RDF::Query.new{|q|q<<[:middle,to,:end]<<[:start,to,:middle]}

describe Crawler do

  it "stepper query run alone should find all starts,ends" do
    x=step.dup
    x.execute(Repo)
    x.each_solution.map{|z|z[:start]}.should include n[0]
    x.each_solution.map{|z|z[:start]}.should include n[1]
    x.each_solution.map{|z|z[:start]}.should_not include n[8]
    x.each_solution.map{|z|z[:end]}.should_not include n[0]
    x.each_solution.map{|z|z[:end]}.should include n[8]
  end

  it "doublestart should work" do
    x=doublestart.dup
    x.execute(Repo)
    x.each_solution.map{|z|z[:middle]}.uniq.should eql [n[1],n[2]]
    x.each_solution.map{|z|z[:end]}.should_not include [n[3],n[4],n[5]]
  end

  it "doublestepper query run alone should find all starts,middles,ends" do
    x=doublestep.dup
    x.execute(Repo)
    x.each_solution.map{|z|z[:start]}.should include n[0]
    x.each_solution.map{|z|z[:start]}.should_not include n[1]
    x.each_solution.map{|z|z[:middle]}.should include n[1]
    x.each_solution.map{|z|z[:middle]}.should_not include n[8]
    x.each_solution.map{|z|z[:end]}.should_not include n[0]
    x.each_solution.map{|z|z[:end]}.should_not include n[2]
    x.each_solution.map{|z|z[:end]}.should include n[8]
  end

  it "should start up" do
    c=Crawler.new(Repo,start,step)
    c.progress.should eql [n[0]]
  end
  it "should step once" do
    c=Crawler.new(Repo,start,step)
    c.step.progress.should eql [n[1],n[2]]
  end
  it "should step twice" do
    c=Crawler.new(Repo,start,step)
    c.step.step.progress.should eql [n[3],n[4],n[5]]
  end
  it "should enum all steps" do
    c=Crawler.new(Repo,start,step)
    c.enum_progress.to_a.should eql [
      [n[0]],
      [n[1],n[2]],
      [n[3],n[4],n[5]],
      [n[6],n[7]],
      [n[8]]
    ]
  end
  it "should double step" do
    c=Crawler.new(Repo,start,doublestep)
    c.enum_progress.to_a.should eql [
      [n[0]],
      [n[4],n[5],n[3]],
      [n[8]]
    ]
  end
  it "should double step via step method" do
    c=Crawler.new(Repo,start,doublestep)
    c.progress.should eql [n[0]]
    c.step
    c.progress.should eql [n[4],n[5],n[3]]
    c.step.progress.should eql [n[8]]
    c.step.progress.should be_empty
  end
  it "should correctly start from internal node" do
    c=Crawler.new(Repo,startattwo,step)
    c.enum_progress.to_a.should eql [
      [n[2]],
      [n[4],n[5]],
      [n[6],n[7]],
      [n[8]]
    ]
  end
  it "should correctly start from internal node via url" do
    c=Crawler.new(Repo,n[2],step)
    c.enum_progress.to_a.should eql [
      [n[2]],
      [n[4],n[5]],
      [n[6],n[7]],
      [n[8]]
    ]
  end
  it "should correctly start from internal node four via url" do
    c=Crawler.new(Repo,n[4],step)
    c.enum_progress.to_a.should eql [
      [n[4]],
      [n[6],n[7]],
      [n[8]]
    ]
  end
  it "should develop induced subgraph from root" do
    c=Crawler.new(Repo,start,step)
    c.induced_subgraph.statements.sort.
      should eql Repo.statements.sort
  end
  it "should develop doublestep induced subgraph from root" do
    c=Crawler.new(Repo,start,doublestep)
    c.induced_subgraph.statements.sort.
      should eql DoubleInducedSubgraph.statements.sort
  end
  it "should develop induced subgraph from node two" do
    c=Crawler.new(Repo,startattwo,step)
    c.induced_subgraph.statements.sort.
      should eql TwoSubgraph.statements.sort
  end
  it "should develop induced subgraph from node four" do
    c=Crawler.new(Repo,startatfour,step)
    c.induced_subgraph.statements.sort.
      should eql FourSubgraph.statements.sort
  end

end

