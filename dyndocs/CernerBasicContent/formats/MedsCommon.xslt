<?xml version="1.0" encoding="UTF-8"?>
<?dynamic-document type="format" version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:fn="http://www.w3.org/2005/xpath-functions" 
	xmlns:n="urn:com-cerner-patient-ehr:v3" 
	xmlns:java-string="java:java.lang.String" 
	xmlns:cdocfx="urn:com-cerner-physician-documentation-functions"
	xmlns:xr-date-formatter="java:com.cerner.xsl.util.XSLTDateUtilities"
	xmlns:dd="DynamicDocumentation" 
	exclude-result-prefixes="xsl xs fn n java-string cdocfx xr-date-formatter dd">

	<xsl:output method="html" encoding="UTF-8" indent="yes"/>

	<xsl:param as="xs:string" name="current-locale" select="'en_US'"/>

	<!-- Backend system locale passed as a paramter -->
	<xsl:param as="xs:string" name="SystemLocale" select="''"/>

	<!-- Required to include CommonFxn.xslt -->
	<!-- Comment out this line to debug -->	<xsl:include href="/cernerbasiccontent/formats/commonfxn.xslt"/>
	<!-- Uncomment this line to debug <xsl:include href="CommonFxn.xslt"/> -->

	<xsl:variable name="Separator" as="xs:string">	<!-- Separator between detail components -->
		<xsl:value-of select="',  %s'"/>
	</xsl:variable>
	<xsl:variable name="Connect" as="xs:string"> 	<!-- Connect two strings as one with a space in between -->
		<xsl:value-of select="'%s %s'"/>
	</xsl:variable>
	<xsl:variable name="OrderComplianceComment" as="xs:string">
		<xsl:value-of select="':  %s'"/>
	</xsl:variable>
	<xsl:variable name="Prn" as="xs:string">
		<xsl:value-of select="'PRN'"/>
	</xsl:variable>
	<xsl:variable name="Refills" as="xs:string">
		<xsl:value-of select="'refills'"/>
	</xsl:variable>
	<xsl:variable name="volumeSeparator" as="xs:string">
		<xsl:value-of select="'=  %s'"/>
	</xsl:variable>
	<xsl:variable name="IsIndented" as="xs:boolean">
		<xsl:value-of select="false()"/>
	</xsl:variable>
	<xsl:variable name="StartDate" as="xs:string">
        <xsl:value-of select="'Start Date: '"/>
    </xsl:variable>
	<xsl:variable name="Comma" as="xs:string">
        <xsl:value-of select="', '"/>
    </xsl:variable>
    
    <xsl:variable name="DATE_ONLY_SEQUENCE" as="xs:string" select="'MM/dd/yyyy'"/>
	
	<!-- If set to true, displayStartDate will display the Order Start date for single medication ingredient orders -->
	<xsl:variable name="displayStartDate" as="xs:boolean" select="false()"/>

	<!-- Format the given medication-order as ddemrcontentitem -->
	<xsl:template match="n:medication-order">
		<div class="ddemrcontentitem ddremovable">
			<xsl:attribute name="style" select="if($IsIndented) then 'margin-left: 1em; padding-left:1em; text-indent:-1em;' 
					else 'margin-left: 0em; padding-left:1em; text-indent:-1em;'" />
			
			<xsl:attribute name="dd:entityid">
				<xsl:value-of select="@order-id"/>
			</xsl:attribute>
			<xsl:attribute name="dd:contenttype">
				<xsl:text>MEDICATIONS</xsl:text>
			</xsl:attribute>
			
			<!-- One Medication Order can have many Ingredients -->
			<!-- If a medication has more than one ingredient, we display the Clinical Display line-->
			<xsl:choose>
				<xsl:when test="(@reference-name or @display-mnemonic) and count(n:medication-ingredient) &gt; 1">
					<xsl:call-template name="APandOrdersNameDisplay">
						<xsl:with-param name="order" select="."/>
					</xsl:call-template>
					<xsl:if test="@clinical-display-line">
						<xsl:text>, </xsl:text>
						<xsl:value-of select="@clinical-display-line"/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="(@reference-name or @display-mnemonic) and count(n:medication-ingredient) &lt;= 1">
					<xsl:call-template name="APandOrdersNameDisplay">
						<xsl:with-param name="order" select="."/>
					</xsl:call-template>
					
					<!-- Dose -->
					<xsl:variable name="Dose" as="xs:string">
						<xsl:choose>
							<xsl:when test="n:medication-ingredient/n:dose[@strength-unit-code]">
								<!-- Remove Trailing Zeros based on Locale -->
								<xsl:variable name="Strength" select="cdocfx:removeTrailingZeros(n:medication-ingredient/n:dose/@strength, $SystemLocale)"/>
								<xsl:variable name="sUnit" as="xs:string" select="cdocfx:getCodeDisplayByID(n:medication-ingredient/n:dose/@strength-unit-code)"/>
								<xsl:value-of select="java-string:format($Connect, ($Strength, $sUnit))"/>
							</xsl:when>
							<!-- Free Text Dose -->
							<xsl:when test="n:medication-ingredient/n:dose[@freetext-dose]">
								<xsl:value-of select="n:medication-ingredient/n:dose/@freetext-dose"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="''"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
				
					<xsl:if test="cdocfx:hasMedDetails(.)">			
						<span style="font-weight:bold;">
							<xsl:if test="$Dose != ''">
								<xsl:value-of select="java-string:format($Separator, $Dose)"/>
							</xsl:if>
			
							<xsl:if test="n:medication-ingredient/n:dose[@volume-unit-code]">
								<xsl:variable name="Volume" select="cdocfx:removeTrailingZeros(n:medication-ingredient/n:dose/@volume, $SystemLocale)"/>
								<xsl:variable name="sUnit" as="xs:string" select="cdocfx:getCodeDisplayByID(n:medication-ingredient/n:dose/@volume-unit-code)"/>
								<xsl:value-of select="java-string:format(if (exists(n:medication-ingredient/n:dose[@strength-unit-code])) then $volumeSeparator else $Separator, java-string:format($Connect, ($Volume, $sUnit)))"/>
							</xsl:if>
			
							<xsl:if test="n:medication-ingredient/n:dose[@ordered-unit-code]">
								<!-- Remove Trailing Zeros based on Locale -->
								<xsl:variable name="Ordered" select="cdocfx:removeTrailingZeros(n:medication-ingredient/n:dose/@ordered, $SystemLocale)"/>
								<xsl:variable name="sUnit" as="xs:string" select="cdocfx:getCodeDisplayByID(n:medication-ingredient/n:dose/@ordered-unit-code)"/>
								<xsl:value-of select="java-string:format($Separator, java-string:format($Connect, ($Ordered, $sUnit)))"/>
							</xsl:if>
			
							<!-- Route of administration -->
							<xsl:if test="@route-of-administration-code">
								<xsl:variable name="sRouteAdministration" as="xs:string" select="cdocfx:getCodeDisplayByID(@route-of-administration-code)"/>
								<xsl:value-of select="java-string:format($Separator, $sRouteAdministration)"/>
							</xsl:if>
			
							<!-- Frequency -->
							<!-- Do not process the frequency node if it is self closed or empty node -->
							<xsl:if test="exists(n:order-schedule/n:frequency) and exists(n:order-schedule/n:frequency/descendant::node()) and exists(n:order-schedule/n:frequency/descendant::node()/@frequency-code)">
								<xsl:variable name="sFrequency" as="xs:string" select="cdocfx:getCodeDisplayByID(n:order-schedule/n:frequency/descendant::node()/@frequency-code)"/>
								<xsl:value-of select="java-string:format($Separator, $sFrequency)"/>
							</xsl:if>
			
							<!-- PRN -->
							<xsl:if test="n:order-schedule/@is-prn = 'true'">
								<xsl:value-of select="java-string:format($Separator, $Prn)"/>
							</xsl:if>
			
							<!-- Number of Refills -->
							<xsl:if test="@total-fills &gt; 0">
								<!-- Remove Trailing Zeros based on Locale -->
								<xsl:variable name="sTotalFills" as="xs:string" select="cdocfx:removeTrailingZeros(@total-fills, $SystemLocale)"/>
								<xsl:value-of select="java-string:format($Separator, java-string:format($Connect, ($sTotalFills, $Refills)))"/>
							</xsl:if>
						</span>
					</xsl:if>
					
					<!-- Start Date -->
					<xsl:if test="$displayStartDate and n:order-schedule/n:start-dt-tm">
						<xsl:variable name="DateTime" as="xs:dateTime" select="n:order-schedule/n:start-dt-tm"/>
						<xsl:variable name="TimeZone" as="xs:string" select="n:order-schedule/n:start-dt-tm/@time-zone"/>
						<xsl:value-of select="concat($Comma,$StartDate,xr-date-formatter:formatDate($DateTime, $DATE_ONLY_SEQUENCE, $TimeZone, $current-locale))"/>
					</xsl:if>				
				
					<!-- The Medications compliance information now is removed from the Medications EMR Content. Previously, the system displayed Medications compliance information for all encounters rather than the current encounter. -->
					
					<!-- <xsl:for-each select="n:order-compliance/n:performed-dt-tm">
						<xsl:sort select="." order="descending"/>
						<xsl:if test="position() = 1">
							<xsl:if test="../@status-code and not(cdocfx:getCodeMeanByID(../@status-code) = 'TAKINGASRX')">
								<xsl:text disable-output-escaping="yes">,<![CDATA[&#160; &#160;]]></xsl:text>
								<strong>
									<xsl:value-of select="cdocfx:getCodeDisplayByID(../@status-code)"/>
								</strong>
								<xsl:if test="../n:comment">
									<xsl:variable name="sComment" select="../n:comment" as="xs:string"/>
									<xsl:value-of select="java-string:format($OrderComplianceComment, $sComment)"/>
								</xsl:if>
							</xsl:if>
						</xsl:if>
					</xsl:for-each> -->

				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/>
				</xsl:otherwise>				
			</xsl:choose>
		</div>
	</xsl:template>
	
</xsl:stylesheet>