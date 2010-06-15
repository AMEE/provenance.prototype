package com.amee.provenance;

import org.openprovenance.elmo.RdfOPMFactory;
import org.openprovenance.elmo.RdfObjectFactory;
import org.openprovenance.elmo.RdfValue;
import org.openprovenance.elmo.RepositoryHelper;
import org.openprovenance.model.OPMGraph;
import org.openprovenance.model.OPMSerialiser;
import org.openrdf.elmo.ElmoManager;
import org.openrdf.elmo.ElmoManagerFactory;
import org.openrdf.elmo.ElmoModule;
import org.openrdf.elmo.sesame.SesameManager;
import org.openrdf.elmo.sesame.SesameManagerFactory;
import org.openrdf.rio.RDFFormat;

import javax.xml.bind.JAXBException;
import javax.xml.namespace.QName;
import java.io.File;

public class AMEEOPMManager {

    ElmoManager manager;
    ElmoManagerFactory factory;
    RepositoryHelper rHelper;
    String filename;
    OPMGraph graph;
    static String NS="http://jira.amee.com/browse/ST-50/";

    public AMEEOPMManager(String afilename) throws Exception {
        filename=afilename;
        File file = new File(filename);
        // Construct manager, factory, helper.
        System.out.print("Hello! ");
        ElmoModule module = new ElmoModule();
        rHelper=new RepositoryHelper();
        rHelper.registerConcepts(module);
        factory = new SesameManagerFactory(module);
        manager = factory.createElmoManager();

        rHelper.readFromRDF(file,null,(SesameManager)manager,RDFFormat.RDFXML);

        for (org.openprovenance.rdf.Entity g :
                manager.findAll(org.openprovenance.rdf.OPMGraph.class))
        {
            System.out.print("Name: ");
            System.out.println(((org.openrdf.elmo.Entity) g).getQName());
        }

        QName qname = new QName(NS,"graph");


        org.openprovenance.rdf.OPMGraph gr=(org.openprovenance.rdf.OPMGraph)manager.find(qname);

        RdfOPMFactory oFactory=new RdfOPMFactory(new RdfObjectFactory(manager,NS),
                manager);

        graph=oFactory.newOPMGraph(gr);

    }

    public void convert() throws JAXBException {

        OPMSerialiser serial=OPMSerialiser.getThreadOPMSerialiser();
        serial.serialiseOPMGraph(new File(filename+".opm"),graph,true);


    }
}
