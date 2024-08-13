<?xml version="1.0" encoding="UTF-8"?>
<?dynamic-document type="format" version="7.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:n="urn:com-cerner-patient-ehr:v3"
    xmlns:java-string="java:java.lang.String"
    xmlns:cdocfx="urn:com-cerner-physician-documentation-functions"
    xmlns:doc="java:com.cerner.documentation.extension.XSLTFuncs"
    xmlns:dd="DynamicDocumentation"
    exclude-result-prefixes="xsl xs fn n doc cdocfx java-string">
    
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    
    <xsl:param as="xs:string" name="current-locale" select="'en_US'"/>
    
    <!-- Backend system locale passed as a paramter -->
    <xsl:param as="xs:string" name="SystemLocale" select="''"/>
    
    <!-- Required to include CommonFxn.xslt -->
    <!-- Comment out this line to debug --> <xsl:include href="/cernerbasiccontent/formats/dxcommonfxn.xslt"/>
    <!-- Uncomment this line to debug <xsl:include href="DXCommonFxn.xslt"/> -->
    <!-- Comment out this line to debug --> <xsl:include href="/cernerbasiccontent/formats/medsadmincommon.xslt"/>
    <!-- Uncomment this line to debug <xsl:include href="MedsAdminCommon.xslt"/> -->
    
    <xsl:variable name="Separator" as="xs:string"> <!-- Seperator between detail components -->
        <xsl:value-of select="', %s'"/>
    </xsl:variable>
    <xsl:variable name="Connect" as="xs:string"> <!-- Connect two strings as one with a space in between -->
        <xsl:value-of select="'%s %s'"/>
    </xsl:variable>
    <xsl:variable name="Given" as="xs:string"> <!-- Label for Given Meds and Immunizations grouper -->
        <xsl:value-of select="'Given'"/>
    </xsl:variable>
    <xsl:variable name="NotGiven" as="xs:string"> <!-- Label for Not Given Immunizations grouper -->
        <xsl:value-of select="'Not Given'"/>
    </xsl:variable>
    <xsl:variable name="Period" as="xs:string">	<!-- Seperator between med order and diagnoses -->
        <xsl:value-of select="'. %s'"/>
    </xsl:variable>
    <xsl:variable name="For" as="xs:string"> <!-- Label for indicating Diagnoses -->
        <xsl:value-of select="'For: '"/>
    </xsl:variable>
   
    <xsl:variable name="medsAdminOrderIdsList" as="element()*"> <!-- List of Medication Order-Ids in Meds Admin Node -->
        <xsl:copy-of select="cdocfx:getMedsAdminOrderIdList(n:report/n:clinical-data/n:medication-administration-data)"/>
    </xsl:variable>
    
    <xsl:template match="n:report">
        
        <xsl:variable name="medAdminData" select="n:clinical-data/n:medication-administration-data"/>
        
        <!-- When the medication-administration-data list is present in the report, we should filter to only 
           medications that exist in medication-administration-data lists that are "given" -->
        <xsl:variable name="givenContinuousMedAdmins" 
            select="$medAdminData/n:continuous-medication-administration[count(n:not-given-reason) = 0]"/>
        <xsl:variable name="givenNonContinuousMedAdmins" 
            select="$medAdminData/n:non-continuous-medication-administration[count(n:not-given-reason) = 0]"/>
        
        <!-- Get the medication orders corresponding to given continuous medication administration data -->
        <xsl:variable name="givenContinuousMedAdminOrders" 
            select="n:clinical-data/n:order-data/n:medication-order[(@order-id = $givenContinuousMedAdmins/n:order/@order-id) or
            (@order-id = $givenContinuousMedAdmins/n:order/@template-order-id)]"/>
   
        <!-- Get the medication orders corresponding to given non-continuous medication administration data -->
        <xsl:variable name="givenNonContinuousMedAdminOrders" 
            select="n:clinical-data/n:order-data/n:medication-order[(@order-id = $givenNonContinuousMedAdmins/n:order/@order-id) or
            (@order-id = $givenNonContinuousMedAdmins/n:order/@template-order-id)]"/>
        
        <!-- Get all diagnosis -->
        <xsl:variable name="diagnoses" select="n:clinical-data/n:diagnosis-data"/>
        
        <!-- Get all immunizations -->
        <xsl:variable name="immunizations" select="n:clinical-data/n:immunizationV2-data"/>

        <xsl:call-template name="DisplayMedsAdminContent">
            <xsl:with-param name="givenContinuousMedAdmins" select="$givenContinuousMedAdmins"/>
            <xsl:with-param name="givenContinuousMedAdminOrders" select="$givenContinuousMedAdminOrders"/>
            <xsl:with-param name="givenNonContinuousMedAdmins" select="$givenNonContinuousMedAdmins"/>
            <xsl:with-param name="givenNonContinuousMedAdminOrders" select="$givenNonContinuousMedAdminOrders"/>
            <xsl:with-param name="immunizations" select="$immunizations"/>
            <xsl:with-param name="diagnoses" select="$diagnoses"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- Format to display medications and immunizations administered as ddemrcontentitem -->
    <xsl:template name="DisplayMedsAdminContent">
        <xsl:param name="givenContinuousMedAdmins"/>
        <xsl:param name="givenContinuousMedAdminOrders"/>
        <xsl:param name="givenNonContinuousMedAdmins"/>
        <xsl:param name="givenNonContinuousMedAdminOrders"/>
        <xsl:param name="immunizations"/>
        <xsl:param name="diagnoses"/>
       
        <!-- Build XML containing given and not-given immunizations, recorded immunizations are omitted -->
        <xsl:variable name="Immunizations">
            
            <xsl:if test="$immunizations/n:given">
                <xsl:for-each select="$immunizations/n:given[@is-uncharted = 'false'] ">
                <!-- Immunizations variable contains information such as comments,event-display etc
                     about all given and not given immunizations. -->
                <!-- Avoid displaying immunizations already displayed as administered meds. -->
                    <xsl:if test="cdocfx:shouldDisplayImmunization(.,$medsAdminOrderIdsList)">
                    <immunization status="given">
                        <xsl:attribute name="event-id">
                            <xsl:if test="@event-id">	
                                <xsl:value-of select="@event-id"/>
                            </xsl:if>	
                        </xsl:attribute>
                        <xsl:attribute name="event-display">
                            <xsl:if test="n:vaccine/n:event-type/@event-display">	
                                <xsl:value-of select="n:vaccine/n:event-type/@event-display"/>
                            </xsl:if>	
                        </xsl:attribute>
                        <xsl:attribute name="route">
                            <xsl:if test="@admin-route-code">	
                                <xsl:variable name="sRouteAdministration" as="xs:string" select="cdocfx:getCodeDisplayByID(@admin-route-code)"/>
                                <xsl:value-of select="$sRouteAdministration"/>
                            </xsl:if>	
                        </xsl:attribute> 
                        <xsl:for-each select="n:comment">
                            <comment>
                                <xsl:value-of select="n:comment"/>
                            </comment>
                        </xsl:for-each>
                    </immunization>
                  </xsl:if>
                </xsl:for-each>
            </xsl:if>
            
            <xsl:if test="$immunizations/n:not-given">
                <xsl:for-each select="$immunizations/n:not-given">
                    <immunization status="not-given">
                        <xsl:attribute name="event-id">
                            <xsl:if test="@event-id">	
                                <xsl:value-of select="@event-id"/>
                            </xsl:if>	
                        </xsl:attribute>
                        <xsl:attribute name="event-display">
                            <xsl:if test="n:vaccine/n:event-type/@event-display">	
                                <xsl:value-of select="n:vaccine/n:event-type/@event-display"/>
                            </xsl:if>	
                        </xsl:attribute>
                        <xsl:attribute name="not-given-reason">
                            <xsl:if test="@reason-code">	
                                <xsl:value-of select="cdocfx:getCodeDisplayByID(@reason-code)"/>
                            </xsl:if>	
                        </xsl:attribute>
                        <xsl:for-each select="n:comment">
                            <comment>
                                <xsl:value-of select="n:comment"/>
                            </comment>
                        </xsl:for-each>
                    </immunization>
                </xsl:for-each>
            </xsl:if> 
            
        </xsl:variable>
        
        <!-- Display Medications Administered and Given Immunizations as part of "Given" grouper -->
        <xsl:if test="count($givenContinuousMedAdminOrders)&gt;= 1 or count($givenNonContinuousMedAdmins)&gt;= 1 or $immunizations/n:given">
            <div class="ddgrouper ddremovable" dd:btnfloatingstyle="top-right">
                <span style="font-size:13pt;font-weight: bold;">
                    <xsl:value-of select="$Given"/>
                </span>
                
                <!-- Display Medications Administered -->
                
                <!-- Display Continuous Medications Administered -->
                <!-- For continuous medications administered, 
						•	If it’s a multi ingredient order, we display the reference name (Generic Name) and/or display mnemonic (Brand name) if different
                        •	If it’s a single ingredient, we display the medication ingredient name (Brand name) and dose from original order which will 
                            already have pre-built  dose information (ex: “Lactated Ringers Injection 1000 mL + Cod Liver Oil Mint 1 mL”)

                        For choosing dose, we use the following hierarchy from original order: strength, volume and then free text
                -->
                <xsl:call-template name="DisplayMedAdmins">
                    <xsl:with-param name="givenMedAdmins" select="$givenContinuousMedAdmins"/>
                    <xsl:with-param name="givenMedAdminsOrders" select="$givenContinuousMedAdminOrders"/>
                    <xsl:with-param name="diagnoses" select="$diagnoses"/>
                </xsl:call-template>
                
                <!-- Display Non Continuous Medications Administered -->
                <!-- For non-continuous medications administered, 
                        •	If it’s a multi ingredient order, we display the reference name (Generic Name) and/or display mnemonic (Brand name) if different
                        •	If it’s a single ingredient, we display the medication ingredient name (Brand name) and dose from original order which will 
                            already have pre-built  dose information (ex: “Lactated Ringers Injection 1000 mL + Cod Liver Oil Mint 1 mL”)

                        For choosing dose, we use the following hierarchy from original order: strength, volume and then free text
                -->
                 <xsl:call-template name="DisplayMedAdmins">
                    <xsl:with-param name="givenMedAdmins" select="$givenNonContinuousMedAdmins"/>
                    <xsl:with-param name="givenMedAdminsOrders" select="$givenNonContinuousMedAdminOrders"/>
                    <xsl:with-param name="diagnoses" select="$diagnoses"/>
                </xsl:call-template>
                
                <!-- Display "Given" Immunizations -->
                <xsl:for-each select="$Immunizations/immunization[@status='given']">          
                    <xsl:sort select="fn:upper-case(@event-display)" order="ascending"/>
                    <xsl:call-template name="DisplayImmunization">
                        <xsl:with-param name="Immunization" select="."/>
                    </xsl:call-template>
                </xsl:for-each>
            </div>
        </xsl:if>
        
        <!-- Display "Not Given" Immunizations as part of "Not Given" grouper -->
        <xsl:if test="$immunizations/n:not-given">
            <div class="ddgrouper ddremovable" dd:btnfloatingstyle="top-right">
                <span style="font-size:13pt;font-weight: bold;">
                    <xsl:value-of select="$NotGiven"/>
                </span>
                
                <xsl:for-each select="$Immunizations/immunization[@status='not-given']">
                    <xsl:sort select="fn:upper-case(@event-display)" order="ascending"/>
                    <xsl:call-template name="DisplayImmunization">
                        <xsl:with-param name="Immunization" select="."/>
                    </xsl:call-template>
                </xsl:for-each>
            </div>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="DisplayMedName">
        <xsl:param name="medAdminOrders"/>

        <xsl:choose>
            <xsl:when test="fn:exists($medAdminOrders/@clinical-name) and fn:string-length($medAdminOrders/@clinical-name) &gt; 0">
				<span style="font-weight:bold;">
					<xsl:value-of select="$medAdminOrders/@clinical-name"/>
				</span>
            </xsl:when>
            <xsl:when test="fn:exists($medAdminOrders/n:order-synonym/@order-catalog-id)">
				<span style="font-weight:bold;">
					<xsl:value-of select="cdocfx:getOrderCatalogName(n:order-synonym/@order-catalog-id)"/>
				</span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="''"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
    <!-- Get dose of the given non continuous med admin. Use medication ingredient dose information -->
    <!-- Parameters: -->
    <!--    MedAdminMedIngredient - medication ingredient element of given non continuous meds admin -->
    <xsl:function name="cdocfx:getMedAdminIngredientDose" as="xs:string">
        <xsl:param name="MedAdminMedIngredient"/>

        <xsl:choose>
            <!-- Dose -->
            <xsl:when test="$MedAdminMedIngredient/n:dose[@unit-code]">
                <!-- Remove Trailing Zeros based on Locale -->
                <xsl:variable name="dose" select="cdocfx:removeTrailingZeros($MedAdminMedIngredient/n:dose/@value, $SystemLocale)"/>
                <xsl:variable name="sUnit" as="xs:string" select="cdocfx:getCodeDisplayByID($MedAdminMedIngredient/n:dose/@unit-code)"/>
                <xsl:value-of select="java-string:format($Connect, ($dose, $sUnit))"/>
            </xsl:when>
            <!-- Initial Dose -->
            <xsl:when test="$MedAdminMedIngredient/n:initial-dose[@unit-code]">
                <!-- Remove Trailing Zeros based on Locale -->
                <xsl:variable name="initialDose" select="cdocfx:removeTrailingZeros($MedAdminMedIngredient/n:initial-dose/@value, $SystemLocale)"/>
                <xsl:variable name="sUnit" as="xs:string" select="cdocfx:getCodeDisplayByID($MedAdminMedIngredient/n:initial-dose/@unit-code)"/>
                <xsl:value-of select="java-string:format($Connect, ($initialDose, $sUnit))"/>
            </xsl:when>
            <!-- Volume -->
            <xsl:when test="$MedAdminMedIngredient/n:volume[@unit-code]">        
                <!-- Remove Trailing Zeros based on Locale -->
                <xsl:variable name="Volume" select="cdocfx:removeTrailingZeros($MedAdminMedIngredient/n:volume/@value, $SystemLocale)"/>
                <xsl:variable name="sUnit" as="xs:string" select="cdocfx:getCodeDisplayByID($MedAdminMedIngredient/n:volume/@unit-code)"/>
                <xsl:value-of select="java-string:format($Connect, ($Volume, $sUnit))"/>
            </xsl:when>
            <!-- Initial Volume -->
            <xsl:when test="$MedAdminMedIngredient/n:initial-volume[@unit-code]">        
                <!-- Remove Trailing Zeros based on Locale -->
                <xsl:variable name="initialVolume" select="cdocfx:removeTrailingZeros($MedAdminMedIngredient/n:initial-volume/@value, $SystemLocale)"/>
                <xsl:variable name="sUnit" as="xs:string" select="cdocfx:getCodeDisplayByID($MedAdminMedIngredient/n:initial-volume/@unit-code)"/>
                <xsl:value-of select="java-string:format($Connect, ($initialVolume, $sUnit))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="''"/>
            </xsl:otherwise>
        </xsl:choose>    
    </xsl:function>
    
    <!-- Get dose of the given continuous med admin. Use medication ingredient dose information -->
    <!-- Parameters: -->
    <!--    OrdersMedIngredient - medication ingredient element of given continuous meds admin -->
    <xsl:function name="cdocfx:getMedOrderIngredientDose" as="xs:string">
        <xsl:param name="OrdersMedIngredient"/>

        <xsl:choose>
            <!-- Strength -->
            <xsl:when test="$OrdersMedIngredient/n:dose[@strength-unit-code]">     
                <!-- Remove Trailing Zeros based on Locale -->
                <xsl:variable name="Strength" select="cdocfx:removeTrailingZeros($OrdersMedIngredient/n:dose/@strength, $SystemLocale)"/>
                <xsl:variable name="sUnit" as="xs:string" select="cdocfx:getCodeDisplayByID($OrdersMedIngredient/n:dose/@strength-unit-code)"/>
                <xsl:value-of select="java-string:format($Connect, ($Strength, $sUnit))"/>
            </xsl:when>
            <!-- Volume -->
            <xsl:when test="$OrdersMedIngredient/n:dose[@volume-unit-code]">
                <!-- Remove Trailing Zeros based on Locale -->
                <xsl:variable name="Volume" select="cdocfx:removeTrailingZeros($OrdersMedIngredient/n:dose/@volume, $SystemLocale)"/>
                <xsl:variable name="sUnit" as="xs:string" select="cdocfx:getCodeDisplayByID($OrdersMedIngredient/n:dose/@volume-unit-code)"/>
                <xsl:value-of select="java-string:format($Connect, ($Volume, $sUnit))"/>
            </xsl:when>
            <!-- Free Text Dose -->
            <xsl:when test="$OrdersMedIngredient/n:dose[@freetext-dose]">
                <xsl:value-of select="$OrdersMedIngredient/n:dose/@freetext-dose"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="''"/>
            </xsl:otherwise>
        </xsl:choose>   
    </xsl:function>
       
    <xsl:template name="DisplayMedAdmins">
        <xsl:param name="givenMedAdmins"/>
        <xsl:param name="givenMedAdminsOrders"/>
        <xsl:param name="diagnoses"/>

        <!-- Sort medication order types by reference-name (Generic Name) ascending -->
        <xsl:for-each select="$givenMedAdminsOrders">
            <xsl:sort select="fn:upper-case(@reference-name)" order="ascending"/>
            <div class="ddemrcontentitem ddremovable" style="margin-left: 1em; padding-left:1em; text-indent:-1em;">
                <xsl:variable name="orderId" select="./@order-id"/>

                <!-- Get the med admin corresponding to medication order -->
                <xsl:variable name="MedsAdmin" select="$givenMedAdmins[(n:order/@order-id = $orderId) or n:order/@template-order-id = $orderId]"/>

                <!-- Use first encountered med admin instance event-id as entity id -->
                <xsl:attribute name="dd:entityid">
                    <xsl:value-of select="$MedsAdmin[1]/@event-id"/>
                </xsl:attribute>

                <xsl:attribute name="dd:contenttype">
                    <xsl:text>MEDS_ADMIN</xsl:text>
                </xsl:attribute>

                <xsl:choose>
                    <xsl:when test="(./@reference-name or ./@display-mnemonic) and count(n:medication-ingredient) &gt; 1">
						<xsl:call-template name="APandOrdersNameDisplay">
							<xsl:with-param name="order" select="."/>
						</xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$givenMedAdmins/local-name() = 'continuous-medication-administration'"> 
                                <xsl:for-each select="n:medication-ingredient">
                                    <xsl:call-template name="DisplayMedName">
                                        <xsl:with-param name="medAdminOrders" select="."/>
                                    </xsl:call-template>
                                    <!-- Dose -->
                                    <xsl:variable name="Dose" as="xs:string">
                                        <xsl:value-of select="cdocfx:getMedOrderIngredientDose(.)"/>
                                    </xsl:variable>            
                                    <xsl:if test="$Dose != ''">	
                                        <xsl:value-of select="java-string:format($Separator, $Dose)"/> 
                                    </xsl:if> 

                                    <xsl:if test="fn:not(fn:position() = fn:last())">
                                        <xsl:text disable-output-escaping="yes"><![CDATA[&#160;]]>+<![CDATA[&#160;]]></xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="$givenMedAdmins/local-name() = 'non-continuous-medication-administration' and count(n:medication-ingredient) = 1">
                                <xsl:call-template name="DisplayMedName">
                                    <xsl:with-param name="medAdminOrders" select="n:medication-ingredient"/>
                                </xsl:call-template>
                                <!-- This xsl:for-each is added to avoid the sax parser issue while importing th content -->
                                <xsl:for-each select="$MedsAdmin/n:medication-ingredient">
                                    <!-- Dose -->
                                        <xsl:variable name="Dose" as="xs:string">
                                        <xsl:value-of select="cdocfx:getMedAdminIngredientDose(.)"/>
                                    </xsl:variable>            
                                    <xsl:if test="$Dose != ''">	
                                        <xsl:value-of select="java-string:format($Separator, $Dose)"/>
                                    </xsl:if>
                                </xsl:for-each> 
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:for-each select="$MedsAdmin/n:medication-ingredient">
								    <xsl:value-of select="cdocfx:getOrderCatalogName(n:order-synonym/@order-catalog-id)"/>
                                     <!-- Dose -->
                                     <xsl:variable name="Dose" as="xs:string">                                  
                                        <xsl:value-of select="cdocfx:getMedAdminIngredientDose(.)"/>
                                    </xsl:variable>            
                                    <xsl:if test="$Dose != ''">
                                        <xsl:value-of select="java-string:format($Separator, $Dose)"/>
                                    </xsl:if> 
                                    <xsl:if test="fn:not(fn:position() = fn:last())">
                                        <xsl:text disable-output-escaping="yes"><![CDATA[&#160;]]>+<![CDATA[&#160;]]></xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- Route of administration -->
                <xsl:variable name="sRouteAdministration" as="xs:string" select="cdocfx:getCodeDisplayByID(if(@route-code) then @route-code else if(@route-of-administration-code) then @route-of-administration-code else '' )"/>
                <xsl:value-of select="java-string:format($Separator, $sRouteAdministration)"/>

                <!-- Display diagnoses and indication associated with the order -->
                <xsl:call-template name="DisplayDiagnosisIndication">
                    <xsl:with-param name="order" select="."/>
                    <xsl:with-param name="diagnoses" select="$diagnoses"/>
                </xsl:call-template> 

            </div>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="DisplayDiagnosisIndication">
        <xsl:param name="order"/>
        <xsl:param name="diagnoses"/>
        
        <xsl:choose>
            <xsl:when test="$order/n:diagnosis or $order/n:indication">
                <span class="ddremovable">
                    <xsl:value-of select="java-string:format($Period, $For)"/>
                </span>
                <xsl:if test="$order/n:diagnosis">
                    <xsl:variable name="GroupId" select="$order/n:diagnosis/@group-id"/>
                    <xsl:call-template name="DisplayDiagnoses">
                        <xsl:with-param name="dxList" select="$diagnoses/*[(@id=$GroupId) and (@is-active='true')]"/>
                    </xsl:call-template>
                </xsl:if>
                
                <xsl:choose>
                    <xsl:when test="$order/n:indication">
                        <xsl:if test="count($diagnoses/*[(@id=$order/n:diagnosis/@id) and (@is-active='true')]) &gt; 0">
                            <xsl:text disable-output-escaping="yes">,<![CDATA[&#160;]]></xsl:text>
                        </xsl:if>
                        <xsl:for-each select="$order/n:indication">
                            <xsl:choose>
                                <xsl:when test="n:code">
                                    <span class="ddremovable">
                                        <xsl:if test="fn:not(fn:position() = 1)">
                                            <xsl:text disable-output-escaping="yes">,<![CDATA[&#160;]]></xsl:text>
                                        </xsl:if>
                                        <xsl:value-of select="cdocfx:getCodeDisplayByID(n:code)"/>
                                    </span>
                                </xsl:when>
                                <xsl:when test="n:freetext">
                                    <span class="ddremovable">
                                        <xsl:if test="fn:not(fn:position() = 1)">
                                            <xsl:text disable-output-escaping="yes">,<![CDATA[&#160;]]></xsl:text>
                                        </xsl:if>
                                        <xsl:value-of select="n:freetext" />
                                    </span>
                                </xsl:when>	
                                <xsl:otherwise>
                                    <xsl:value-of select="''"/>
                                </xsl:otherwise>
                            </xsl:choose>          
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="''"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
     </xsl:template>
    
    <xsl:template name="DisplayImmunization">
        <xsl:param name = "Immunization"/>
        
        <div class="ddemrcontentitem ddremovable" style="margin-left: 1em; padding-left:1em; text-indent:-1em;">
            <xsl:attribute name="dd:entityid">
                <xsl:if test="$Immunization/@event-id">	
                    <xsl:value-of select="$Immunization/@event-id"/>
                </xsl:if>	
            </xsl:attribute>
            <xsl:attribute name="dd:contenttype">
                <xsl:text>IMMUNZTNS_V2</xsl:text>
            </xsl:attribute>
            
            <xsl:if test="$Immunization/@event-display">
                <xsl:value-of select="$Immunization/@event-display"/>
            </xsl:if>
     
            <xsl:choose>
                <xsl:when test="$Immunization/@status='given'">
                    <xsl:if test="$Immunization/@route">
                        <xsl:variable name="routeAdmin" as="xs:string" select="$Immunization/@route"/>
                        <xsl:value-of select="java-string:format($Separator, $routeAdmin)"/>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="$Immunization/@status='not-given'">
                    <xsl:if test="$Immunization/@not-given-reason">
                        <xsl:variable name="notGivenReason" as="xs:string" select="$Immunization/@not-given-reason"/>
                        <xsl:value-of select="java-string:format($Separator, $notGivenReason)"/>
                    </xsl:if>
                </xsl:when>
            </xsl:choose>
            
            <xsl:if test="$Immunization/comment">
                <xsl:text disable-output-escaping="yes">,<![CDATA[&#160;]]></xsl:text>
                <xsl:for-each select="$Immunization/comment">
                    <xsl:variable name="Comment" as="xs:string">
                        <xsl:value-of select="."/>
                    </xsl:variable>
                    <xsl:value-of disable-output-escaping="yes" select="doc:convertPlainTextToHtml($Comment)"/>
                    <xsl:if test="fn:not(fn:position() = fn:last())">
                        <xsl:text disable-output-escaping="yes">,<![CDATA[&#160;]]></xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
        </div>
    </xsl:template>
    
    <xsl:template name="DisplayDiagnoses">
        <xsl:param name="dxList"/>
        
        <xsl:for-each select="$dxList">
            <xsl:sort select="cdocfx:getDxPriority(.)" order="ascending"/>
            <xsl:sort select="fn:upper-case(cdocfx:getDxDisplay(.))" order="ascending"/>
            
            <span class="ddemrcontentitem ddremovable">
                <!-- Format diagnosis item -->
                <xsl:attribute name="dd:entityid">
                    <xsl:value-of select="@id"/>
                </xsl:attribute>
                <xsl:attribute name="dd:contenttype">
                    <xsl:text>DIAGNOSES</xsl:text>
                </xsl:attribute>
                <xsl:if test="fn:not(fn:position() = 1)">
                    <xsl:text disable-output-escaping="yes">,<![CDATA[&#160;]]></xsl:text>
                </xsl:if>
                <xsl:value-of select="cdocfx:getDxDisplay(.)"/>
            </span>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>