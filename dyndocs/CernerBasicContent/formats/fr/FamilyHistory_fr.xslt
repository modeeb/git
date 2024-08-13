<?xml version="1.0" encoding="UTF-8"?>
<?dynamic-document type="format" version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<!-- Comment this line to debug --><xsl:import href="/cernerbasiccontent/formats/familyhistory.xslt"/>
	<!-- Uncomment this line to debug <xsl:import href="../familyhistory.xslt" /> -->
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	
	<!-- Locale defined for CommonFxn.xslt (If not defined, defaults to en_US, Value defined here overrides all other values) -->
	<xsl:param as="xs:string" name="current-locale" select="'fr'"/>
	
	<!-- Strings defined for familyhistory.xslt, String values defined here override the default values defined in familyhistory.xslt -->
	<xsl:variable name="PatientAdopted" as="xs:string">
		<xsl:value-of select="'Le patient a &#233;t&#233; adopt&#233;'"/>
	</xsl:variable>
	
	<xsl:variable name="UnableToObtain" as="xs:string">
		<xsl:value-of select="'Impossible d''obtenir les ant&#233;c&#233;dents familiaux'"/>
	</xsl:variable>
	
	<xsl:variable name="HistoryNegative" as="xs:string">
		<xsl:value-of select="'Ant&#233;c&#233;dents familiaux n&#233;gatifs'"/>
	</xsl:variable>
	
	<xsl:variable name="HistoryUnknown" as="xs:string">
		<xsl:value-of select="'Ant&#233;c&#233;dents familiaux inconnus'"/>
	</xsl:variable>
	
	<xsl:variable name="DiagnosedDisplay" as="xs:string">
		<xsl:value-of select="' (Diagnostic %s)'"/>
	</xsl:variable>
	
	<xsl:variable name="DiagnosedAtDisplay" as="xs:string">
		<xsl:value-of select="' (Diagnostiqu&#233; &#224; %s)'"/>
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
		<xsl:value-of select="' et %s.'"/>
	</xsl:variable>
	
	<xsl:variable name="FamilyMemberDisp" as="xs:string">
		<xsl:value-of select="'%s%s'"/>
	</xsl:variable>
	
	<xsl:variable name="NegConditionDisplay" as="xs:string">
		<xsl:value-of select="'N&#233;gatif&#160;: '"/>
	</xsl:variable>
	
	<xsl:variable name="FamilyMemberNegative" as="xs:string">
		<xsl:value-of select="'%s&#160;: Ant&#233;c&#233;dents n&#233;gatifs'"/>
	</xsl:variable>
	
	<xsl:variable name="FamilyMemberUnkn" as="xs:string">
		<xsl:value-of select="'%s&#160;: Ant&#233;c&#233;dents inconnus'"/>
	</xsl:variable>
	
	<xsl:variable name="DeceasedRelationDisplay" as="xs:string">
		<xsl:value-of select="'Relation&#160;: %s'"/>
	</xsl:variable>
	
	<xsl:variable name="DeceasedRelationNameDisplay" as="xs:string">
		<xsl:value-of select="', Nom&#160;: %s'"/>
	</xsl:variable>
	
	<xsl:variable name="DeceasedAgeDisplay" as="xs:string">
		<xsl:value-of select="', &#194;ge&#160;: %s'"/>
	</xsl:variable>
	
	<xsl:variable name="DeceasedCauseofDeathDisplay" as="xs:string">
		<xsl:value-of select="', Cause&#160;: %s'"/>
	</xsl:variable>
	
	<xsl:variable name="DeceasedFamilyLabel" as="xs:string">
		<xsl:value-of select="'Membre(s) de la famille d&#233;c&#233;d&#233;(s)'"/>
	</xsl:variable>
	
	<xsl:variable name="HealthStatusFamilyLabel" as="xs:string">
		<xsl:value-of select="'&#201;tat de sant&#233;&#160;-&#160;Membre(s) de la famille'"/>
	</xsl:variable>
	
	<xsl:variable name="ConditionCommentLabel" as="xs:string">
		<xsl:value-of select="' (Commentaires&#160;: '"/>
	</xsl:variable>
	
	<xsl:variable name="ConditionCommentSeparator" as="xs:string">
		<xsl:value-of select="'&#160;; '"/>
	</xsl:variable>
	
	<xsl:variable name="ShowComments" as="xs:boolean">
		<xsl:value-of select="false()"/>
	</xsl:variable>
	
	<!-- Strings from the histories control, NOTE: These MUST match the displays from code set 25320 -->
	<xsl:variable name="HistCtrlAbout" as="xs:string" select="'Approximativement'"/>
	<xsl:variable name="HistCtrlBefore" as="xs:string" select="'Avant'"/>
	<xsl:variable name="HistCtrlAfter" as="xs:string" select="'Apr&#232;s'"/>
	<xsl:variable name="HistCtrlUnknown" as="xs:string" select="'Inconnu'"/>
	
</xsl:stylesheet>
