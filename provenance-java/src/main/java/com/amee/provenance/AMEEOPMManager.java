package com.amee.provenance;

import org.openprovenance.elmo.*;
import org.openprovenance.model.OPMGraph;
import org.openprovenance.model.OPMSerialiser;
import org.openprovenance.model.Artifact;
import org.openrdf.elmo.ElmoManager;
import org.openrdf.elmo.ElmoManagerFactory;
import org.openrdf.elmo.ElmoModule;
import org.openrdf.elmo.Entity;
import org.openrdf.elmo.sesame.SesameManager;
import org.openrdf.elmo.sesame.SesameManagerFactory;
import org.openrdf.rio.RDFFormat;
import org.apache.commons.io.FilenameUtils;

import javax.xml.bind.JAXBException;
import javax.xml.namespace.QName;
import java.io.File;
import java.io.IOException;

import static org.apache.commons.io.FilenameUtils.removeExtension;

public class AMEEOPMManager {

    ElmoManager manager;
    ElmoManagerFactory factory;
    RepositoryHelper rHelper;
    String filename;
    OPMGraph graph;
    static String NS="http://jira.amee.com/browse/ST-50/";
    public final static String USAGE="ameeopm file (reading file.xml resulting in file.opm.xml, file.dot, file.pdf)";    


    public static void main(String [] args) throws Exception {
        if ((args==null) || (args.length==0) || (args.length>4)) {
            System.out.println(USAGE);
            return;
        }
        AMEEOPMManager aom= new AMEEOPMManager(args[0]);
        aom.toXML();
        aom.toDot();
    }

    public AMEEOPMManager(String afilename) throws Exception {
        filename=removeExtension(afilename);
        File file = new File(afilename);
        // Construct manager, factory, helper.
        ElmoModule module = new ElmoModule();
        module.addConcept(org.openprovenance.rdf.Entity.class);
        module.addConcept(org.openprovenance.rdf.UsedOrWasControlledByOrWasGeneratedBy.class);
        module.addConcept(org.openprovenance.rdf.Annotable.class);
        module.addConcept(org.openprovenance.rdf.AnnotationOrEdgeOrNode.class);
        module.addConcept(org.openprovenance.rdf.EventEdge.class);
        module.addConcept(org.openprovenance.rdf.PropertyOrRole.class);
        rHelper=new RepositoryHelper();
        rHelper.registerConcepts(module);
        factory = new SesameManagerFactory(module);
        manager = factory.createElmoManager();

        rHelper.readFromRDF(file,null,(SesameManager)manager,RDFFormat.RDFXML);
        QName qname=null;
        for (org.openprovenance.rdf.OPMGraph g :
                manager.findAll(org.openprovenance.rdf.OPMGraph.class))
        {
            System.out.print("Graph Name: ");
            qname=((org.openrdf.elmo.Entity) g).getQName();
            System.out.println(qname);
        }

        org.openprovenance.rdf.OPMGraph gr=(org.openprovenance.rdf.OPMGraph)manager.find(qname);

        RdfOPMFactory oFactory=new AMEERdfOPMFactory(new RdfObjectFactory(manager,NS),
                manager);

        graph=oFactory.newOPMGraph(gr);

        for (Artifact art : graph.getArtifacts().getArtifact()) {
            //System.out.println(((RdfArtifact) art).getQName());
        }
    }

    public void toXML() throws JAXBException {

        OPMSerialiser serial=OPMSerialiser.getThreadOPMSerialiser();
        serial.serialiseOPMGraph(new File(filename+".opm"),graph,true);
    }

    public void toDot() throws IOException {
        AMEEOPMToDot o2d=new AMEEOPMToDot();
        o2d.convert(graph,filename+".dot",filename+".pdf");
    }
}
