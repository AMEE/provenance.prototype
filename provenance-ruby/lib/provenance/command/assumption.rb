module Prov
  
  prov :assumption do
    #This input role is used for things assembled into a prov:container
    invoke :base_in
    qualify OPM.role,AMEE.assumption
    label
  end
end