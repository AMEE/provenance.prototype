module Prov
  prov :by do
    qualify OPM.wasControlledBy,args.first
    statement args.first,RDF.type,OPM.Agent
    statement graph,OPM.hasAgent,args.first
  end
end
