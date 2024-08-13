<?xml version="1.0" encoding="UTF-8"?>
<?dynamic-document type="format" version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:n="urn:com-cerner-patient-ehr:v3"
	xmlns:cdocfx="urn:com-cerner-physician-documentation-functions"
	xmlns:java-string="java:java.lang.String"
	xmlns:xr-date-formatter="java:com.cerner.xsl.util.XSLTDateUtilities"
	xmlns:dd="DynamicDocumentation"
	exclude-result-prefixes="xsl xs fn n cdocfx java-string xr-date-formatter">

	<xsl:output method="html" encoding="UTF-8" indent="yes"/>

	<xsl:param as="xs:string" name="current-locale" select="'en_US'"/>
	<xsl:param name="lUserId" select="0" />
	
	<!-- Backend system locale passed as a paramter -->
	<xsl:param as="xs:string" name="SystemLocale" select="''"/>
	
	<!-- required to include CommonFxn.xslt -->
	<!-- Comment this line to debug --> <xsl:include href="/cernerbasiccontent/formats/dxcommonfxn.xslt" />
	<!-- Uncomment this line to debug <xsl:include href="dxcommonfxn.xslt" /> -->

	<!-- Default string constants -->
	<xsl:variable name="OrdersLast12Hours" as="xs:string">
		<xsl:value-of select="'Orders (Last 12 Hours): '"/>
	</xsl:variable>
	<xsl:variable name="OrdersLast48Hours" as="xs:string">
		<xsl:value-of select="'Orders (Last 48 Hours): '"/>
	</xsl:variable>
	<xsl:variable name="Space" as="xs:string">
		<xsl:value-of select="'&#160;'"/>
	</xsl:variable>
	<xsl:variable name="entityIdList" as="element()*">
		<xsl:copy-of select="cdocfx:createEntityidList(n:report/n:format-inputs)"/>
	</xsl:variable>
	<xsl:variable name="Separator" as="xs:string">
		<xsl:value-of select="', %s'"/>
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
	<xsl:variable name="StartDate" as="xs:string">
        <xsl:value-of select="'Start Date: '"/>
    </xsl:variable>
	<xsl:variable name="Comma" as="xs:string">
        <xsl:value-of select="', '"/>
    </xsl:variable>

	<xsl:variable name="DATE_ONLY_SEQUENCE" as="xs:string" select="'MM/dd/yyyy'"/>
	
	<xsl:variable name="InpatientAandP" as="xs:boolean">
		<xsl:value-of select="false()"/>
	</xsl:variable>

	<!-- displayConfirmation will be overwritten by the locale specific format. If true, confirmation status of diagnosis will be displayed -->
	<xsl:variable name="displayConfirmation" as="xs:boolean" select="true()"/>
	
	<!-- displayStartDate will be overwritten by the locale specific format. If true, the start date of order will be displayed for single medication ingredient orders -->
	<xsl:variable name="displayStartDate" as="xs:boolean" select="false()"/>
	
	<!-- Functions -->

	<!-- Detect if given order has been banned meaning that it should not be displayed. Possible reasons to not want to
		display an order would be if it was system generated, or so common as to be noise instead of value added. -->
	<!-- Parameters: -->
	<!-- 	order - the order node -->
	<xsl:function name="cdocfx:isBannedOrder" as="xs:boolean">
		<xsl:param name="order"/>
		<xsl:choose>
			<!-- ATTENTION - Update the following and add any additional use cases needed here. Note that you can
				filter on other fields here as well, but you want to keep the total number of conditions
				being checked to a minimum for performance reasons. -->
			<xsl:when test="$order[@clinical-name='PLACE_BANNED_ORDER_NAME_HERE']">
				<xsl:value-of select="fn:true()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="fn:false()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

	<!-- Templates -->
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
			<xsl:value-of select="cdocfx:getDxPriorityDisplay($dx)" disable-output-escaping="yes"/>
			<xsl:value-of select="cdocfx:getDxDisplay($dx)"/>

			<!-- Display Confirmation status of the diagnosis except for diagnoses which is in 'Confirmed' status -->
			<xsl:if test="$displayConfirmation">
				<xsl:value-of select="cdocfx:getDiagnosesConfirmationDisplay($dx)"/>
			</xsl:if>
	</xsl:template>

	<!-- Format the given medication order as ddemrcontentitem -->
	<!-- Parameters: -->
	<!-- 	order - the medication order node -->
	<xsl:template name="tempMedicationOrder">
		<xsl:param name="order"/>
		<ul style="list-style-type: disc; margin: 0; padding-left: 15px">
			<li class="ddemrcontentitem ddremovable">
				<xsl:attribute name="dd:entityid">
					<xsl:value-of select="$order/@order-id"/>
				</xsl:attribute>
				<xsl:attribute name="dd:contenttype">
					<xsl:text>MEDICATIONS</xsl:text>
				</xsl:attribute>
				
				<xsl:choose>
					<xsl:when test="(@reference-name or @display-mnemonic) and count(n:medication-ingredient) &gt; 1">
						<xsl:call-template name="APandOrdersNameDisplay">
							<xsl:with-param name="order" select="$order"/>
						</xsl:call-template>
						<xsl:if test="$order/@clinical-display-line">
							<xsl:text>, </xsl:text>
							<xsl:value-of select="$order/@clinical-display-line"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="(@reference-name or @display-mnemonic) and count(n:medication-ingredient) &lt;= 1">
						<xsl:call-template name="APandOrdersNameDisplay">
							<xsl:with-param name="order" select="$order"/>
						</xsl:call-template>
						
						<xsl:call-template name="tempOrderDoseDisplay">
							<xsl:with-param name="order" select="$order"/>
						</xsl:call-template>
				
						<xsl:if test="cdocfx:hasMedDetails(.)">
							<span style="font-weight:bold;">
								<!-- Route of administration -->
								<xsl:if test="$order/@route-of-administration-code">
									<xsl:variable name="sRouteAdministration" as="xs:string" select="cdocfx:getCodeDisplayByID($order/@route-of-administration-code)"/>
									<xsl:value-of select="java-string:format($Separator, $sRouteAdministration)"/>
								</xsl:if>

								<!-- Frequency -->
								<!-- Do not process the frequency node if it is self closed or empty node -->
								<xsl:if test="exists($order/n:order-schedule/n:frequency) and exists($order/n:order-schedule/n:frequency/descendant::node()) and exists($order/n:order-schedule/n:frequency/descendant::node()/@frequency-code)">
									<xsl:variable name="sFrequency" as="xs:string" select="cdocfx:getCodeDisplayByID($order/n:order-schedule/n:frequency/descendant::node()/@frequency-code)"/>
									<xsl:value-of select="java-string:format($Separator, $sFrequency)"/>
								</xsl:if>

								<!-- PRN -->
								<xsl:if test="$order/n:order-schedule/@is-prn = 'true'">
									<xsl:value-of select="java-string:format($Separator, $Prn)"/>
								</xsl:if>

								<!-- Number of Refills -->
								<xsl:if test="$order/@total-fills &gt; 0">
									<!-- Remove Trailing Zeros based on Locale -->
									<xsl:variable name="sTotalFills" as="xs:string" select="cdocfx:removeTrailingZeros($order/@total-fills, $SystemLocale)"/>
									<xsl:value-of select="java-string:format($Separator, java-string:format($Connect, ($sTotalFills, $Refills)))"/>
								</xsl:if>
							</span>
						</xsl:if>
						
						<!-- Start Date -->
						<xsl:if test="$displayStartDate and $order/n:order-schedule/n:start-dt-tm">
							<xsl:variable name="DateTime" as="xs:dateTime" select="$order/n:order-schedule/n:start-dt-tm"/>
							<xsl:variable name="TimeZone" as="xs:string" select="$order/n:order-schedule/n:start-dt-tm/@time-zone"/>
							<xsl:value-of select="concat($Comma,$StartDate,xr-date-formatter:formatDate($DateTime, $DATE_ONLY_SEQUENCE, $TimeZone, $current-locale))"/>
						</xsl:if>				

						<!-- The Medications compliance information now is removed from the Medications EMR Content. Previously, the system displayed Medications compliance information for all encounters rather than the current encounter. -->
						
						<!-- <xsl:for-each select="$order/n:order-compliance/n:performed-dt-tm">
							<xsl:sort select="." order="descending"/>
							<xsl:if test="position() = 1">
								<xsl:if test="$order/../@status-code and not(cdocfx:getCodeMeanByID($order/../@status-code) = 'TAKINGASRX')">
									<xsl:text disable-output-escaping="yes">,<![CDATA[&#160; &#160;]]></xsl:text>
									<strong>
										<xsl:value-of select="cdocfx:getCodeDisplayByID($order/../@status-code)"/>
									</strong>
									<xsl:if test="$order/../n:comment">
										<xsl:variable name="sComment" select="$order/../n:comment" as="xs:string"/>
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
			</li>
		</ul>
	</xsl:template>
	
	<!-- Format the Order Dose for display -->
	<!-- Parameters: -->
	<!-- 	order - the medication order node -->
	<xsl:template name="tempOrderDoseDisplay">
		<xsl:param name="order"/>
		
		<xsl:variable name="Dose" as="xs:string">
			<xsl:choose>
				<xsl:when test="$order/n:medication-ingredient/n:dose[@strength-unit-code]">
					<!-- Remove Trailing Zeros based on Locale -->
					<xsl:variable name="Strength" select="cdocfx:removeTrailingZeros($order/n:medication-ingredient/n:dose/@strength, $SystemLocale)"/>
					<xsl:variable name="sUnit" as="xs:string" select="cdocfx:getCodeDisplayByID($order/n:medication-ingredient/n:dose/@strength-unit-code)"/>
					<xsl:value-of select="java-string:format($Connect, ($Strength, $sUnit))"/>
				</xsl:when>
				<!-- Free Text Dose -->
				<xsl:when test="$order/n:medication-ingredient/n:dose[@freetext-dose]">
					<xsl:value-of select="$order/n:medication-ingredient/n:dose/@freetext-dose"/>
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
				
				<xsl:if test="$order/n:medication-ingredient/n:dose[@volume-unit-code]">
				   <xsl:variable name="Volume" select="cdocfx:removeTrailingZeros($order/n:medication-ingredient/n:dose/@volume, $SystemLocale)"/>
				   <xsl:variable name="sUnit" as="xs:string" select="cdocfx:getCodeDisplayByID($order/n:medication-ingredient/n:dose/@volume-unit-code)"/>
				   <xsl:value-of select="java-string:format(if (exists($order/n:medication-ingredient/n:dose[@strength-unit-code])) then $volumeSeparator else $Separator, java-string:format($Connect, ($Volume, $sUnit)))"/>
				</xsl:if>

				<xsl:if test="$order/n:medication-ingredient/n:dose[@ordered-unit-code]">
					<!-- Remove Trailing Zeros based on Locale -->
					<xsl:variable name="Ordered" select="cdocfx:removeTrailingZeros($order/n:medication-ingredient/n:dose/@ordered, $SystemLocale)"/>
					<xsl:variable name="sUnit" as="xs:string" select="cdocfx:getCodeDisplayByID($order/n:medication-ingredient/n:dose/@ordered-unit-code)"/>
					<xsl:value-of select="java-string:format($Separator, java-string:format($Connect, ($Ordered, $sUnit)))"/>
				</xsl:if>
			</span>
		</xsl:if>
	</xsl:template>

	<!-- Format the given non-medication order as ddemrcontentitem -->
	<!-- Parameters: -->
	<!-- 	order - the non-medication order node -->
	<xsl:template name="tempNonMedicationOrder">
		<xsl:param name="order"/>
		<ul style="list-style-type: disc; margin: 0; padding-left: 15px">
			<li class="ddemrcontentitem ddremovable">
				<xsl:attribute name="dd:entityid">
					<xsl:value-of select="$order/@order-id"/>
				</xsl:attribute>
				<xsl:attribute name="dd:contenttype">
					<xsl:text>NONMEDORDERS</xsl:text>
				</xsl:attribute>
				
				<xsl:call-template name="APandOrdersNameDisplay">
					<xsl:with-param name="order" select="$order"/>
				</xsl:call-template>
				<xsl:if test="$order/@clinical-display-line">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="$order/@clinical-display-line"/>
				</xsl:if>
			</li>
		</ul>
	</xsl:template>

	<!-- format a table with given order list and text -->
	<!-- Parameters: -->
	<!-- 	medsOrders - the medication order node list -->
	<!-- 	nonMedsOrders - the non-medication order node list -->
	<!--	text - text that will fill into the first column of the table -->
	<xsl:template name="tempOrderList">
		<xsl:param name="medsOrders"/>
		<xsl:param name="nonMedsOrders"/>
			<!-- medication orders -->
			<xsl:if test="fn:exists($medsOrders)">
				<xsl:for-each select="$medsOrders">
					<xsl:sort select="fn:upper-case(@reference-name)" order="ascending"/>
						<xsl:call-template name="tempMedicationOrder">
							<xsl:with-param name="order" select="."/>
						</xsl:call-template>
				</xsl:for-each>
			</xsl:if>
			<!-- non-medication orders -->
			<xsl:if test="fn:exists($nonMedsOrders)">
				<xsl:for-each select="$nonMedsOrders">
					<xsl:sort select="fn:upper-case(@reference-name)" order="ascending"/>
						<xsl:call-template name="tempNonMedicationOrder">
							<xsl:with-param name="order" select="."/>
						</xsl:call-template>
				</xsl:for-each>
			</xsl:if>
	</xsl:template>

	<!-- Format diagnoses and associated orders by given list of clinical-diagnosis nodes -->
	<!-- Parameters: -->
	<!--    dxList - a list of diagnosis-data node -->
	<xsl:template name="tempClinicalDiagnoses">
		<xsl:param name="dxList"/>
		<xsl:for-each select="$dxList">
			<xsl:sort select="cdocfx:getDxPriority(.)" order="ascending"/>
			<xsl:sort select="fn:upper-case(cdocfx:getDxDisplay(.))" order="ascending"/>
			<div class="ddemrcontentitem ddremovable" style = "clear:both">
				<!-- Format diagnosis item -->
				<xsl:call-template name="tempClinicalDiagnosis">
					<xsl:with-param name="dx" select="."/>
				</xsl:call-template>
				<div class="ddfreetext ddremovable" style="margin-left:8px" dd:btnfloatingstyle="top-right"><xsl:value-of select="$Space"/></div>
			</div>	
		</xsl:for-each>
	</xsl:template>

	<!-- main template -->
	<xsl:template match="/">
		
		<!-- dxList is the list of diagnoses which are qualified for display  -->		
		<xsl:variable name="dxList" as="element()*">
			<xsl:copy-of select="cdocfx:getDisplayableDiagnoses(n:report/n:clinical-data/n:diagnosis-data/n:clinical-diagnosis,$entityIdList)"/>
		</xsl:variable>
		
		
		<!-- Get all medication/non-medication orders placed by the given user -->
		<xsl:variable name="medsOrders" select="n:report/n:clinical-data/n:order-data/n:medication-order[fn:not(cdocfx:isBannedOrder(.)) and @responsible-provider-id = $lUserId]"/>
		<xsl:variable name="nonMedsOrders" select="n:report/n:clinical-data/n:order-data/n:non-medication-order[fn:not(cdocfx:isBannedOrder(.)) and @responsible-provider-id = $lUserId]"/>

		<!-- Format diagnoses -->
		<xsl:if test="fn:count($dxList) &gt; 0">
			<xsl:call-template name="tempClinicalDiagnoses">
				<xsl:with-param name="dxList" select="$dxList"/>		
			</xsl:call-template>
		</xsl:if>

		<!-- Format orders -->
		<xsl:if test="fn:exists($medsOrders) or fn:exists($nonMedsOrders)">
			<div class="ddgrouper ddremovable" style = "clear:both" dd:btnfloatingstyle="top-right">
				<!-- Determine if the Orders label is Inpatient or Outpatient-->
				<xsl:choose>
					<xsl:when test = "$InpatientAandP">
						<div><xsl:value-of select="$OrdersLast12Hours"/></div>
					</xsl:when>
					<xsl:otherwise>
						<div><xsl:value-of select="$OrdersLast48Hours"/></div>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:call-template name="tempOrderList">
					<xsl:with-param name="medsOrders" select="$medsOrders"/>
					<xsl:with-param name="nonMedsOrders" select="$nonMedsOrders"/>
				</xsl:call-template>
			</div>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
