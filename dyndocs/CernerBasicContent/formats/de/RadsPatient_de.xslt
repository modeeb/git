<?xml version="1.0" encoding="UTF-8"?>
<?dynamic-document type="format" version="7.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://www.w3.org/2005/xpath-functions">

	<!-- Comment this line to debug --> <xsl:import href="/cernerbasiccontent/formats/rads.xslt"/>
	<!-- Uncomment this line to debug <xsl:import href="../rads.xslt" /> -->
	
	<!-- Values defined in this file override the default values defined in Rads.xslt, RadsCommon.xslt and CommonFxn.xslt-->
	<xsl:import href="/cernerbasiccontent/formats/de/radsi18ncommon_de.xslt" />
	
	<!-- overwrite showAllCompletedResults. If true, format will display all completed rad results without the 24 hour limit. -->
	<xsl:variable name="showAllCompletedResults" as="xs:boolean" select="true()"/>

</xsl:stylesheet>