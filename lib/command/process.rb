#describe a basic OPM process

prov :process do
  type OPM.process
end

prov :download do
  type OPM.process
  type AMEE.download
end

prov :via do
  subject comment.newuri
  type OPM.wasDerivedFrom
  qualify OPM.effect,comment.uri
  qualify OPM.cause,args.shift
  qualify OPM.role,AMEE.via
end

prov :browser do
  subject comment.newuri
  type OPM.wasGeneratedBy
  qualify OPM.effect,args.shift
  qualify OPM.cause,comment.uri
  qualify OPM.role,AMEE.browser
end

prov :in do
  subject comment.newuri
  type OPM.wasDerivedFrom
  qualify OPM.effect,comment.uri
  qualify OPM.cause,args.shift
end

prov :out_folder do
  subject comment.newuri
  type OPM.wasGeneratedBy
  qualify OPM.effect,args.shift
  qualify OPM.cause,comment.uri
end

prov :out do
  subject comment.newuri
  type OPM.wasGeneratedBy
  qualify OPM.effect,args.shift
  qualify OPM.cause,comment.uri
end