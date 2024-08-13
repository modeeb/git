<?xml version="1.0" encoding="UTF-8"?>
<?dynamic-document type="format" version="7.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<!-- Comment this line to debug --> <xsl:import href="/cernerbasiccontent/formats/fr/patcaremeasurement_namevalue_fr.xslt"/>
	<!-- Uncomment this line to debug <xsl:import href="./patcaremeasurement_namevalue_fr.xslt"/> --> 
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	
	<!-- Locale defined for CommonFxn.xslt (If not defined, defaults to en_US, Value defined here overrides all other values) -->
	<xsl:param as="xs:string" name="current-locale" select="'fr'"/>
	
	<!-- Strings defined for patcaremeasurement_namevalue.xslt, String values defined here override the default values defined in patcaremeasurement_namevalue.xslt -->
	<xsl:variable name="ShowComments" as="xs:boolean">
		<xsl:value-of select="false()"/>
	</xsl:variable>
</xsl:stylesheet>
