<?xml version="1.0" encoding="UTF-8"?>
<?dynamic-document type="format" version="7.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<!-- Comment this line to debug --> <xsl:import href="/cernerbasiccontent/formats/medsrecsimplified.xslt"/>
	<!-- Uncomment this line to debug <xsl:import href="../medsrecsimplified.xslt" /> -->
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	
	<!-- Locale defined for CommonFxn.xslt (If not defined, defaults to en_US, Value defined here overrides all other values) -->
	<xsl:param as="xs:string" name="current-locale" select="'sv'"/>
	
	<!-- Strings defined for medsrec.xslt, String values defined here override the default values defined in medsrecsimplified.xslt -->
	
	<xsl:variable name="StopTaking" as="xs:string">
		<xsl:value-of select="'Sluta ta dessa l&#228;kemedel'"/>
	</xsl:variable>
	
	<xsl:variable name="ContactPhysician" as="xs:string">
		<xsl:value-of select="'Kontakta f&#246;rskrivande l&#228;kare vid fr&#229;gor eller problem'"/>
	</xsl:variable>
	
</xsl:stylesheet>