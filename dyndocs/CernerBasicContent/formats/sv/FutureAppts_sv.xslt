<?xml version="1.0" encoding="UTF-8"?>
<?dynamic-document type="format" version="7.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xsl xs fn">

    <!-- Comment this line to debug--> <xsl:import href="/cernerbasiccontent/formats/futureappts.xslt"/>
    <!-- Uncomment this line to debug <xsl:import href="../FutureAppts.xslt"/> -->
    <!-- Comment this line to debug --><xsl:import href="/cernerbasiccontent/formats/sv/dateformat_sv.xslt"/>
    <!-- Uncomment this line to debug <xsl:import href="./dateformat_sv.xslt" /> -->
    <!-- Comment out this line to debug--> <xsl:include href="/cernerbasiccontent/formats/sv/addressfxn_sv.xslt"/>
    <!-- Uncomment this line to debug <xsl:include href="AddressFxn_sv.xslt"/> -->

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    <xsl:param as="xs:string" name="current-locale" select="'sv'"/>

    <!-- Default string constants -->
    <xsl:variable name="Type">
        <xsl:value-of select="'Bes&#246;kstyp'"/>
    </xsl:variable>

    <xsl:variable name="When" as="xs:string">
        <xsl:value-of select="'N&#228;r'"/>
    </xsl:variable>

    <xsl:variable name="With" as="xs:string">
        <xsl:value-of select="'Med'"/>
    </xsl:variable>

    <xsl:variable name="Where" as="xs:string">
        <xsl:value-of select="'Var'"/>
    </xsl:variable>

    <xsl:variable name="Contact" as="xs:string">
        <xsl:value-of select="'Kontaktinformation'"/>
    </xsl:variable>

    <xsl:variable name="Status" as="xs:string">
        <xsl:value-of select="'Status'"/>
    </xsl:variable>

    <xsl:variable name="NoStatus" as="xs:string">
        <xsl:value-of select="'Inga data tillg&#228;ngliga'"/>
    </xsl:variable>

</xsl:stylesheet>