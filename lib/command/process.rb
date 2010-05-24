#describe a basic OPM process

prov :process do
  type OPM.process
end

prov :in do
  subject comment.newuri
  type OPM.wasDerivedFrom
  qualify OPM.effect,comment.uri
  qualify OPM.cause,args.shift
end

prov :out do
  subject comment.newuri
  type OPM.wasGeneratedBy
  qualify OPM.effect,args.shift
  qualify OPM.cause,comment.uri
end