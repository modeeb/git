<?xml version="1.0" encoding="UTF-8"?>
<?dynamic-document type="format" version="8.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:n="urn:com-cerner-patient-ehr:v3"
	xmlns:dd="DynamicDocumentation"
	exclude-result-prefixes="xsl xs n dd">
	
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	<xsl:param as="xs:string" name="current-locale" select="'en_US'"/>
	
	<!-- required to include CommonFxn.xslt -->
	<!-- Comment this line to debug --> <xsl:include href="/cernerbasiccontent/formats/commonfxn.xslt" />
	<!-- Uncomment this line to debug <xsl:include href="commonfxn.xslt" /> -->
	
	<!-- Default string constants -->
	<xsl:variable name="New" as="xs:string">
		<xsl:value-of select="'New'"/>
	</xsl:variable>
	
	<xsl:variable name="Changed" as="xs:string">
		<xsl:value-of select="'Changed'"/>
	</xsl:variable>
	
	<xsl:variable name="Unchanged" as="xs:string">
		<xsl:value-of select="'Unchanged'"/>
	</xsl:variable>
	
	<xsl:variable name="StopTaking" as="xs:string">
		<xsl:value-of select="'Discontinued'"/>
	</xsl:variable>
	
	
	<xsl:template match="/">
		<xsl:if test="n:report/n:clinical-data/n:reconciliation-report-data/n:reconciliation-report-order[@report-order-type='FILL']">
			<div style="padding-bottom:1em;" class="ddgrouper ddremovable" dd:btnfloatingstyle="top-right">
				<div  style="text-decoration:underline;"><xsl:value-of select="$New"/></div>
				<xsl:for-each select="n:report/n:clinical-data/n:reconciliation-report-data/n:reconciliation-report-order[@report-order-type='FILL']">
					<xsl:call-template name="DisplayMed">
						<xsl:with-param name="Med" select="."/>
					</xsl:call-template>
				</xsl:for-each>
			</div>
		</xsl:if>
		
		<xsl:if test="n:report/n:clinical-data/n:reconciliation-report-data/n:reconciliation-report-order[@report-order-type='CONTINUE_WITH_CHANGES']">
			<div style="padding-bottom:1em;" class="ddgrouper ddremovable" dd:btnfloatingstyle="top-right">
				<div  style="text-decoration:underline;"><xsl:value-of select="$Changed"/></div>
				<xsl:for-each select="n:report/n:clinical-data/n:reconciliation-report-data/n:reconciliation-report-order[@report-order-type='CONTINUE_WITH_CHANGES']">
					<xsl:call-template name="DisplayMed">
						<xsl:with-param name="Med" select="."/>
					</xsl:call-template>
				</xsl:for-each>
			</div>
		</xsl:if>
		
		<xsl:if test="n:report/n:clinical-data/n:reconciliation-report-data/n:reconciliation-report-order[@report-order-type='CONTINUE' or @report-order-type='CONTACT_PHYSICIAN']">
			<div style="padding-bottom:1em;" class="ddgrouper ddremovable" dd:btnfloatingstyle="top-right">
				<div  style="text-decoration:underline;"><xsl:value-of select="$Unchanged"/></div>
				<xsl:for-each select="n:report/n:clinical-data/n:reconciliation-report-data/n:reconciliation-report-order[@report-order-type='CONTINUE' or @report-order-type='CONTACT_PHYSICIAN']">
					<xsl:call-template name="DisplayMed">
						<xsl:with-param name="Med" select="."/>
					</xsl:call-template>
				</xsl:for-each>
			</div>
		</xsl:if>
		
		<xsl:if test="n:report/n:clinical-data/n:reconciliation-report-data/n:reconciliation-report-order[@report-order-type='STOP']">
			<div style="padding-bottom:1em;" class="ddgrouper ddremovable" dd:btnfloatingstyle="top-right">
				<div  style="text-decoration:underline;"><xsl:value-of select="$StopTaking"/></div>
				<xsl:for-each select="n:report/n:clinical-data/n:reconciliation-report-data/n:reconciliation-report-order[@report-order-type='STOP']">
					<xsl:call-template name="DisplayMed">
						<xsl:with-param name="Med" select="."/>
					</xsl:call-template>
				</xsl:for-each>
			</div>	
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="DisplayMed">
		<xsl:param name="Med"/>
		<div class="ddemrcontentitem ddremovable" style="margin-left:1em;">
			<xsl:attribute name="dd:entityid">
				<xsl:if test="$Med/@order-id">
					<xsl:value-of select="$Med/@order-id"/>
				</xsl:if>
			</xsl:attribute>
			<xsl:attribute name="dd:contenttype">
				<xsl:text>MEDS_REC</xsl:text>
			</xsl:attribute>
			
			<span style="padding-right:4px;font-weight:bold;"><xsl:value-of select="$Med/@order-name"/></span>			
			<xsl:value-of select="$Med/@order-detail-line"/>		
		</div>
	</xsl:template>
</xsl:stylesheet>
