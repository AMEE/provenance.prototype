package com.amee.provenance;

import com.amee.provenance.AMEEOPMManager;
import junit.framework.TestCase;


public class rdf2xmlTest extends TestCase {
    public void testConversion1() throws Exception {
        AMEEOPMManager manager=new AMEEOPMManager("target/test-classes/ST-50.xml");
        manager.convert();
    }
}
