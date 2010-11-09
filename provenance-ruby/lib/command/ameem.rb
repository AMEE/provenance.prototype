prov :ameem do
  invoke :process
  qualify OPM.type,AMEE.ameem
  path = args.first
  label "amee:#{path}",path
  invoke :base_in,"csv_files:#{path}"
  qualify OPM.role,AMEE.input
  invoke :base_out,"amee:#{path}"
  qualify OPM.role,AMEE.output
  subject "amee:#{path}"

  type AMEE.category
end
