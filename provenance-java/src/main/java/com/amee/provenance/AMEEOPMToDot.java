package com.amee.provenance;

import org.openprovenance.model.OPMToDot;

import java.io.PrintStream;
import java.util.HashMap;

public class AMEEOPMToDot extends OPMToDot {
    public AMEEOPMToDot() {
    }

    public AMEEOPMToDot(boolean withRoleFlag) {
        super(withRoleFlag);
    }

    public AMEEOPMToDot(String configurationFile) {
        super(configurationFile);
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
}
