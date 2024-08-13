<?xml version="1.0" encoding="UTF-8"?>
<?dynamic-document type="format" version="7.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:xr-date-formatter="java:com.cerner.xsl.util.XSLTDateUtilities"
	xmlns:n="urn:com-cerner-patient-ehr:v3"
	xmlns:cdocfx="urn:com-cerner-physician-documentation-functions"
	xmlns:doc="java:com.cerner.documentation.extension.XSLTFuncs"
	xmlns:dd="DynamicDocumentation"
	exclude-result-prefixes="xsl xs fn xr-date-formatter n cdocfx doc dd">

	<!-- Common function and constants for the immunization format files. -->
	<!-- Comment this line to debug --> <xsl:import href="/cernerbasiccontent/formats/immunizationcommon.xslt" />
	<!-- Uncomment this line to debug <xsl:import href="immunizationcommon.xslt" /> -->
	
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	<xsl:param as="xs:string" name="current-locale" select="'en_US'"/>
	
	<xsl:template match="/">
	
		<!-- Build XML containing given, not-given, and recorded immunizations, so that all of them can be looped through and sorted together -->
		<xsl:variable name="Immunizations">
			
			<xsl:if test="n:report/n:clinical-data/n:immunizationV2-data/n:given">
				<xsl:for-each select="n:report/n:clinical-data/n:immunizationV2-data/n:given">
					<xsl:if test="@is-uncharted='false'">
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
							<xsl:attribute name="dt-tm-to-sort">
								<xsl:if test="n:admin-dt-tm">
									<xsl:value-of select="n:admin-dt-tm"/>
								</xsl:if>
							</xsl:attribute>
							<xsl:attribute name="display-dt-tm">
								<xsl:if test="n:admin-dt-tm">
									<xsl:variable name="ImmuDateTime" as="xs:dateTime" select="n:admin-dt-tm"/>
									<xsl:variable name="ImmuTimeZone" as="xs:string" select="n:admin-dt-tm/@time-zone"/>
									<xsl:value-of select="xr-date-formatter:formatDate($ImmuDateTime, $DATE_ONLY_SEQUENCE, $ImmuTimeZone, $current-locale)"/>
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
			
			<xsl:if test="n:report/n:clinical-data/n:immunizationV2-data/n:not-given">
				<xsl:for-each select="n:report/n:clinical-data/n:immunizationV2-data/n:not-given">
                    <xsl:if test="@is-uncharted='false'">
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
                            <xsl:attribute name="dt-tm-to-sort">
                                <xsl:if test="n:decision-dt-tm">
                                    <xsl:value-of select="n:decision-dt-tm"/>
                                </xsl:if>
                            </xsl:attribute>
                            <xsl:attribute name="display-dt-tm">
                                <xsl:if test="n:decision-dt-tm">
                                    <xsl:variable name="ImmuDateTime" as="xs:dateTime" select="n:decision-dt-tm"/>
                                    <xsl:variable name="ImmuTimeZone" as="xs:string" select="n:decision-dt-tm/@time-zone"/>
                                    <xsl:value-of select="xr-date-formatter:formatDate($ImmuDateTime, $DATE_ONLY_SEQUENCE, $ImmuTimeZone, $current-locale)"/>
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
                    </xsl:if>
				</xsl:for-each>
			</xsl:if>
			
			<xsl:if test="n:report/n:clinical-data/n:immunizationV2-data/n:recorded">
				<xsl:for-each select="n:report/n:clinical-data/n:immunizationV2-data/n:recorded">
                    <xsl:if test="@is-uncharted='false'">
                        <immunization status="recorded">
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
                            <xsl:attribute name="dt-tm-to-sort">
                                <xsl:if test="n:admin-partial-dt-tm/@date">
                                    <xsl:value-of select="n:admin-partial-dt-tm/@date"/>
                                </xsl:if>
                            </xsl:attribute>
                            <xsl:attribute name="display-dt-tm">
                                <xsl:if test="n:admin-partial-dt-tm/@precision-type and n:admin-partial-dt-tm/@date">
                                    <xsl:variable name="ImmuPrecType" as="xs:string" select="n:admin-partial-dt-tm/@precision-type"/>
                                    <xsl:variable name="ImmuDateTime" as="xs:string" select="n:admin-partial-dt-tm/@date"/>
                                    <xsl:call-template name="DisplayPartialDate">
                                        <xsl:with-param name="PrecisionType" select="$ImmuPrecType"/>
                                        <xsl:with-param name="Date" select="$ImmuDateTime"/>
                                    </xsl:call-template>
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
					
		</xsl:variable>
		
		<xsl:if test="$Immunizations/immunization"> <!-- $Immunizations is the XML built, combining given, not-given, and recorded immunizations -->
			<table style="table-layout: fixed;border-spacing:0; border-collapse:collapse; border:1px solid #000;" class="ddremovable" dd:btnfloatingstyle="top-right" dd:zebrastripecolor="#F4F4F4" dd:zebraheadercolor="#F4F4F4" dd:whitespacecolseparator="true"> <!-- Separate columns by a space in plain text conversion -->
				<colgroup>
					<col style="width:34%;"/>
					<col style="width:33%;"/>
					<col style="width:33%;"/>
				</colgroup>
				<thead style="display:table-header-group;"> <!-- This thead will repeat table heading on each page when printing on paper such as Draft Print -->
					<tr>
						<th style="font-weight:bold; text-align:center; vertical-align:top; padding:0 5px; padding-left:6px; border-bottom: 1px solid #000;"><xsl:value-of select="$Vaccine"/></th>
						<th style="font-weight:bold; text-align:center; vertical-align:top; padding:0 5px; border-bottom: 1px solid #000; border-left:1px solid #000; padding-left:6px;"><xsl:value-of select="$Date"/></th>
						<th style="font-weight:bold; text-align:center; vertical-align:top; padding:0 5px; border-bottom: 1px solid #000; border-left:1px solid #000; padding-left:6px;"><xsl:value-of select="$Status"/></th>
						
					</tr>
				</thead>
				<tbody>
					<xsl:for-each select="$Immunizations/immunization">
					
						<xsl:sort select="@dt-tm-to-sort" order="descending"/>
						<xsl:variable name="DoCommentsExist" as="xs:boolean">
							<xsl:choose>
								<xsl:when test="$ShowComments">
									<xsl:choose>
										<xsl:when test="(string-length(./@not-given-reason) &gt; 0) or ./comment">
											<xsl:value-of select="true()"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="false()"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="false()"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
					
						<xsl:call-template name="DisplayImmunization">
							<xsl:with-param name="Immunization" select="."/>
							<xsl:with-param name="ShowCommentsRow" select="$DoCommentsExist"/>
						</xsl:call-template>

					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template name="DisplayImmunization">
		<xsl:param name = "Immunization"/>
		<xsl:param name = "ShowCommentsRow"/>
		
		<tr class="ddemrcontentitem ddremovable" style="border-top: 1px solid #000;" dd:btnfloatingstyle="top-right">
			<xsl:attribute name="dd:entityid">
				<xsl:if test="$Immunization/@event-id">	
					<xsl:value-of select="$Immunization/@event-id"/>
				</xsl:if>	
			</xsl:attribute>
			<xsl:attribute name="dd:contenttype">
				<xsl:text>IMMUNZTNS_V2</xsl:text>
			</xsl:attribute>
			<td colspan="3">
				<table style="table-layout: fixed;width:100%; border-collapse:collapse; border-spacing:0;" dd:whitespacecolseparator="true">
					<colgroup>
						<col style="width:34%;"/>
						<col style="width:33%;"/>
						<col style="width:33%;"/>
					</colgroup>
					<tr>
				
						<td style="word-break: break-all;padding-left:6px; vertical-align:top;border-right:1px solid #000;">
							<xsl:if test="$Immunization/@event-display">
								<xsl:value-of select="$Immunization/@event-display"/>
							</xsl:if>
						</td>
			
						<xsl:choose>
							<xsl:when test="$Immunization/@status='not-given'">
								<td style="padding-left:6px; text-align: center;border-right:1px solid #000;">
													-
								</td>
							</xsl:when>
							<xsl:otherwise>
								<td style="padding-left:6px; vertical-align:top;border-right:1px solid #000;" >
									<xsl:if test="$Immunization/@display-dt-tm">
										<xsl:value-of select="$Immunization/@display-dt-tm"/>
									</xsl:if>
								</td>
							</xsl:otherwise>
						</xsl:choose>
			
						<td style="padding-left:6px; vertical-align:top;">
							<xsl:choose>
								<xsl:when test="$Immunization/@status='given'">
									<xsl:value-of select="$Given"/>
								</xsl:when>
								<xsl:when test="$Immunization/@status='not-given'">
									<xsl:value-of select="$NotGiven"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$Recorded"/>
								</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
		
					<xsl:if test="$ShowCommentsRow = true()">
						<tr class="ddgrouper ddremovable" dd:btnfloatingstyle="top-right">
							<td colspan="3" style="border-top:1px solid #000;">
								<table style="table-layout: fixed;width:100%; border:0;" dd:whitespacecolseparator="true">
									<colgroup>
										<col style="width:32%;"/>
										<col style="width:68%;"/>
									</colgroup>
									<tr>
										<td style="vertical-align:top;"><span style="white-space:nowrap;font-weight:bold;"><xsl:value-of select="concat($Comment,' :')"/></span></td>
										<td style="word-break: break-all;">
											<xsl:if test="$Immunization/@not-given-reason">
												<div><xsl:value-of select="$Immunization/@not-given-reason"/></div>			
											</xsl:if>
											<xsl:if test="$Immunization/comment">
												<xsl:for-each select="$Immunization/comment">
													<xsl:variable name="Comment" as="xs:string">
														<xsl:value-of select="."/>
													</xsl:variable>
													<xsl:value-of disable-output-escaping="yes" select="doc:convertPlainTextToHtml($Comment)"/>
													<xsl:if test="position()!=last()">
														<br />	
													</xsl:if>
												</xsl:for-each>
											</xsl:if>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</xsl:if>
				</table>
			</td>
		</tr>
	</xsl:template>
	
</xsl:stylesheet>