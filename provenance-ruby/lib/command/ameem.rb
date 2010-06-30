prov :ameem do
  invoke :process
  qualify OPM.type,AMEE.ameem
  path = args.shift
  invoke :in,"csv_files:#{path}"
  invoke :out,"amee:#{path}"
end
