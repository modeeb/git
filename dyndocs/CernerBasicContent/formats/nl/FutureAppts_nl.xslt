<?xml version="1.0" encoding="UTF-8"?>
<?dynamic-document type="format" version="7.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xsl xs fn">

    <!-- Comment this line to debug--> <xsl:import href="/cernerbasiccontent/formats/futureappts.xslt"/>
    <!-- Uncomment this line to debug <xsl:import href="../FutureAppts.xslt"/> -->
    <!-- Comment this line to debug --><xsl:import href="/cernerbasiccontent/formats/nl/dateformat_nl.xslt"/>
    <!-- Uncomment this line to debug <xsl:import href="./dateformat_nl.xslt" /> -->
    <!-- Comment out this line to debug--> <xsl:include href="/cernerbasiccontent/formats/nl/addressfxn_nl.xslt"/>
    <!-- Uncomment this line to debug <xsl:include href="AddressFxn_nl.xslt"/> -->

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    <xsl:param as="xs:string" name="current-locale" select="'nl'"/>

    <!-- Default string constants -->
    <xsl:variable name="Type">
        <xsl:value-of select="'Afspraak type'"/>
    </xsl:variable>

    <xsl:variable name="When" as="xs:string">
        <xsl:value-of select="'Wanneer'"/>
    </xsl:variable>

    <xsl:variable name="With" as="xs:string">
        <xsl:value-of select="'Met'"/>
    </xsl:variable>

    <xsl:variable name="Where" as="xs:string">
        <xsl:value-of select="'Waar'"/>
    </xsl:variable>

    <xsl:variable name="Contact" as="xs:string">
        <xsl:value-of select="'Contactinformatie'"/>
    </xsl:variable>

    <xsl:variable name="Status" as="xs:string">
        <xsl:value-of select="'Status'"/>
    </xsl:variable>

    <xsl:variable name="NoStatus" as="xs:string">
        <xsl:value-of select="'Geen gegevens beschikbaar'"/>
    </xsl:variable>

</xsl:stylesheet>
