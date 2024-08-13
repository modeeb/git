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
	<xsl:variable name="Ordered" as="xs:string">
		<xsl:value-of select="'Ordered: '"/>
	</xsl:variable>
	<xsl:variable name="AdditionalOrders" as="xs:string">
		<xsl:value-of select="'Orders: '"/>
	</xsl:variable>
	<xsl:variable name="Comments" as="xs:string">
		<xsl:value-of select="'&#160;'"/>
	</xsl:variable>
	<xsl:variable name="entityIdList" as="element()*">
		<xsl:copy-of select="cdocfx:createEntityidList(n:report/n:format-inputs)"/>
	</xsl:variable>
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
	<xsl:variable name="StartDate" as="xs:string">
        <xsl:value-of select="'Start Date: '"/>
    </xsl:variable>
	<xsl:variable name="Comma" as="xs:string">
        <xsl:value-of select="', '"/>
    </xsl:variable>
	
	<xsl:variable name="DATE_ONLY_SEQUENCE" as="xs:string" select="'MM/dd/yyyy'"/>
	
	<!-- displayConfirmation will be overwritten by the locale specific format. If true, the confirmation status of diagnosis will be displayed -->
	<xsl:variable name="displayConfirmation" as="xs:boolean" select="true()"/>
	
	<!-- displayStartDate will be overwritten by the locale specific format. If true, the start date of order will be displayed for single medication ingredient orders -->
	<xsl:variable name="displayStartDate" as="xs:boolean" select="false()"/>
	
	<!-- Note:
			The diagnosis and order are associated based on group-id attribute of medication -order node and the id attribute
			clinical-diagnosis node. If the order is future order then we will be using nomenclature-id (reason : - for any 
			future order the group-id attribute is zero) for the association. If the future order is associated to duplicate 
			diagnoses (i.e., diagnoses having the same nomenclature-id) then move the order to general bucket under the 
			heading "Orders:".
	 -->

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

	<!-- Detect if given order is associated with any of the given diagnosis -->
	<!-- Parameters: -->
	<!--    order - the order node -->
	<!--    dxNomenIDs - array of qualified active diagnosis nomenclature ids -->
	<!--    dxId - array of qualified active diagnosis ids -->
	<!--    dxList - array of qualified active diagnosis -->
	<xsl:function name="cdocfx:isOrderAssociatedWithActiveDiagnosis" as="xs:boolean">
		<xsl:param name="order"/>
		<xsl:param name="dxNomenIDs"/>
		<xsl:param name="dxId"/>
		<xsl:param name="dxList"/>
		<xsl:choose>
			<xsl:when test="$order/n:diagnosis">
				<xsl:choose>
					<xsl:when test="$order/n:diagnosis/@group-id = 0">
						<xsl:variable name="order_dxNomenIDs" select="$order/n:diagnosis/@nomenclature-id"/>
						<xsl:variable name="id_intersection" select="$order_dxNomenIDs[fn:count(fn:distinct-values(.|$dxNomenIDs))=count(fn:distinct-values($dxNomenIDs)) and fn:count(cdocfx:getDiagnosesForMatchingNomenID(., $dxList)) = 1]"/>
						<xsl:value-of select="fn:exists($id_intersection)"/>
					</xsl:when>
					<xsl:when test="$order/n:diagnosis/@group-id &gt; 0">
						<xsl:variable name="order_dxGroupIDs" select="$order/n:diagnosis/@group-id"/>
						<xsl:variable name="id_intersection" select="$order_dxGroupIDs[fn:count(fn:distinct-values(.|$dxId))=count(fn:distinct-values($dxId))]"/>
						<xsl:value-of select="fn:exists($id_intersection)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="fn:false()"/>
					</xsl:otherwise>
				</xsl:choose>
				
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
		<div class="ddemrcontentitem ddremovable">
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
		</div>
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
		<div class="ddemrcontentitem ddremovable">
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
		</div>
	</xsl:template>

	<!-- format a table with given order list and text -->
	<!-- Parameters: -->
	<!-- 	medsOrders - the medication order node list -->
	<!-- 	nonMedsOrders - the non-medication order node list -->
	<!--	text - text that will fill into the first column of the table -->
	<xsl:template name="tempOrderList">
		<xsl:param name="medsOrders"/>
		<xsl:param name="nonMedsOrders"/>
		<xsl:param name="text" as="xs:string"/>
		<xsl:if test="fn:string-length($text)>0">
			<div style="display:table-cell;*float:left;padding-left:8px;padding-right:10px">
				<xsl:value-of select="$text"/>
			</div>
		</xsl:if>

		<div>
			<xsl:choose>
				<xsl:when test="fn:string-length($text)>0">
					<xsl:attribute name="style">
						<xsl:text>display:table-cell;*float:left</xsl:text>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="style">
						<xsl:text>padding-left:8px</xsl:text>
					</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
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
		</div>
	</xsl:template>

	<!-- Format orders that associated to the given diagnoses -->
	<!-- Parameters: -->
	<!--    dxNomenId - diagnosis nomenclature id -->
	<!--    dxId - array of qualified active diagnosis ids -->
	<!--    medOrders - the med-orders which are associated to active diagnosis  -->
	<!--    nonMedOrders - the nonMed-orders which are associated to active diagnosis  -->
	<xsl:template name="tempDxOrdersById">
		<xsl:param name="dxNomenId"/>
		<xsl:param name="dxId"/>
		<xsl:param name="medOrders"/>
		<xsl:param name="nonMedOrders"/>

		<!-- Get orders that associated with current diagnosis and placed by the given user -->
		<xsl:variable name="medsOrders" select="cdocfx:getOrder($dxNomenId, $dxId, $medOrders)"/>
		<xsl:variable name="nonMedsOrders" select="cdocfx:getOrder($dxNomenId, $dxId, $nonMedOrders)"/>

		<!-- format associated orders -->
		<xsl:if test="fn:not(fn:empty($medsOrders) and fn:empty($nonMedsOrders))">
			<div>
				<xsl:call-template name="tempOrderList">
					<xsl:with-param name="medsOrders" select="$medsOrders"/>
					<xsl:with-param name="nonMedsOrders" select="$nonMedsOrders"/>
					<xsl:with-param name="text" select="$Ordered"/>
				</xsl:call-template>
			</div>
		</xsl:if>
	</xsl:template>

	<!-- Format diagnoses and associated orders by given list of clinical-diagnosis nodes -->
	<!-- Parameters: -->
	<!--    dxList - a list of diagnosis-data node -->
	<!--    medOrders - the med-orders which are associated to active diagnosis  -->
	<!--    nonMedOrders - the nonMed-orders which are associated to active diagnosis  -->
	<!--    hasDxOrders - indicate if has order(s) that associated with active diagnosis -->
	<xsl:template name="tempClinicalDiagnoses">
		<xsl:param name="dxList"/>
		<xsl:param name="medOrders"/>
		<xsl:param name="nonMedOrders"/>
		<xsl:param name="hasDxOrders" as="xs:boolean"/>
		<xsl:for-each select="$dxList">
				<xsl:sort select="cdocfx:getDxPriority(.)" order="ascending"/>
				<xsl:sort select="fn:upper-case(cdocfx:getDxDisplay(.))" order="ascending"/>
				<div class="ddemrcontentitem ddremovable" style = "clear:both">
					<!-- Format diagnosis item -->
					<xsl:call-template name="tempClinicalDiagnosis">
						<xsl:with-param name="dx" select="."/>
					</xsl:call-template>
					<div style="margin-left:8px" class="ddfreetext ddremovable" dd:btnfloatingstyle="top-right"><xsl:value-of select="$Comments"/></div>
					
					<!-- Format orders that associated to the given diagnoses -->
					<xsl:choose>
						<xsl:when test="$hasDxOrders">
						<xsl:call-template name="tempDxOrdersById">
							<xsl:with-param name="dxNomenId" select="./n:diagnosis-name/n:nomenclature"/>
							<xsl:with-param name="dxId" select="./@id"/>
							<xsl:with-param name="medOrders" select="$medOrders"/>
							<xsl:with-param name="nonMedOrders" select="$nonMedOrders"/>
						</xsl:call-template>
					</xsl:when>
						
					</xsl:choose>
					<!-- add space between diagnosis only when has at least one order that associated with a active diagnosis -->
					<xsl:if test="$hasDxOrders">
						<div style = "clear:both">
							<span><xsl:text disable-output-escaping="yes"> <![CDATA[&#160;]]></xsl:text></span>
						</div>
					</xsl:if>
				</div>
			</xsl:for-each>
	</xsl:template>

	<!-- main template -->
	<xsl:template match="/">
		
		<!-- dxList is the list of diagnoses which are qualified for display  -->		
		<xsl:variable name="dxList" as="element()*">
			<xsl:copy-of select="cdocfx:getDisplayableDiagnoses(n:report/n:clinical-data/n:diagnosis-data/n:clinical-diagnosis,$entityIdList)"/>
		</xsl:variable>
		
		<!-- Get qualified diagnosis nomenclature ids -->
		<xsl:variable name="dxNomenIDs" select="$dxList/n:diagnosis-name/n:nomenclature"/>	
		
		<!-- Get qualified diagnosis ids -->
		<xsl:variable name="dxId" select="$dxList/@id"/>
		
		<!-- Get all medication/non-medication orders that are associated to active diagnosis and which are placed by the given user -->
		<xsl:variable name="medsOrders" select="n:report/n:clinical-data/n:order-data/n:medication-order[cdocfx:isOrderAssociatedWithActiveDiagnosis(., $dxNomenIDs, $dxId, $dxList)and fn:not(cdocfx:isBannedOrder(.)) and @responsible-provider-id = $lUserId]"/>
		<xsl:variable name="nonMedsOrders" select="n:report/n:clinical-data/n:order-data/n:non-medication-order[cdocfx:isOrderAssociatedWithActiveDiagnosis(., $dxNomenIDs, $dxId, $dxList)and fn:not(cdocfx:isBannedOrder(.)) and @responsible-provider-id = $lUserId]"/>
		
		<!-- Get all medication/non-medication orders that are not associated with any active diagnosis and placed by the given user -->
		<xsl:variable name="addtnlMedsOrders" select="n:report/n:clinical-data/n:order-data/n:medication-order[fn:not(cdocfx:isOrderAssociatedWithActiveDiagnosis(., $dxNomenIDs, $dxId, $dxList)) and fn:not(cdocfx:isBannedOrder(.)) and @responsible-provider-id = $lUserId]"/>
		<xsl:variable name="addtnlNonMedsOrders" select="n:report/n:clinical-data/n:order-data/n:non-medication-order[fn:not(cdocfx:isOrderAssociatedWithActiveDiagnosis(., $dxNomenIDs, $dxId, $dxList)) and fn:not(cdocfx:isBannedOrder(.)) and @responsible-provider-id = $lUserId]"/>
		
		<xsl:variable name="hasAddtnlOrders" select="fn:exists($addtnlMedsOrders) or fn:exists($addtnlNonMedsOrders)" as="xs:boolean"/>
		<xsl:variable name="hasDxOrders" select="fn:exists($medsOrders)or fn:exists($nonMedsOrders)" as="xs:boolean"/>
		<xsl:variable name="addtnlTitle">
			<xsl:choose>
				<xsl:when test="fn:exists($dxList)">
					<xsl:value-of select="$AdditionalOrders"/>
				</xsl:when>
				<xsl:otherwise>
						<xsl:value-of select="$Ordered"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- Format diagnoses and associated orders -->
		<xsl:if test="fn:count($dxList)>0">
			<xsl:call-template name="tempClinicalDiagnoses">
				<xsl:with-param name="dxList" select="$dxList"/>
				<xsl:with-param name="medOrders" select="$medsOrders"/>
				<xsl:with-param name="nonMedOrders" select="$nonMedsOrders"/>
				<xsl:with-param name="hasDxOrders" select="$hasDxOrders"/>			
			</xsl:call-template>
		</xsl:if>

		<!-- format additional orders -->
		<xsl:if test="$hasAddtnlOrders">
			<!-- Generate EMR content item and text for additional orders -->
			<div class="ddemrcontentitem ddremovable" style = "clear:both">
				<xsl:attribute name="dd:entityid">
					<xsl:value-of select="0"/>
				</xsl:attribute>
				<xsl:value-of select="$AdditionalOrders" />
				<xsl:call-template name="tempOrderList">
					<xsl:with-param name="medsOrders" select="$addtnlMedsOrders"/>
					<xsl:with-param name="nonMedsOrders" select="$addtnlNonMedsOrders"/>
					<xsl:with-param name="text" select="fn:string('')"/>
				</xsl:call-template>
			</div>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>