module Prov
  class Crawler
    # can crawl through an RDF::Repository according to some query pattern
    # using breadth-first-search
    # and return the triples from the induced subgraph
    # Usage
    #
    # Behaves as enumerable
    #
    # c=Crawler.new(repository,stepquery,startquery)
    # triples=c.to_a.flatten
    # Crawler stepquery should be a RDF::Query
    # returning solutions for :end given :start
    # e.g. [:start,somepredicate,:end]
    # seedquery should be a RDF::Query returning values for end
    # e.g. [:end,RDF.type,sometype]
    def initialize(repo,start,stepper)
      @repo=repo
      @stepper=stepper
      @start=start
      # a binding binding :start to each current value of start
      @solution=if @start.is_a? RDF::Query
        start.execute(@repo)
      elsif @start.is_a? Array
        start.map{|u|RDF::Solution.new(:end=>u)}
      elsif @start.is_a? RDF::URI
        [RDF::Query::Solution.new(:end=>@start)]
      else
        raise "Should supply start as query or uriref or array of urirefs"
      end
    end
    def step
      newsolution=[]
      progress.each do |seed|
        nextstep=RDF::Query.new{|q|
          @stepper.patterns.each { |p|
            q<<RDF::Query::Pattern.new(*p.to_a.map{|x|
                x.variable? && x.name==:start ? seed : x
              })
          }
        }
        nextstep.execute(@repo)
        newsolution.concat nextstep.each_solution.to_a
      end
      @solution=newsolution
      $log.debug("Crawler step #{solution.inspect}")
      return self
    end
    def seed
      progress.map{|x|RDF::Query::Solution.new(:start=>x)}
    end
    def progress
      @solution.map{|x|x[:end]}.uniq
    end
    attr_reader :solution
    def each_step
      while !progress.empty?
        yield self
        step
      end
    end
    def each_solution
      each_step do |ss|
        ss.solution.each do |s|
          yield s
        end
      end
    end
    def each_progress
      each_step do |s|
        yield s.progress
      end
    end
    def enum_step
      enum_for(:each_step)
    end
    def enum_progress
      enum_for(:each_progress)
    end
    def enum_solution
      enum_for(:each_solution)
    end
    def induced_subgraph
      # similar to SPARQL describe:
      # get all statements referencing all variables used in the walker
      # and create a new graph based thereon
      statements=enum_solution.map do |s|
        s.to_hash.values.map do |v|
          describe v
        end
      end.flatten(2)
      r=RDF::Repository.new
      statements.each do |s|
        r<<s
      end
      return r
    end

    private

    def describe(uriref)
      o=@repo.query([nil,nil,uriref])
      p=@repo.query([nil,uriref,nil])
      s=@repo.query([uriref,nil,nil])
      [s,p,o].flatten(1)
    end
  end

  class OPMCrawler < Crawler
    def initialize(repo,start)
      step=RDF::Query.new {|q|
        q <<
          [:link,OPM.effect,:start] <<
          [:link,OPM.cause,:end] <<
          [:link,OPM.account,:account] #so that the accounts end up in the description
      }
      super(repo,start,step)
    end
  end
end