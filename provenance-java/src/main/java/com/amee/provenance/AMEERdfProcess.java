package com.amee.provenance;

import org.openprovenance.elmo.RdfProcess;
import org.openrdf.elmo.ElmoManager;

import javax.xml.namespace.QName;

public class AMEERdfProcess extends RdfProcess {

    public AMEERdfProcess(ElmoManager manager, String prefix) {
        super(manager, prefix);
    }

    public AMEERdfProcess(ElmoManager manager, QName qname) {
        super(manager, qname);
        super.setId(qname.getNamespaceURI()+qname.getLocalPart());
    }
}
