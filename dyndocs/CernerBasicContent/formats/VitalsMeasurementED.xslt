<?xml version="1.0" encoding="UTF-8"?>
<?dynamic-document type="format" version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:n="urn:com-cerner-patient-ehr:v3"
	exclude-result-prefixes="xsl xs n">

	<!-- Required to include vitalsmeasurementcommon.xslt -->
	<!-- Comment this line to debug --><xsl:import href="/cernerbasiccontent/formats/vitalsmeasurementcommon.xslt" />
	<!-- Uncomment this line to debug <xsl:import href="vitalsmeasurementcommon.xslt" /> -->
	
	<!-- Setting this variable to true will display only Vitals ED. This is required as there is a common vitals format
		 shared across all different vitals displays -->
	<xsl:variable name="bIncludeEDVitals" as="xs:boolean" select="true()"/>
	
</xsl:stylesheet>
