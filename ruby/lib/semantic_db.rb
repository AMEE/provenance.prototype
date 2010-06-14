#wrapper class for Sesame or other semantic libraries
#to give potential for multiple libraries to have same signature to our code

class SemanticDB
  def initialize
    @log=Log4r::Logger['Semantic']
  end
  def store(triples)
    raise NotSupported
  end
  def query(query)
    raise NotSupported
  end
  def delete(triples)
    raise NotSupported
  end
  def true?(statement)
    raise NotSupported
  end
  def count
    raise NotSupported
  end
  def fetch
    raise NotSupported
  end
  class NotSupported < Exception

  end
end

class SemanticDB::Sesame < SemanticDB
  def initialize(connection=Connection::Sesame.connect)
    @sesame=connection
    super()
  end
  def store(triples)
    triples.each do |statement|
      @log.debug("Set: #{statement.subject} #{statement.predicate} #{statement.object}")
      @sesame.insert_statement statement
    end
  end
  def delete(triples)
    triples.each do |statement|
      @log.debug("Unset: #{statement.subject} #{statement.predicate} #{statement.object}")
      @sesame.delete_statement statement
    end
  end
  def true?(statement)
    @log.debug("Verify: #{statement.subject} #{statement.predicate} #{statement.object}")
    @sesame.has_statement? statement
  end
  def count
    @sesame.count
  end
  def fetch
    res=[]
    @sesame.each do |statement|
      @log.debug("Read: #{statement.subject} #{statement.predicate} #{statement.object}")
      res << statement
    end
    res
  end
end
