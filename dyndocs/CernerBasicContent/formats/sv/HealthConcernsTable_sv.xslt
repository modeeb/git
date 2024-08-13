<?xml version="1.0" encoding="UTF-8"?>
<?dynamic-document type="format" version="7.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    xmlns:cdocfx="urn:com-cerner-physician-documentation-functions"
    xmlns:n="urn:com-cerner-patient-ehr:v3" 
    xmlns:dd="DynamicDocumentation"
    exclude-result-prefixes="xsl xs fn cdocfx n dd">
    
    <!-- Comment this line to debug--> <xsl:import href="/cernerbasiccontent/formats/healthconcernstable.xslt"/>
	<!-- Uncomment this line to debug <xsl:import href="../healthconcernstable.xslt" /> -->
	
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	
	<!-- Locale defined for CommonFxn.xslt (If not defined, defaults to en_US, Value defined here overrides all other values) -->
	<xsl:param as="xs:string" name="current-locale" select="'sv'"/>

	<!-- Strings defined for HealthConcernsTable.xslt, String values defined here override the default values defined in HealthConcernsTable.xslt -->
	<xsl:variable name="descriptionHeading" as="xs:string" select="'Beskrivning'"/>
	<xsl:variable name="onsetHeading" as="xs:string" select="'Debutdatum'"/>
	<xsl:variable name="sourceHeading" as="xs:string" select="'K&#228;lla'"/>
	<xsl:variable name="categoryHeading" as="xs:string" select="'Kategori'"/>
	<xsl:variable name="commentHeading" as="xs:string" select="'Kommentar'"/>
	<xsl:variable name="DATE_SEQUENCE" as="xs:string" select="'[Y0001]-[M01]-[D01]'"/>

</xsl:stylesheet>