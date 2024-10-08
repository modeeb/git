<?xml version="1.0" encoding="UTF-8"?>
<?dynamic-document type="format" version="7.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:n="urn:com-cerner-patient-ehr:v3">
	<!-- Comment this line to debug --> <xsl:import href="/cernerbasiccontent/formats/followupptfacing.xslt"/>
	<!-- Uncomment this line to debug <xsl:import href="../followupptfacing.xslt" /> -->
	<!-- Comment this line to debug --><xsl:import href="/cernerbasiccontent/formats/es/dateformat_es.xslt"/>
	<!-- Uncomment this line to debug <xsl:import href="./dateformat_es.xslt" /> -->
	<!-- Comment this line to debug-->  <xsl:include href="/cernerbasiccontent/formats/es/addressfxn_es.xslt"/>
	<!-- Uncomment this line to debug <xsl:import href="../addressfxn_es.xslt" /> -->
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	
	<!-- Locale defined for CommonFxn.xslt (If not defined, defaults to en_US, Value defined here overrides all other values) -->
	<xsl:param as="xs:string" name="current-locale" select="'es'"/>
	
	<!-- Strings defined for followup.xslt, String values defined here override the default values defined in followupptfacing.xslt -->
	<xsl:variable name="Why" as="xs:string">
		<xsl:value-of select="'Raz&#243;n:'"/>
	</xsl:variable>
	
	<xsl:variable name="With" as="xs:string">
		<xsl:value-of select="'Con'"/>
	</xsl:variable>
	
	<xsl:variable name="Where" as="xs:string">
		<xsl:value-of select="'Donde:'"/>
	</xsl:variable>
	
	<xsl:variable name="When" as="xs:string">
		<xsl:value-of select="'Cuando:'"/>
	</xsl:variable>
	
	<xsl:variable name="Day" as="xs:string">
		<xsl:value-of select="'d&#237;a'"/>
	</xsl:variable>
	
	<xsl:variable name="Days" as="xs:string">
		<xsl:value-of select="'d&#237;as'"/>
	</xsl:variable>
	
	<xsl:variable name="Week" as="xs:string">
		<xsl:value-of select="'semana'"/>
	</xsl:variable>
	
	<xsl:variable name="Weeks" as="xs:string">
		<xsl:value-of select="'semanas'"/>
	</xsl:variable>
	
	<xsl:variable name="Month" as="xs:string">
		<xsl:value-of select="'mes'"/>
	</xsl:variable>
	
	<xsl:variable name="Months" as="xs:string">
		<xsl:value-of select="'meses'"/>
	</xsl:variable>
	
	<xsl:variable name="Year" as="xs:string">
		<xsl:value-of select="'a&#241;o'"/>
	</xsl:variable>
	
	<xsl:variable name="Years" as="xs:string">
		<xsl:value-of select="'a&#241;os'"/>
	</xsl:variable>
	
	<xsl:variable name="Within" as="xs:string">
		<xsl:value-of select="'Dentro de'"/>
	</xsl:variable>
	
	<!-- For example, "'%1$s %2$s'" will output Within 1 to 2 days while "'%2$s %1$s'" will output 1 to 2 days Within -->
	<xsl:variable name="WithinSomeTimeFormatter" as="xs:string">
		<xsl:value-of select="'%1$s %2$s'"/>
	</xsl:variable>
	
	<xsl:variable name="In" as="xs:string">
		<xsl:value-of select="'En'"/>
	</xsl:variable>
	
	<!-- For example, "'%1$s %2$s %3$s '" will output In 5 days while "'%2$s %1$s %3$s '" will output 5 In days -->
	<xsl:variable name="InSomeTimeFormatter" as="xs:string">
		<xsl:value-of select="'%1$s %2$s %3$s '"/>
	</xsl:variable>
	
	<xsl:variable name="OnlyIfNeededBeginning" as="xs:string">
		<xsl:value-of select="'Solo si es necesario'"/> <!-- Used in the beginning of a sentence or phrase -->
	</xsl:variable>
	
	<xsl:variable name="OnlyIfNeededNotBeginning" as="xs:string">
		<xsl:value-of select="', solo si es necesario'"/> <!-- Used in the middle of a sentence or phrase -->
	</xsl:variable>
	
	<xsl:variable name="Contact" as="xs:string">
		<xsl:value-of select="'Informaci&#243;n de contacto'"/>
	</xsl:variable>
	
	<xsl:variable name="Comments" as="xs:string">
		<xsl:value-of select="'Instrucciones adicionales'"/>
	</xsl:variable>
	
	<xsl:variable name="FollowupWith" as="xs:string">
		<xsl:value-of select="'Realizar seguimiento con'"/>
	</xsl:variable>
	
</xsl:stylesheet>
