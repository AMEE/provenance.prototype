module Prov
  prov :ameem do
    invoke :process
    qualify OPM.type,AMEE.ameem
    invoke :by,author #safe to assume that most of the time, the
    #amee person stating the account is also the person who did the upload
    path = args.first
    label "amee:#{path}",path
    invoke :base_in,"csv_files:#{path}"
    qualify OPM.role,AMEE.input
    invoke :base_out,"amee:#{path}"
    qualify OPM.role,AMEE.output
    subject "amee:#{path}"
    type AMEE.category
  end
end