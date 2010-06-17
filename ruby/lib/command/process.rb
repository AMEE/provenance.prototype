#describe a basic OPM process

prov :process do
  type OPM.Process
  qualify OPM.label,RDF::Literal.new(
    "#{comment.project}-#{comment.issue} #{comment.comment}")
end

prov :download do
  type OPM.Process
  qualify OPM.label,RDF::Literal.new(
    "download #{comment.project}-#{comment.issue} #{comment.comment}")
  #qualify OPM.type,AMEE.download
end

prov :via do
  subject comment.newuri
  type OPM.Used
  qualify OPM.effect,comment.uri
  qualify OPM.cause,args.shift
  qualify OPM.role,AMEE.via
end

prov :browser do
  subject comment.newuri
  type OPM.Used
  qualify OPM.effect,comment.uri
  qualify OPM.cause,args.shift
  qualify OPM.role,AMEE.browser
end

prov :in do
  subject comment.newuri
  type OPM.Used
  qualify OPM.effect,comment.uri
  qualify OPM.cause,args.shift
  qualify OPM.role,AMEE.input
end

prov :out_folder do
  subject comment.newuri
  type OPM.WasGeneratedBy
  #qualify OPM.type,AMEE.outfolder
  qualify OPM.effect,args.shift
  qualify OPM.cause,comment.uri
  qualify OPM.role,AMEE.container
end

prov :out do
  subject comment.newuri
  type OPM.WasGeneratedBy
  qualify OPM.effect,args.shift
  qualify OPM.cause,comment.uri
  qualify OPM.role,AMEE.output
end