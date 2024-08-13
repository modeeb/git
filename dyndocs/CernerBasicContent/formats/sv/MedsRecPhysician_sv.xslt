<?xml version="1.0" encoding="UTF-8"?><?dynamic-document type="format" version="8.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	exclude-result-prefixes="xsl xs">
	
	<!-- Comment this line to debug  --> <xsl:import href="/cernerbasiccontent/formats/medsrecphysician.xslt"/>
	<!-- Uncomment this line to debug <xsl:import href="../medsrecphysician.xslt" />   -->
	
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	<!-- Locale defined for CommonFxn.xslt (If not defined, defaults to en_US, Value defined here overrides all other values) -->
	<xsl:param as="xs:string" name="current-locale" select="'sv'"/>

	<xsl:variable name="New" as="xs:string">
		<xsl:value-of select="'Ny'"/>
	</xsl:variable>

	<xsl:variable name="Changed" as="xs:string">
		<xsl:value-of select="'&#196;ndrad'"/>
	</xsl:variable>

	<xsl:variable name="Unchanged" as="xs:string">
		<xsl:value-of select="'Of&#246;r&#228;ndrad'"/>
	</xsl:variable>

	<xsl:variable name="StopTaking" as="xs:string">
		<xsl:value-of select="'Avslutad'"/>
	</xsl:variable>
</xsl:stylesheet>