<?xml version="1.0" encoding="UTF-8"?>
<?dynamic-document type="format" version="7.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xsl xs fn">

    <!-- Comment this line to debug --> <xsl:import href="/cernerbasiccontent/formats/futureapptsptfacing.xslt"/>
    <!-- Uncomment this line to debug <xsl:import href="../FutureApptsPtFacing.xslt"/> -->
    <!-- Comment out this line to debug--> <xsl:import href="/cernerbasiccontent/formats/en/addressfxn_en.xslt"/>
    <!-- Uncomment this line to debug <xsl:import href="AddressFxn_en.xslt"/> -->
    <!-- Comment this line to debug --><xsl:import href="/cernerbasiccontent/formats/en/dateformat_en.xslt"/>
    <!-- Uncomment this line to debug <xsl:import href="./dateformat_en.xslt" /> -->

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    <xsl:param as="xs:string" name="current-locale" select="'en_US'"/>

    <!-- Default string constants -->
	<xsl:variable name="Type">
        <xsl:value-of select="'Type:'"/>
    </xsl:variable>
	
    <xsl:variable name="When" as="xs:string">
        <xsl:value-of select="'When:'"/>
    </xsl:variable>

    <xsl:variable name="With" as="xs:string">
        <xsl:value-of select="'With:'"/>
    </xsl:variable>
    
    <xsl:variable name="Where" as="xs:string">
        <xsl:value-of select="'Where:'"/>
    </xsl:variable>

    <xsl:variable name="Contact" as="xs:string">
        <xsl:value-of select="'Contact Information'"/>
    </xsl:variable>

    <xsl:variable name="Status" as="xs:string">
        <xsl:value-of select="'Status:'"/>
    </xsl:variable>

    <xsl:variable name="NoStatus" as="xs:string">
        <xsl:value-of select="'No Data Available'"/>
    </xsl:variable>
	
	<xsl:variable name="VideoVisit" as="xs:string">
        <xsl:value-of select="'Video Visit'"/>
    </xsl:variable>

</xsl:stylesheet>
