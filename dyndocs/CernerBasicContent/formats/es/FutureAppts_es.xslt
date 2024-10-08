<?xml version="1.0" encoding="UTF-8"?>
<?dynamic-document type="format" version="7.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" exclude-result-prefixes="xsl xs fn">

    <!-- Comment this line to debug--> <xsl:import href="/cernerbasiccontent/formats/futureappts.xslt"/>
    <!-- Uncomment this line to debug <xsl:import href="../FutureAppts.xslt"/> -->
    <!-- Comment this line to debug --><xsl:import href="/cernerbasiccontent/formats/es/dateformat_es.xslt"/>
    <!-- Uncomment this line to debug <xsl:import href="./dateformat_es.xslt" /> -->
    <!-- Comment out this line to debug--> <xsl:include href="/cernerbasiccontent/formats/es/addressfxn_es.xslt"/>
    <!-- Uncomment this line to debug <xsl:include href="AddressFxn_es.xslt"/> -->

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    <xsl:param as="xs:string" name="current-locale" select="'es'"/>

    <!-- Default string constants -->
    <xsl:variable name="Type">
        <xsl:value-of select="'Tipo de cita'"/>
    </xsl:variable>

    <xsl:variable name="When" as="xs:string">
        <xsl:value-of select="'Cuando'"/>
    </xsl:variable>

    <xsl:variable name="With" as="xs:string">
        <xsl:value-of select="'Con'"/>
    </xsl:variable>

    <xsl:variable name="Where" as="xs:string">
        <xsl:value-of select="'D&#243;nde'"/>
    </xsl:variable>

    <xsl:variable name="Contact" as="xs:string">
        <xsl:value-of select="'Informaci&#243;n de contacto'"/>
    </xsl:variable>

    <xsl:variable name="Status" as="xs:string">
        <xsl:value-of select="'Estado'"/>
    </xsl:variable>

    <xsl:variable name="NoStatus" as="xs:string">
        <xsl:value-of select="'No hay datos disponibles'"/>
    </xsl:variable>

</xsl:stylesheet>
