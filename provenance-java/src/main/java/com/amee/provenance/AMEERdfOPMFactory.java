package com.amee.provenance;

import org.openprovenance.elmo.RdfArtifact;
import org.openprovenance.elmo.RdfOPMFactory;
import org.openprovenance.elmo.RdfProcess;
import org.openprovenance.model.ObjectFactory;
import org.openprovenance.rdf.*;
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

    @Override
    public RdfArtifact newArtifact(org.openprovenance.rdf.Artifact a) {
        QName qname=((Entity)a).getQName();
        RdfArtifact res=register(qname,new AMEERdfArtifact(mmanager,qname));
        addAccounts(a,res.getAccount());
        processAnnotations(a,res);
        return res;
    }

    @Override
    public RdfProcess newProcess(org.openprovenance.rdf.Process a) {
        QName qname=((Entity)a).getQName();
        RdfProcess res=register(qname, new AMEERdfProcess(mmanager,qname));
        addAccounts(a,res.getAccount());
        processAnnotations(a,res);
        return res;
    }
}
