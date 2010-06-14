#describe a basic OPM process

prov :process do
  type OPM.Process
  qualify OPM.account,comment.issue_uri
end

prov :download do
  type OPM.Process
  #type AMEE.Download
  qualify OPM.account,comment.issue_uri
end

prov :via do
  subject comment.newuri
  type OPM.WasDerivedFrom
  qualify OPM.effect,comment.uri
  qualify OPM.cause,args.shift
  qualify OPM.role,AMEE.via
  qualify OPM.account,comment.issue_uri
end

prov :browser do
  subject comment.newuri
  type OPM.WasGeneratedBy
  qualify OPM.effect,args.shift
  qualify OPM.cause,comment.uri
  qualify OPM.role,AMEE.browser
  qualify OPM.account,comment.issue_uri
end

prov :in do
  subject comment.newuri
  type OPM.WasDerivedFrom
  qualify OPM.effect,comment.uri
  qualify OPM.cause,args.shift
  qualify OPM.account,comment.issue_uri
end

prov :out_folder do
  subject comment.newuri
  type OPM.WasGeneratedBy
  qualify OPM.effect,args.shift
  qualify OPM.cause,comment.uri
  qualify OPM.account,comment.issue_uri
end

prov :out do
  subject comment.newuri
  type OPM.WasGeneratedBy
  qualify OPM.effect,args.shift
  qualify OPM.cause,comment.uri
  qualify OPM.account,comment.issue_uri
end