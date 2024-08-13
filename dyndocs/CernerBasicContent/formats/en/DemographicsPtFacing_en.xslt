<?xml version="1.0" encoding="UTF-8"?>
<?dynamic-document type="format" version="7.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:n="urn:com-cerner-patient-ehr:v3"
    exclude-result-prefixes="xsl xs fn n">
    <!-- Comment this line to debug --> <xsl:import href="/cernerbasiccontent/formats/demographicsptfacing.xslt"/>
    <!-- Uncomment this line to debug <xsl:import href="../demographicsptfacing.xslt" /> -->
    <!-- Comment this line to debug --><xsl:import href="/cernerbasiccontent/formats/en/dateformat_en.xslt"/>
    <!-- Uncomment this line to debug <xsl:import href="./dateformat_en.xslt" /> -->
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <!-- Locale defined for CommonFxn.xslt (If not defined, defaults to en_US, Value defined here overrides all other values) -->
    <xsl:param as="xs:string" name="current-locale" select="'en_US'"/>

    <!-- Strings defined for demographicsptfacing.xslt, String values defined here override the default values defined in demographicsptfacing.xslt -->
    <xsl:variable name="DOB" as="xs:string">
        <xsl:value-of select="'DOB:'"/>
    </xsl:variable>

    <xsl:variable name="MRN" as="xs:string">
        <xsl:value-of select="'MRN:'"/>
    </xsl:variable>

    <xsl:variable name="RegDtTm" as="xs:string">
        <xsl:value-of select="'Visit Date:'"/>
    </xsl:variable>
	
	<xsl:variable name="Facility" as="xs:string">
        <xsl:value-of select="'Facility:'"/>
    </xsl:variable>
	
	<xsl:variable name="FacilityPhone" as="xs:string">
        <xsl:value-of select="'Facility Phone:'"/>
    </xsl:variable>
	
	<xsl:variable name="NurseUnit" as="xs:string">
        <xsl:value-of select="'Nurse Unit:'"/>
    </xsl:variable>
	
	<xsl:variable name="NursePhone" as="xs:string">
        <xsl:value-of select="'Nurse Phone:'"/>
    </xsl:variable>
	
	<!-- overwrite isDisplayNurseUnit. If true, format will display the Nurse Unit and phone number if present -->
	<xsl:variable name="isDisplayNurseUnit" as="xs:boolean" select="false()"/>
	
	<!-- overwrite isDisplayFacility. If true, format will display the Facility and phone number if present -->
	<xsl:variable name="isDisplayFacility" as="xs:boolean" select="false()"/>

</xsl:stylesheet>
