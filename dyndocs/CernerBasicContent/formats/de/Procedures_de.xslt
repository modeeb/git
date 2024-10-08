<?xml version="1.0" encoding="UTF-8"?>
<?dynamic-document type="format" version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<!-- Comment this line to debug --><xsl:import href="/cernerbasiccontent/formats/procedures.xslt"/>
	<!-- Uncomment this line to debug <xsl:import href="../Procedures.xslt" /> -->
	<!-- Comment this line to debug --><xsl:import href="/cernerbasiccontent/formats/de/dateformat_de.xslt"/>
	<!-- Uncomment this line to debug <xsl:import href="./dateformat_de.xslt" /> -->
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	
	<!-- Locale defined for CommonFxn.xslt (If not defined, defaults to en_US, Value defined here overrides all other values) -->
	<xsl:param as="xs:string" name="current-locale" select="'de'"/>
	
	<!-- Strings defined for Procedures.xslt, String values defined here override the default values defined in Procedures.xslt -->
	<xsl:variable name="WeekOf" as="xs:string">
		<xsl:value-of select="'Woche von %s'"/>
	</xsl:variable>

	<!-- Procedure display format with service date: "[loose-name-display] ([service date])" -->
	<xsl:variable name="DisplayWithServiceDt" as="xs:string">
		<xsl:value-of select="'%s (%s)'"/>
	</xsl:variable>

	<xsl:variable name="ServiceDtLabel" as="xs:string">
		<xsl:value-of select="' (%s) '"/>
	</xsl:variable>
	
	<xsl:variable name="LateralityLabel" as="xs:string">
		<xsl:value-of select="' - %s '"/>
	</xsl:variable>
	
	<xsl:variable name="RelatedDiagnosisLabel" as="xs:string">
		<xsl:value-of select="' Zugeh&#246;rige Diagnose:  %s'"/>
	</xsl:variable>
	
	<xsl:variable name="CommentsLabel" as="xs:string">
		<xsl:value-of select="'Kommentare:  %s'"/>
	</xsl:variable>
	
	<xsl:variable name="CommentsSeparator" as="xs:string">
		<xsl:value-of select="'; '"/>
	</xsl:variable>
	
	<xsl:variable name="ShowComments" as="xs:boolean">
		<xsl:value-of select="false()"/>
	</xsl:variable>

</xsl:stylesheet>
