package com.amee.provenance;

import org.openprovenance.model.*;

import java.io.InputStream;
import java.io.PrintStream;
import java.util.HashMap;

public class AMEEOPMToDot extends OPMToDot {
    public AMEEOPMToDot() {
        InputStream is=this.getClass().getResourceAsStream("/dotConfig.xml");
        init(is);
    }

    // changes the name used as dot's nodelabel to be quoted.

    public void emitNode(String name, HashMap<String,String> properties, PrintStream out) {
        StringBuffer sb=new StringBuffer();
        sb.append('"'+name+'"');
        emitProperties(sb,properties);
        out.println(sb.toString());
    }


    public void emitEdge(String src, String dest, HashMap<String,String> properties, PrintStream out, boolean directional) {
        StringBuffer sb=new StringBuffer();
        sb.append('"'+src+'"');
        if (directional) {
            sb.append(" -> ");
        } else {
            sb.append(" -- ");
        }
        sb.append('"'+dest+'"');
        emitProperties(sb,properties);
        out.println(sb.toString());
    }

    @Override
    public HashMap<String, String> addArtifactLabel(Artifact p, HashMap<String, String> properties) {
        properties= super.addArtifactLabel(p, properties);
        properties.put("href",p.getId());
        return properties;
    }

    @Override
    public HashMap<String, String> addProcessLabel(org.openprovenance.model.Process p, HashMap<String, String> properties) {
        properties= super.addProcessLabel(p, properties);
        properties.put("href",p.getId());
        return properties;
    }
}
