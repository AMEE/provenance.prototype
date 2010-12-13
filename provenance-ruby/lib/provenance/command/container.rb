module Prov
  prov :assembled do
    # This process represents assembling several sources into a single artifact,
    # without change
    invoke :process
    qualify OPM.type,AMEE.assembly
  end

prov :container do
    invoke :base_out
    qualify OPM.role, AMEE.container
    label
  end

  prov :component do
    #This input role is used for things assembled into a prov:container
    invoke :base_in
    qualify OPM.role,AMEE.component
    label
  end
end