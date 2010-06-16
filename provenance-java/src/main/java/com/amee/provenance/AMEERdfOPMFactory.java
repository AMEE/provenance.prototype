package com.amee.provenance;

import org.openprovenance.elmo.RdfArtifact;
import org.openprovenance.elmo.RdfOPMFactory;
import org.openprovenance.model.ObjectFactory;
import org.openrdf.elmo.ElmoManager;
import org.openrdf.elmo.Entity;

import javax.xml.namespace.QName;

public class AMEERdfOPMFactory extends RdfOPMFactory {
    final ElmoManager mmanager;
    public AMEERdfOPMFactory(ObjectFactory o) {
        super(o);
        mmanager=null;
    }

    public AMEERdfOPMFactory(ObjectFactory o, ElmoManager manager) {       
        super(o, manager);
        mmanager=manager;
    }
     public RdfArtifact newArtifact(org.openprovenance.rdf.Artifact a) {
        QName qname=((Entity)a).getQName();
        RdfArtifact res=register(qname,new AMEERdfArtifact(mmanager,qname));
        addAccounts((org.openprovenance.rdf.AnnotationOrEdgeOrNode)a,res.getAccount());
        processAnnotations(a,res);
        return res;
    }
}
