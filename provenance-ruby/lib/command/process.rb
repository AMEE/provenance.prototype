#describe a basic OPM process

prov :process do
  type OPM.Process
  qualify OPM.label,RDF::Literal.new(
    "#{comment.project}-#{comment.ticket} #{comment.comment}")
end

prov :base_in do
  subject comment.newuri
  type OPM.Used
  qualify OPM.effect,comment.uri
  qualify OPM.cause,args.shift
end

prov :base_out do
  subject comment.newuri
  type OPM.WasGeneratedBy
  qualify OPM.effect,args.shift
  qualify OPM.cause,comment.uri
end

prov :in do
  invoke :base_in
  qualify OPM.role,AMEE.input
end

prov :out_folder do
  invoke :base_out
  qualify OPM.role,AMEE.container
end

prov :out do
  invoke :base_out
  qualify OPM.role,AMEE.output
end