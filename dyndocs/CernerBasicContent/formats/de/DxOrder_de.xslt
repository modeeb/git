<?xml version="1.0" encoding="UTF-8"?>
<?dynamic-document type="format" version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<!-- Comment this line to debug --><xsl:import href="/cernerbasiccontent/formats/dxorder.xslt"/>
	<!-- Uncomment this line to debug  <xsl:import href="../dxorder.xslt" /> -->
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	
	<!-- Locale defined for CommonFxn.xslt (If not defined, defaults to en_US, Value defined here overrides all other values) -->
	<xsl:param as="xs:string" name="current-locale" select="'de'"/>
	
	<!-- Strings defined for DxOrder.xslt, String values defined here override the default values defined in DxOrder.xslt -->
	<xsl:variable name="Ordered" as="xs:string">
		<xsl:value-of select="'Angefordert: '"/>
	</xsl:variable>
	
	<xsl:variable name="AdditionalOrders" as="xs:string">
		<xsl:value-of select="'Anforderungen: '"/>
	</xsl:variable>
	<xsl:variable name="Prn" as="xs:string">
		<xsl:value-of select="'Bei Bedarf'"/>
	</xsl:variable>
	<xsl:variable name="Refills" as="xs:string">
		<xsl:value-of select="'Neuverschreibungen'"/>
	</xsl:variable>
	<xsl:variable name="StartDate" as="xs:string">
        <xsl:value-of select="'Beginndatum: '"/>
    </xsl:variable>
	<xsl:variable name="Comma" as="xs:string">
        <xsl:value-of select="', '"/>
    </xsl:variable>
	
	<!-- displayConfirmation will be overwritten by the locale specific format. If true, confirmation status of diagnosis will be displayed -->
	<xsl:variable name="displayConfirmation" as="xs:boolean" select="true()"/>
	
	<!-- displayStartDate will be overwritten by the locale specific format. If true, start date of order will be displayed for single medication ingredient orders -->
	<xsl:variable name="displayStartDate" as="xs:boolean" select="false()"/>
</xsl:stylesheet>
