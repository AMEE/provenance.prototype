module Prov
  prov :calculation do
    invoke :process
    qualify OPM.type,AMEE.calculation
  end

  prov :numeric do
    invoke :base_in
    qualify OPM.role,AMEE.numeric
    label
  end
end
