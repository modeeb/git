<?xml version="1.0" encoding="UTF-8"?>
<?dynamic-document type="format" version="7.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:n="urn:com-cerner-patient-ehr:v3"
	xmlns:java-string="java:java.lang.String"
	xmlns:cdocfx="urn:com-cerner-physician-documentation-functions"
	xmlns:dd="DynamicDocumentation"
	xmlns:xr-date-formatter="java:com.cerner.xsl.util.XSLTDateUtilities"
	exclude-result-prefixes="xsl xs fn n cdocfx xr-date-formatter java-string">

	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	
	<xsl:param as="xs:string" name="current-locale" select="'en_US'"/>

	<!-- required to include CommonFxn.xslt -->
	<!-- Comment this line to debug--> <xsl:include href="/cernerbasiccontent/formats/dxcommonfxn.xslt" /> 
	<!-- Uncomment this line to debug  <xsl:include href="dxcommonfxn.xslt" /> -->

	<!-- Default string constants -->
	<xsl:variable name="DATE_ONLY_SEQUENCE" as="xs:string" select="'MM/dd/yyyy'"/>
	
	<xsl:variable name="Separator" as="xs:string">
		<xsl:value-of select="', %s'"/>
	</xsl:variable>
	
	<xsl:variable name="PrincipalDiagnosis" as="xs:string" select="'Principal'"/>
	
	<!-- displayPriority will be overwritten by the locale specific format. If true, format will display the priority of the diagnosis. -->
	<xsl:variable name="displayPriority" as="xs:boolean" select="true()"/>
	
	<!-- displayPrincipal will be overwritten by the locale specific format. If true, format will display the principal diagnosis. -->
    <xsl:variable name="displayPrincipal" as="xs:boolean" select="false()"/>
	
	<!-- displayDate will be overwritten by the locale specific format. If true, format will display the diagnosis date. -->
	<xsl:variable name="displayDate" as="xs:boolean" select="true()"/>
	
	<!-- displayOnlyConfirmedDiagnoses will be overwritten by the locale specific format. If true, format will display only the diagnosis which is in 'Confirmed' status. -->
	<xsl:variable name="displayOnlyConfirmedDiagnoses" as="xs:boolean" select="true()"/>
	<!-- Keys -->
	<xsl:key name="keyDxByNomenId" match="n:report/n:clinical-data/n:diagnosis-data/n:clinical-diagnosis" use="n:diagnosis-name/n:nomenclature"/>
	
	<!-- Get diagnosis type display of the given diagnosis. -->
	<!-- Parameters: -->
	<!--	dx - diagnosis object -->
	<xsl:function name="cdocfx:getDxTypeDisplay" as="xs:string">
		<xsl:param name="dx"/>
		<xsl:choose>
			<xsl:when test="$dx/@confirmation-code">
				<xsl:value-of select="cdocfx:getCodeDisplayByID($dx/@type-code)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="''"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	<!-- Get classification display of the given diagnosis. -->
	<!-- Parameters: -->
	<!--	dx - diagnosis object -->
	<xsl:function name="cdocfx:getDxClassificationDisplay" as="xs:string">
		<xsl:param name="dx"/>
		<xsl:choose>
			<xsl:when test="$dx/@classification-code">
				<xsl:value-of select="cdocfx:getCodeDisplayByID($dx/@classification-code)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="''"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	<!-- Get Diagnosis Date of the given diagnosis. -->
	<!-- Parameters: -->
	<!--	dx - diagnosis object -->
	<xsl:function name="cdocfx:getDiagnosisDate" as="xs:string">
		<xsl:param name="dx"/>
		<xsl:choose>
			<xsl:when test="$dx/n:diagnosis-dt-tm">
				<xsl:variable name="tz" select="$dx/n:diagnosis-dt-tm/@time-zone"/>
				<xsl:variable name="dxDtTm" as="xs:dateTime" select="$dx/n:diagnosis-dt-tm"/>
				<xsl:value-of select="xr-date-formatter:formatDate($dxDtTm, $DATE_ONLY_SEQUENCE, $tz, $current-locale)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="''"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	<!-- Templates -->
	
	<!-- Format the desired additional diagnosis information. -->
	<!-- Undesired additional information can be commented out or removed here. -->
	<!-- Parameters: -->
	<!--   dx - diagnosis node -->
	<xsl:template name="tempAdditionalDxInformation">
		<xsl:param name="dx"/>
		
		<!-- Whether principal should be displayed or not -->
		<xsl:if test="$displayPrincipal = true() and cdocfx:getDxPriority(.) = 1">
			<xsl:value-of select="java-string:format($Separator, $PrincipalDiagnosis)" disable-output-escaping="yes" />
		</xsl:if>
		
		<!-- Diagnoses Date -->
		<xsl:if test="$displayDate = true() and $dx/n:diagnosis-dt-tm">
			<xsl:value-of select="java-string:format($Separator, cdocfx:getDiagnosisDate($dx))" disable-output-escaping="yes" />
		</xsl:if>
	</xsl:template>
	
	<!-- Format given diagnosis by populating ddemrcontentitem attributes and text -->
	<!-- Parameters: -->
	<!--	dx - diagnosis node -->
	<xsl:template name="tempClinicalDiagnosis" >
		<xsl:param name="dx"/>
			<xsl:attribute name="dd:entityid">
				<xsl:value-of select="$dx/@id"/>
			</xsl:attribute>
			<xsl:attribute name="dd:contenttype">
				<xsl:text>DIAGNOSES</xsl:text>
			</xsl:attribute>
			<xsl:if test="$displayPriority = true()">
				<xsl:value-of select="cdocfx:getDxPriorityDisplay($dx)" disable-output-escaping="yes"/>
			</xsl:if>
			
			<xsl:value-of select="cdocfx:getDxDisplay($dx)"/>
			
			<xsl:call-template name="tempAdditionalDxInformation">
				<xsl:with-param name="dx" select="$dx"/>
			</xsl:call-template>
	</xsl:template>

	<!-- format diagnoses from a list of clinical-diagnosis nodes -->
	<!-- Parameters: -->
	<!-- 	dxList - a list of diagnosis-data node -->
	<xsl:template name="tempClinicalDiagnoses">
		<xsl:param name="dxList"/>
		<xsl:for-each select="$dxList">
			<div class="ddemrcontentitem ddinsertfreetext ddremovable">
				<xsl:call-template name="tempClinicalDiagnosis" >
					<xsl:with-param name="dx" select="."/>
				</xsl:call-template>
			</div>
			
		</xsl:for-each>
	</xsl:template>

	<!-- main template -->
	<xsl:template match="/">
		<!-- Get diagnosis, sorted by display -->
		<!-- If displayOnlyConfirmedDiagnoses is true get only 'Confirmed' diagnoses otherwise get all-->
		<xsl:variable name="dxList" as="element()*">
		<xsl:variable name="dxData" select="n:report/n:clinical-data/n:diagnosis-data"/>	
			<!-- Get all diagnosis, sorted by display -->
			<xsl:call-template name="sortAndFilterDxData">					
				<xsl:with-param name="dxData" select="$dxData"/>
				<xsl:with-param name="displayOnlyConfirmedDiagnoses" select="$displayOnlyConfirmedDiagnoses"/>
			</xsl:call-template>	
		</xsl:variable>
		
		<!-- Format diagnoses and associated orders -->
		<xsl:if test="fn:count($dxList)>0">
			<xsl:call-template name="tempClinicalDiagnoses">
				<xsl:with-param name="dxList" select="$dxList"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- Sorts and filters the diagnosis data-->
	<!-- Parameters: -->	
	<!-- 	dxData - a list of diagnosis-data node -->
	<!--	displayOnlyConfirmedDiagnoses - if set to true it will only include diagnoses which are in 'Confirmed' status -->
	<xsl:template name="sortAndFilterDxData">
		<xsl:param name="dxData"/>
		<xsl:param name="displayOnlyConfirmedDiagnoses"/>
		<xsl:choose>
			<xsl:when test="$displayOnlyConfirmedDiagnoses">
				<!-- Display those diagnoses which are in 'Confirmed' status -->
				<xsl:perform-sort select="$dxData/n:clinical-diagnosis[@is-active='true' and @confirmation-code and cdocfx:getCodeMeanByID(@confirmation-code)='CONFIRMED']">
					<!-- Sort diagnosis by clinical-priority, diagnoses having priority of 999 or no priority are sorted by display -->
					<xsl:sort select="cdocfx:getDxPriority(.)"/>
					<xsl:sort select="fn:upper-case(cdocfx:getDxDisplay(.))"/>
				</xsl:perform-sort>
			</xsl:when>
			<xsl:otherwise>
				<xsl:perform-sort select="$dxData/n:clinical-diagnosis[@is-active='true']">
					<!-- Sort diagnosis by clinical-priority, diagnoses having priority of 999 or no priority are sorted by display -->
					<xsl:sort select="cdocfx:getDxPriority(.)"/>
					<xsl:sort select="fn:upper-case(cdocfx:getDxDisplay(.))"/>
				</xsl:perform-sort>
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>	
</xsl:stylesheet>
