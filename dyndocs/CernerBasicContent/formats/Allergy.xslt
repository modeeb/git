<?xml version="1.0" encoding="UTF-8"?>
<?dynamic-document type="format" version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:n="urn:com-cerner-patient-ehr:v3"
	xmlns:cdocfx="urn:com-cerner-physician-documentation-functions"
	xmlns:dd="DynamicDocumentation"
	xmlns:java-string="java:java.lang.String"
	exclude-result-prefixes="xsl xs fn n cdocfx java-string">

	<xsl:output method="html" encoding="UTF-8" indent="yes"/>

	<xsl:param as="xs:string" name="current-locale" select="'en_US'"/>
	<!-- required to include CommonFxn.xslt -->
	<!-- Comment this line to debug --> <xsl:include href="/cernerbasiccontent/formats/commonfxn.xslt" />
	<!-- Uncomment this line to debug  <xsl:include href="commonfxn.xslt" /> -->

	<!-- Default string constants -->
	<xsl:variable name="ReactionParentheses" as="xs:string">
		<xsl:value-of select="'%s'"/>
	</xsl:variable>

	<xsl:variable name="Reactions" as="xs:string">
		<xsl:value-of select="'%s, %s'"/>
	</xsl:variable>
	
	<xsl:variable name="Separator" as="xs:string">
		<xsl:value-of select="' (%s)'"/>
	</xsl:variable>

	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="n:report/n:clinical-data/n:allergy-data/n:allergy">
				<xsl:for-each select="n:report/n:clinical-data/n:allergy-data/n:allergy">
					<!-- First, we sort by sequence -->
					<xsl:sort select="cdocfx:get-sequence(n:allergy-instance)"
						data-type="text" order="descending"/>
					<!-- then, we sort by display name -->
					<xsl:sort select="n:allergy-name/@display" order="ascending"/>
					<div class="ddemrcontentitem ddremovable">
						<xsl:attribute name="dd:entityid">
							<xsl:value-of select="@allergy-id"/>
						</xsl:attribute>
						<xsl:attribute name="dd:contenttype">
							<xsl:text>ALLERGIES</xsl:text>
						</xsl:attribute>
						
						<!-- Allergy Name -->
						<!-- When Allergy is marked as Severe, display Allergy Name in red, else normal color -->
						<xsl:choose>
							<xsl:when test="exists(n:allergy-instance/@severity-code) and cdocfx:getCodeMeanByID(n:allergy-instance/@severity-code)='SEVERE'">
								<span style="color:#CC0000;">
									<xsl:value-of select="n:allergy-name/@display"/>
								</span>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="n:allergy-name/@display"/>
							</xsl:otherwise>
						</xsl:choose>
						
						<!-- Allergy Severity -->
						<!-- When Allergy Severity is marked as Severe, display indicator icon and Severe in red, else normal color -->
						<xsl:choose>
							<xsl:when test="exists(n:allergy-instance/@severity-code) and cdocfx:getCodeMeanByID(n:allergy-instance/@severity-code)='SEVERE'">
								<span style="padding-left: 2px;">
									<xsl:text>(</xsl:text>
									<xsl:copy-of select="$CriticalRangeImage"/>
									<span style="padding-left: 2px; color:#CC0000;">
									<xsl:value-of select="cdocfx:getCodeDisplayByID(n:allergy-instance/@severity-code)"/>
									</span>
									<xsl:text>)</xsl:text>
								</span>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="exists(n:allergy-instance/@severity-code)">
									<xsl:variable name="Severity" as="xs:string" select="cdocfx:getCodeDisplayByID(n:allergy-instance/@severity-code)"/>
									<xsl:value-of select="java-string:format($Separator, $Severity)"/>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
						
						<!-- Allergy Reaction(s) -->
						<xsl:if test="n:allergy-instance/n:reaction">
							<xsl:variable name="ReactionList" as="xs:string">
								<xsl:call-template name="RecurseReactions">
									<xsl:with-param name="ReacList" select="n:allergy-instance/n:reaction"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:text disable-output-escaping="yes"><![CDATA[&#160;]]></xsl:text>
							<xsl:value-of select="java-string:format($ReactionParentheses, $ReactionList)"/>
						</xsl:if>
					</div>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="''"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- This template walks through a list of reactions recursively and concatenates them-->
	<xsl:template name="RecurseReactions">
	<xsl:param name="ReacList"/>
	<xsl:choose>
		<xsl:when test="count($ReacList) > 1">
			<xsl:variable name="RecursiveResult" as="xs:string">
				<xsl:call-template name="RecurseReactions">
					<xsl:with-param name="ReacList" select="$ReacList[position() &gt; 1]"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="ReactionName" as="xs:string">
				<xsl:value-of select= "cdocfx:get-loose-name-display($ReacList[1]/n:reaction-name)"/>
			</xsl:variable>
			<xsl:value-of select="java-string:format($Reactions, ($ReactionName, $RecursiveResult))"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="cdocfx:get-loose-name-display($ReacList[1]/n:reaction-name)"/>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- This function is used to sort the allergies based on the following criteria :
			- The allergies are to be displayed by severity in the order - Severe, Moderate, Mild, Client defined(if they exist), No severity
			- For the client defined allergies, they are to be displayed based on the collation sequence in descending order

		 In order to achieve this, we assign the literals 'Z','X' and 'Y' to the sort parameter for the severities 'Severe','Moderate' and 'Mild' respectively;
		 to keep them at the top of the descending stack. Then all the client defined allergies will have their sequence assigned to the sort parameter in
		 descending order. Finally, we assign an empty string '' to the allergies which do not have a severity documented to have them sort to the bottom of
		 the stack.

		 Returns a string which acts as the sort parameter. -->
	<xsl:function name="cdocfx:get-sequence" as="xs:string">
		<xsl:param name="allergyInstance" as="element()?"/>
		<xsl:variable name="severityCode">
			<xsl:value-of select="$allergyInstance/@severity-code"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$allergyInstance/@severity-code">
				<xsl:variable name="severityMeaning">
					<xsl:value-of select="cdocfx:getCodeMeanByID($severityCode)"/>
				</xsl:variable>
				<xsl:if test="$severityMeaning = 'SEVERE'">
					<xsl:value-of select="'Z'"/>
				</xsl:if>
				<xsl:if test="$severityMeaning = 'MODERATE'">
					<xsl:value-of select="'Y'"/>
				</xsl:if>
				<xsl:if test="$severityMeaning = 'MILD'">
					<xsl:value-of select="'X'"/>
				</xsl:if>
				<xsl:if test="$severityMeaning != 'SEVERE'">
					<xsl:if test="$severityMeaning != 'MODERATE'">
						<xsl:if test="$severityMeaning != 'MILD'">
							<xsl:value-of select="cdocfx:getCodeSequenceByID($severityCode)"/>
						</xsl:if>
					</xsl:if>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="''"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
</xsl:stylesheet>
