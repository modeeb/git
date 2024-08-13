<?xml version="1.0" encoding="UTF-8"?>
<?dynamic-document type="format" version="7.0"?>
<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xr-date-formatter="java:com.cerner.xsl.util.XSLTDateUtilities"
    xmlns:n="urn:com-cerner-patient-ehr:v3"
	xmlns:cdocfx="urn:com-cerner-physician-documentation-functions"
    xmlns:dd="DynamicDocumentation"
    exclude-result-prefixes="xsl xs n xr-date-formatter dd cdocfx">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <xsl:param as="xs:string" name="current-locale" select="'en_US'"/>

    <!-- required to include CommonFxn.xslt -->
    <!-- Comment this line to debug --> <xsl:include href="/cernerbasiccontent/formats/commonfxn.xslt" />
    <!-- Uncomment this line to debug <xsl:include href="commonfxn.xslt" /> -->

    <!-- Default string constants -->
    <xsl:variable name="DOB" as="xs:string">
        <xsl:value-of select="'DOB:'"/>
    </xsl:variable>

    <xsl:variable name="MRN" as="xs:string">
        <xsl:value-of select="'MRN:'"/>
    </xsl:variable>

    <xsl:variable name="RegDtTm" as="xs:string">
        <xsl:value-of select="'Visit Time:'"/>
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
	
	<!-- isDisplayNurseUnit will be overwritten by the locale specific format. If true, format will display the Nurse Unit and phone number if present -->
	<xsl:variable name="isDisplayNurseUnit" as="xs:boolean" select="false()"/>
	
	<!-- isDisplayFacility will be overwritten by the locale specific format. If true, format will display the Facility and phone number if present -->
	<xsl:variable name="isDisplayFacility" as="xs:boolean" select="false()"/>

    <xsl:variable name="DATE_ONLY_SEQUENCE" as="xs:string" select="'MM/dd/yyyy'"/>
	
	<!-- Keys -->
	<xsl:key name="keylocation" match="n:report/n:location-list/n:location" use="@id"/>
	
	<xsl:template name="Facility">
		<xsl:param name="FacilityID"/>
		
		<xsl:if test="key('keylocation', $FacilityID, $root-node)/@name">
			<div class="ddgrouper ddremovable" dd:btnfloatingstyle="top-right">
				<span style="font-weight: bold;"><xsl:value-of select="$Facility"/></span>
				<span style="margin-left:1ex;"><xsl:value-of select="key('keylocation', $FacilityID, $root-node)/@name"/></span>
			</div>
		</xsl:if>			
		<xsl:if test="key('keylocation', $FacilityID, $root-node)/@business-phone">
			<div class="ddgrouper ddremovable" dd:btnfloatingstyle="top-right">
				<span style="font-weight: bold;"><xsl:value-of select="$FacilityPhone"/></span>
				<span style="margin-left:1ex;"><xsl:value-of select="key('keylocation', $FacilityID, $root-node)/@business-phone"/></span>
			</div>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="NurseUnit">
		<xsl:param name="NurseUnitID"/>
		
		<xsl:if test="key('keylocation', $NurseUnitID, $root-node)/@name">
			<div class="ddgrouper ddremovable" dd:btnfloatingstyle="top-right">
				<span style="font-weight: bold;"><xsl:value-of select="$NurseUnit"/></span>
				<span style="margin-left:1ex;"><xsl:value-of select="key('keylocation', $NurseUnitID, $root-node)/@name"/></span>
			</div>
		</xsl:if>			
		<xsl:if test="key('keylocation', $NurseUnitID, $root-node)/@business-phone">
			<div class="ddgrouper ddremovable" dd:btnfloatingstyle="top-right">
				<span style="font-weight: bold;"><xsl:value-of select="$NursePhone"/></span>
				<span style="margin-left:1ex;"><xsl:value-of select="key('keylocation', $NurseUnitID, $root-node)/@business-phone"/></span>
			</div>
		</xsl:if>
	</xsl:template>
	
    <xsl:template match="/">
        <xsl:if test="n:report/n:demographics/n:patient-info">
            <div class="ddemrcontentitem ddremovable" dd:btnfloatingstyle="top-right">
                <xsl:attribute name="dd:entityid">
                    <xsl:if test="n:report/n:clinical-data/n:encounter-data/n:encounter/@encounter-id">
                        <xsl:value-of select="n:report/n:clinical-data/n:encounter-data/n:encounter/@encounter-id"/>
                    </xsl:if>
                </xsl:attribute>
                <xsl:attribute name="dd:contenttype">
                    <xsl:text>ENCNTRINFO</xsl:text>
                </xsl:attribute>
                <table style="width:100%">
                    <tr>
                        <td>
                            <xsl:if test="n:report/n:demographics/n:patient-info/n:patient-name/@name-full">
                                <span style="font-size:20pt;"><xsl:value-of select="n:report/n:demographics/n:patient-info/n:patient-name/@name-full"/></span>
                            </xsl:if>
                        </td>
						<td>
							<xsl:if test="$isDisplayFacility and n:report/n:clinical-data/n:encounter-data/n:encounter/@facility-id">
								<xsl:call-template name="Facility">
									<xsl:with-param name="FacilityID" select="n:report/n:clinical-data/n:encounter-data/n:encounter/@facility-id"/>
								</xsl:call-template>
							</xsl:if>
							<xsl:if test="$isDisplayNurseUnit and n:report/n:clinical-data/n:encounter-data/n:encounter/@ward-id">
								<xsl:call-template name="NurseUnit">
									<xsl:with-param name="NurseUnitID" select="n:report/n:clinical-data/n:encounter-data/n:encounter/@ward-id"/>
								</xsl:call-template>	
							</xsl:if>
						</td>						
                        <td style="float: left;">
                            <xsl:if test="n:report/n:demographics/n:patient-info/n:birth-dt-tm/n:date">
                                <div class="ddgrouper ddremovable" dd:btnfloatingstyle="top-right">
                                    <span style ="font-weight: bold"><xsl:value-of select="$DOB"/></span>
                                    <xsl:variable name="DateTime" as="xs:dateTime" select="n:report/n:demographics/n:patient-info/n:birth-dt-tm/n:date"/>
                                    <xsl:variable name="TimeZone" as="xs:string" select="n:report/n:demographics/n:patient-info/n:birth-dt-tm/n:date/@time-zone"/>
                                    <span style="margin-left:1ex;"><xsl:value-of select="xr-date-formatter:formatDate($DateTime, $DATE_ONLY_SEQUENCE, $TimeZone, $current-locale)"/></span>
                                </div>
                            </xsl:if>
                            <xsl:if test="n:report/n:clinical-data/n:encounter-data/n:encounter/@mrn">
                                <div class="ddgrouper ddremovable" dd:btnfloatingstyle="top-right">
                                    <span style ="font-weight: bold"><xsl:value-of select="$MRN"/></span>
                                    <span style="margin-left:1ex;"><xsl:value-of select="n:report/n:clinical-data/n:encounter-data/n:encounter/@mrn"/></span>
                                </div>
                            </xsl:if>
                            <xsl:if test="n:report/n:clinical-data/n:encounter-data/n:encounter/n:registration-dt-tm">
                                <div class="ddgrouper ddremovable" dd:btnfloatingstyle="top-right">
                                    <span style ="font-weight: bold"><xsl:value-of select="$RegDtTm"/></span>
                                        <xsl:variable name="DateTime" as="xs:dateTime" select="n:report/n:clinical-data/n:encounter-data/n:encounter/n:registration-dt-tm"/>
                                        <xsl:variable name="TimeZone" as="xs:string" select="n:report/n:clinical-data/n:encounter-data/n:encounter/n:registration-dt-tm/@time-zone"/>
                                    <span style="margin-left:1ex;"><xsl:value-of select="xr-date-formatter:formatDate($DateTime, $DATE_ONLY_SEQUENCE, $TimeZone, $current-locale)"/></span>
                                </div>
                            </xsl:if>
                        </td>
                    </tr>
                </table>
            </div>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>