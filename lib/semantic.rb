#wrapper class for Sesame or other semantic libraries
#to give potential for multiple libraries to have same signature to our code

class Semantic
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

  class NotSupported < Exception

  end
end

class Semantic::Sesame < Semantic
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
end
