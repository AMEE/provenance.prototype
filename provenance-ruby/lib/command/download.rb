prov :download do
  invoke :process
  qualify OPM.type,AMEE.download
end

prov :via do
  invoke :base_in
  qualify OPM.role,AMEE.via
end

prov :browser do
  invoke :base_in
  qualify OPM.role,AMEE.browser
end
