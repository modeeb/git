<?xml version="1.0" encoding="UTF-8"?>
<?dynamic-document type="format" version="7.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:n="urn:com-cerner-patient-ehr:v3"
	xmlns:dd="DynamicDocumentation"
	xmlns:java-string="java:java.lang.String"
	exclude-result-prefixes="xsl xs n dd java-string">
	
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	
	<xsl:param as="xs:string" name="current-locale" select="'en_US'"/>
	
	<!-- required to include CommonFxn.xslt -->
	<!-- Comment this line to debug --> <xsl:include href="/cernerbasiccontent/formats/commonfxn.xslt" />
	<!-- Uncomment this line to debug <xsl:include href="commonfxn.xslt" /> -->
	
	<!-- Default string constants -->
	<xsl:variable name="admittingDocCDFMeaning" as="xs:string" select="'ADMITDOC'"/>
	
	<xsl:variable name="attendingDocCDFMeaning" as="xs:string" select="'ATTENDDOC'"/>
	
	<xsl:variable name="consultingDocCDFMeaning" as="xs:string" select="'CONSULTDOC'"/>
	
	<xsl:variable name="primaryCareDocCDFMeaning" as="xs:string" select="'PCP'"/>
	
	<xsl:variable name="referringDocCDFMeaning" as="xs:string" select="'REFERDOC'"/>
	
	<xsl:variable name="commaSeparator" as="xs:string" select="', %s'"/>
	
	<xsl:variable name="hyphenSeparator" as="xs:string" select="' -'"/>
	
	<!-- Keys -->
	<xsl:key name="keyCode" match="n:report/n:code-list/n:code" use="@code"/>
	<xsl:key name="keyPersonnel" match="n:report/n:personnel-list/n:personnel" use="@prsnl-id"/>

	<!-- This template is used to create a temporary structure with all of the information needed for displaying the care team. -->
	<!-- Parameters: -->
	<!-- providerElements - The elements in the input xml that represent providers (Ex. n:report/n:demographics/n:encounter-info/n:provider). -->
	<!-- providerCDFMeaning - The cdf meaning of the relation-code indicating the provider type. -->
	<xsl:template name="buildProviders">
		<xsl:param name="providerElements"/>
		<xsl:param name="providerCDFMeaning" as="xs:string"/>
		
		<!-- Check for @relation-code and then group by @prsnl-id and then by @relation-code. -->
		<!-- Then display the first position in each group to ensure no duplicate @prsnl-ids/names are displayed per @relation-code. -->
		<xsl:if test="$providerElements[@relation-code]">
			<xsl:for-each-group select="$providerElements" group-by="@prsnl-id">
				<xsl:for-each-group select="current-group()" group-by="@relation-code">
					<xsl:for-each select="current-group()">
						<xsl:if test="position()=1">
							<xsl:if test="key('keyCode', @relation-code)/@meaning = $providerCDFMeaning">
								<provider>
									<xsl:attribute name="providerLabel">
										<xsl:value-of select="key('keyCode', @relation-code)/@display" />
									</xsl:attribute>
									
									<xsl:variable name="providerName" select="key('keyPersonnel', @prsnl-id)/n:provider-name"/>
									
									<xsl:attribute name="nameFull">
										<!-- @name-full is a required field -->
										<xsl:value-of select="$providerName/@name-full"/>
									</xsl:attribute>
									
									<xsl:attribute name="nameLast">
										<xsl:value-of select="$providerName/@name-last"/>
									</xsl:attribute>
									
									<!-- Uncomment the section below to show provider phone numbers -->
									<!--<xsl:if test="key('keyPersonnel', @prsnl-id)/@business-phone">
										<xsl:attribute name="phoneNumber">
											<xsl:value-of select="key('keyPersonnel', @prsnl-id)/@business-phone"/>
										</xsl:attribute>
									</xsl:if>-->
								</provider>
							</xsl:if>
						</xsl:if>
					</xsl:for-each>
				</xsl:for-each-group>
			</xsl:for-each-group>
		</xsl:if>
	</xsl:template>

	<!-- This template is used to display the providers for the given cdf meaning. -->
	<!-- Parameters: -->
	<!-- providerCDFMeaning - The cdf meaning of the relation-code indicating the provider type. -->
	<xsl:template name="displayProviderInformation">
		<xsl:param name="providerCDFMeaning" as="xs:string" />
		
		<xsl:variable name="careProviders">
			<xsl:if test="$providerCDFMeaning = $primaryCareDocCDFMeaning">
				<!-- Check lifetime patient-provider relationship (PPR) for PCP, and then check Encounter patient-provider relationship (PPR) for PCP -->
				<xsl:call-template name="buildProviders">
					<xsl:with-param name="providerElements" select="n:report/n:demographics/n:patient-info/n:patient-provider"/>
					<xsl:with-param name="providerCDFMeaning" select="$providerCDFMeaning"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:call-template name="buildProviders">
				<xsl:with-param name="providerElements" select="n:report/n:demographics/n:encounter-info/n:provider"/>
				<xsl:with-param name="providerCDFMeaning" select="$providerCDFMeaning"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:if test="n:report/n:clinical-data/n:encounter-data/n:encounter">
			<!-- Only the current encounter will be returned. We can safely assume that there is only one <encounter> element. -->

			<!-- @relation-code will be used to look up for provider. @relation-code is an optional attribute, so we need to check it before emitting the row for any provider. -->
			<xsl:if test="$careProviders/provider">
				<div class="ddemrcontentitem ddremovable" dd:btnfloatingstyle="top-right" style="clear: both; overflow: hidden; margin-bottom: 5px;">
					<xsl:attribute name="dd:entityid">
						<xsl:if test="n:report/n:clinical-data/n:encounter-data/n:encounter/@encounter-id">
							<xsl:value-of select="n:report/n:clinical-data/n:encounter-data/n:encounter/@encounter-id"/>
						</xsl:if>
					</xsl:attribute>
					<xsl:attribute name="dd:contenttype">
						<xsl:text>ENCNTRINFO</xsl:text>
					</xsl:attribute>
					
					<div style="float: left; font-weight: bold;">
						<xsl:value-of select="concat($careProviders/provider[1]/@providerLabel, $hyphenSeparator)" />
					</div>
					<div style="float: left; margin-left: 5px;">
						<xsl:for-each select="$careProviders/provider">
							<xsl:sort select="@nameLast" order="ascending"/>
							
							<div class="ddgrouper ddremovable" dd:btnfloatingstyle="top-right">
								<!-- @name-full is a required field -->
								<xsl:value-of select="@nameFull"/>
							
								<!-- Uncomment the section below to show provider phone numbers -->
								<!--<xsl:if test="@phoneNumber">
									<xsl:variable name="phone" select="@phoneNumber" as="xs:string"/>
									<xsl:value-of select="java-string:format($commaSeparator, $phone)"/>
								</xsl:if>-->
							</div>	
						</xsl:for-each>
					</div>
				</div>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="/">
	
	    <!-- Sorted in Ascending order-->
		
		<xsl:call-template name="displayProviderInformation">
			<xsl:with-param name="providerCDFMeaning" select="$admittingDocCDFMeaning"/>
		</xsl:call-template>
	
		<xsl:call-template name="displayProviderInformation">
			<xsl:with-param name="providerCDFMeaning" select="$attendingDocCDFMeaning"/>
		</xsl:call-template>
	
		<xsl:call-template name="displayProviderInformation">
			<xsl:with-param name="providerCDFMeaning" select="$consultingDocCDFMeaning"/>
		</xsl:call-template>
			
		<xsl:call-template name="displayProviderInformation">
			<xsl:with-param name="providerCDFMeaning" select="$primaryCareDocCDFMeaning"/>
		</xsl:call-template>
				
		<xsl:call-template name="displayProviderInformation">
			<xsl:with-param name="providerCDFMeaning" select="$referringDocCDFMeaning"/>
		</xsl:call-template>
		
	</xsl:template>
	
</xsl:stylesheet>