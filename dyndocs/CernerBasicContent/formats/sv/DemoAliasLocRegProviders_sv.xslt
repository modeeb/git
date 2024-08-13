<?xml version="1.0" encoding="UTF-8"?>
<?dynamic-document type="format" version="7.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:n="urn:com-cerner-patient-ehr:v3"
	exclude-result-prefixes="xsl xs fn n">
	<!-- Comment this line to debug --> <xsl:import href="/cernerbasiccontent/formats/demoaliaslocregproviders.xslt"/>
	<!-- Uncomment this line to debug <xsl:import href="../demoaliaslocregproviders.xslt" /> -->
        <!-- Comment this line to debug --><xsl:import href="/cernerbasiccontent/formats/sv/dateformat_sv.xslt"/>
        <!-- Uncomment this line to debug <xsl:import href="./dateformat_sv.xslt" /> -->
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	
	<!-- Locale defined for CommonFxn.xslt (If not defined, defaults to en_US, Value defined here overrides all other values) -->
	<xsl:param as="xs:string" name="current-locale" select="'sv'"/>
	
	<!-- Strings defined for demoaliaslocregproviders.xslt, String values defined here override the default values defined in demoaliaslocregproviders.xslt -->
	<xsl:variable name="MRN" as="xs:string">
		<xsl:value-of select="'Folder-ID:'"/>
	</xsl:variable>
	
	<xsl:variable name="FIN" as="xs:string">
		<xsl:value-of select="'V&#229;rdkontakts-ID:'"/>
	</xsl:variable>
	
	<xsl:variable name="Location" as="xs:string">
		<xsl:value-of select="'Plats:'"/>
	</xsl:variable>
	
	<xsl:variable name="RegDtTm" as="xs:string">
		<xsl:value-of select="'Registreringsdatum/tid:'"/>
	</xsl:variable>
	
	<xsl:variable name="PCP" as="xs:string">
		<xsl:value-of select="'Ansvarig l&#228;kare:'"/>
	</xsl:variable>

	<xsl:variable name="AttendingPhysician" as="xs:string">
		<xsl:value-of select="'Behandlande l&#228;kare:'"/>
	</xsl:variable>
	
	<xsl:variable name="CommaSeparator" as="xs:string">
		<xsl:value-of select="', %s'"/>
	</xsl:variable>
	
</xsl:stylesheet>