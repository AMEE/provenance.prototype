#describe a basic OPM process
module Prov
  prov :process do
    type OPM.Process
    qualify OPM.label,RDF::Literal.new(
      "#{prov_block.label}")
  end

  prov :base_in do
    subject prov_block.newuri
    type OPM.Used
    qualify OPM.effect,prov_block.uri
    qualify OPM.cause,args.first
  end

  prov :base_out do
    subject prov_block.newuri
    type OPM.WasGeneratedBy
    qualify OPM.effect,args.first
    qualify OPM.cause,prov_block.uri
  end

  prov :in do
    invoke :base_in
    qualify OPM.role,AMEE.input
    label
  end

  prov :out_folder do
    invoke :base_out
    qualify OPM.role,AMEE.container
    label
  end

  prov :out do
    invoke :base_out
    qualify OPM.role,AMEE.output
    label
  end
end