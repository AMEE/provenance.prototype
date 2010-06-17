package com.amee.provenance;

import junit.framework.TestCase;

public class rdf2dotTest extends TestCase {
    public void testDot1() throws Exception {
        AMEEOPMManager manager=new AMEEOPMManager("target/test-classes/ST-50.xml");
        manager.toDot();
    }
}
