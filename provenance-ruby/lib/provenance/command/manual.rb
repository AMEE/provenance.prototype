module Prov
  prov :manual do
    invoke :process
    qualify OPM.type,AMEE.manual
  end
end