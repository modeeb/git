<?xml version="1.0" encoding="UTF-8"?>
<?dynamic-document type="format" version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<!-- Comment this line to debug --><xsl:import href="/cernerbasiccontent/formats/familyhistory.xslt"/>
	<!-- Uncomment this line to debug <xsl:import href="../familyhistory.xslt" /> -->
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	
	<!-- Locale defined for CommonFxn.xslt (If not defined, defaults to en_US, Value defined here overrides all other values) -->
	<xsl:param as="xs:string" name="current-locale" select="'nl'"/>
	
	<!-- Strings defined for familyhistory.xslt, String values defined here override the default values defined in familyhistory.xslt -->
	<xsl:variable name="PatientAdopted" as="xs:string">
		<xsl:value-of select="'Pati&#235;nt is geadopteerd'"/>
	</xsl:variable>
	
	<xsl:variable name="UnableToObtain" as="xs:string">
		<xsl:value-of select="'Kan familieanamnese niet verkrijgen'"/>
	</xsl:variable>
	
	<xsl:variable name="HistoryNegative" as="xs:string">
		<xsl:value-of select="'Familieanamnese negatief'"/>
	</xsl:variable>
	
	<xsl:variable name="HistoryUnknown" as="xs:string">
		<xsl:value-of select="'Familieanamnese onbekend'"/>
	</xsl:variable>
	
	<xsl:variable name="DiagnosedDisplay" as="xs:string">
		<xsl:value-of select="' (Diagnose %s)'"/>
	</xsl:variable>
	
	<xsl:variable name="DiagnosedAtDisplay" as="xs:string">
		<xsl:value-of select="' (Diagnose op %s)'"/>
	</xsl:variable>
	
	<xsl:variable name="ConditionPersonListSeparator" as="xs:string">
		<xsl:value-of select="'%s: '"/>
	</xsl:variable>
	
	<xsl:variable name="FamilyListOnlyOne" as="xs:string">
		<xsl:value-of select="'%s.'"/>
	</xsl:variable>
	
	<xsl:variable name="FamilyListSeparator" as="xs:string">
		<xsl:value-of select="', %s'"/>
	</xsl:variable>
	
	<xsl:variable name="FamilyListEnd" as="xs:string">
		<xsl:value-of select="' en %s.'"/>
	</xsl:variable>
	
	<xsl:variable name="FamilyMemberDisp" as="xs:string">
		<xsl:value-of select="'%s%s'"/>
	</xsl:variable>
	
	<xsl:variable name="NegConditionDisplay" as="xs:string">
		<xsl:value-of select="'Negatief: '"/>
	</xsl:variable>
	
	<xsl:variable name="FamilyMemberNegative" as="xs:string">
		<xsl:value-of select="'%s: Geschiedenis negatief'"/>
	</xsl:variable>
	
	<xsl:variable name="FamilyMemberUnkn" as="xs:string">
		<xsl:value-of select="'%s: Geschiedenis onbekend'"/>
	</xsl:variable>
	
	<xsl:variable name="DeceasedRelationDisplay" as="xs:string">
		<xsl:value-of select="'Relatie: %s'"/>
	</xsl:variable>
	
	<xsl:variable name="DeceasedRelationNameDisplay" as="xs:string">
		<xsl:value-of select="', Naam: %s'"/>
	</xsl:variable>
	
	<xsl:variable name="DeceasedAgeDisplay" as="xs:string">
		<xsl:value-of select="', Leeftijd: %s'"/>
	</xsl:variable>
	
	<xsl:variable name="DeceasedCauseofDeathDisplay" as="xs:string">
		<xsl:value-of select="', Oorzaak: %s'"/>
	</xsl:variable>
	
	<xsl:variable name="DeceasedFamilyLabel" as="xs:string">
		<xsl:value-of select="'Overleden familieleden'"/>
	</xsl:variable>
	
	<xsl:variable name="HealthStatusFamilyLabel" as="xs:string">
		<xsl:value-of select="'Gezondheidsstatus familieleden'"/>
	</xsl:variable>
	
	<xsl:variable name="ConditionCommentLabel" as="xs:string">
		<xsl:value-of select="' (Opmerkingen: '"/>
	</xsl:variable>
	
	<xsl:variable name="ConditionCommentSeparator" as="xs:string">
		<xsl:value-of select="'; '"/>
	</xsl:variable>
	
	<xsl:variable name="ShowComments" as="xs:boolean">
		<xsl:value-of select="false()"/>
	</xsl:variable>
	<!-- Strings from the histories control, NOTE: These MUST match the displays from code set 25320 -->
	<xsl:variable name="HistCtrlAbout" as="xs:string" select="'Over'"/>
	<xsl:variable name="HistCtrlBefore" as="xs:string" select="'Voor'"/>
	<xsl:variable name="HistCtrlAfter" as="xs:string" select="'Na'"/>
	<xsl:variable name="HistCtrlUnknown" as="xs:string" select="'Onbekend'"/>
	
</xsl:stylesheet>
