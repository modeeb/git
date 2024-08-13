<?xml version="1.0" encoding="UTF-8"?>
<?dynamic-document type="format" version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<!-- Comment this line to debug --><xsl:import href="/cernerbasiccontent/formats/familyhistory.xslt"/>
	<!-- Uncomment this line to debug <xsl:import href="../familyhistory.xslt" /> -->
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	
	<!-- Locale defined for CommonFxn.xslt (If not defined, defaults to en_US, Value defined here overrides all other values) -->
	<xsl:param as="xs:string" name="current-locale" select="'sv'"/>
	
	<!-- Strings defined for familyhistory.xslt, String values defined here override the default values defined in familyhistory.xslt -->
	<xsl:variable name="PatientAdopted" as="xs:string">
		<xsl:value-of select="'Patienten adopterad'"/>
	</xsl:variable>
	
	<xsl:variable name="UnableToObtain" as="xs:string">
		<xsl:value-of select="'Kunde inte h&#228;mta hereditetshistorik'"/>
	</xsl:variable>
	
	<xsl:variable name="HistoryNegative" as="xs:string">
		<xsl:value-of select="'Hereditetshistorik negativ'"/>
	</xsl:variable>
	
	<xsl:variable name="HistoryUnknown" as="xs:string">
		<xsl:value-of select="'Hereditetshistorik ok&#228;nd'"/>
	</xsl:variable>
	
	<xsl:variable name="DiagnosedDisplay" as="xs:string">
		<xsl:value-of select="' (diagnos %s)'"/>
	</xsl:variable>
	
	<xsl:variable name="DiagnosedAtDisplay" as="xs:string">
		<xsl:value-of select="' (diagnos vid %s)'"/>
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
		<xsl:value-of select="' och %s.'"/>
	</xsl:variable>
	
	<xsl:variable name="FamilyMemberDisp" as="xs:string">
		<xsl:value-of select="'%s%s'"/>
	</xsl:variable>
	
	<xsl:variable name="NegConditionDisplay" as="xs:string">
		<xsl:value-of select="'Negativ: '"/>
	</xsl:variable>
	
	<xsl:variable name="FamilyMemberNegative" as="xs:string">
		<xsl:value-of select="'%s: Historik negativ'"/>
	</xsl:variable>
	
	<xsl:variable name="FamilyMemberUnkn" as="xs:string">
		<xsl:value-of select="'%s: Historik ok&#228;nd'"/>
	</xsl:variable>
	
	<xsl:variable name="DeceasedRelationDisplay" as="xs:string">
		<xsl:value-of select="'Relation: %s'"/>
	</xsl:variable>
	
	<xsl:variable name="DeceasedRelationNameDisplay" as="xs:string">
		<xsl:value-of select="', Namn: %s'"/>
	</xsl:variable>
	
	<xsl:variable name="DeceasedAgeDisplay" as="xs:string">
		<xsl:value-of select="', &#197;lder: %s'"/>
	</xsl:variable>
	
	<xsl:variable name="DeceasedCauseofDeathDisplay" as="xs:string">
		<xsl:value-of select="', Orsak: %s'"/>
	</xsl:variable>
	
	<xsl:variable name="DeceasedFamilyLabel" as="xs:string">
		<xsl:value-of select="'Avlidna familjemedlemmar'"/>
	</xsl:variable>
	
	<xsl:variable name="HealthStatusFamilyLabel" as="xs:string">
		<xsl:value-of select="'H&#228;lsostatus f&#246;r familjemedlemmar'"/>
	</xsl:variable>
	
	<xsl:variable name="ConditionCommentLabel" as="xs:string">
		<xsl:value-of select="' (Kommentar: '"/>
	</xsl:variable>
	
	<xsl:variable name="ConditionCommentSeparator" as="xs:string">
		<xsl:value-of select="'; '"/>
	</xsl:variable>
	
	<xsl:variable name="ShowComments" as="xs:boolean">
		<xsl:value-of select="false()"/>
	</xsl:variable>
	
	<!-- Strings from the histories control, NOTE: These MUST match the displays from code set 25320 -->
	<xsl:variable name="HistCtrlAbout" as="xs:string" select="'Omkring'"/>
	<xsl:variable name="HistCtrlBefore" as="xs:string" select="'F&#246;re'"/>
	<xsl:variable name="HistCtrlAfter" as="xs:string" select="'Efter'"/>
	<xsl:variable name="HistCtrlUnknown" as="xs:string" select="'Ok&#228;nd'"/>
	
</xsl:stylesheet>