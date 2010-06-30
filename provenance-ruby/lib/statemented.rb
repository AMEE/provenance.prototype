module Statemented
  include RDF
  def statement(s,v,o)
    parsed_subjects=Parser[s]
    parsed_objects=Parser[o]
    parsed_verbs=Parser[v]
    parsed_subjects.each do |ps|
      parsed_verbs.each do |pv|
        parsed_objects.each do |po|
          triple= Statement.new(ps,pv,po)
          $log.debug("Created statement #{triple}")
          @triples << triple
        end
      end
    end

  end
end
