package com.amee.provenance;

import org.openprovenance.elmo.RdfArtifact;
import org.openrdf.elmo.ElmoManager;

import javax.xml.namespace.QName;


public class AMEERdfArtifact extends RdfArtifact {
    public AMEERdfArtifact(ElmoManager manager, String prefix) {
        super(manager, prefix);
    }

    public AMEERdfArtifact(ElmoManager manager, QName qname) {
        super(manager, qname);
        super.setId(qname.getNamespaceURI()+qname.getLocalPart());
    }
}
