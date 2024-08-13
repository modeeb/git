<?xml version="1.0" encoding="UTF-8"?>
<?dynamic-document type="format" version="7.0"?>
<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:n="urn:com-cerner-patient-ehr:v3"
    xmlns:dd="DynamicDocumentation"
    exclude-result-prefixes="xsl xs fn n dd">
    
    <xsl:decimal-format name="en" decimal-separator='.' grouping-separator=',' />
    <xsl:output method="html" encoding="UTF-8" indent="yes" />
    <!-- template to output the table headings -->
    <xsl:template name="tempTableHead" >
        <xsl:param name="columnOne" as="xs:string" select="''"/>
        <xsl:param name="columnTwo" as="xs:string" select="''"/>
        <xsl:param name="columnThree" as="xs:string" select="''"/>
        
        <xsl:if test="$columnOne or $columnTwo or $columnThree">
            
            <thead style="display:table-header-group;"> <!-- This thead will repeat table heading on each page when printing on paper such as Draft Print -->
                <tr style="background-color:#F4F4F4;">
                    <xsl:if test="$columnOne">
                        <th style="font-weight:bold; text-align:center; padding:0 5px; padding-left:6px; border-bottom: 1px solid #000;"><xsl:value-of select="$columnOne"/></th>
                    </xsl:if>
                    <xsl:if test="$columnTwo">
                        <th style="font-weight:bold; text-align:center; padding:0 5px; border-bottom: 1px solid #000; border-left:1px solid #000; padding-left:6px;"><xsl:value-of select="$columnTwo"/></th>
                    </xsl:if>
                    <xsl:if test="$columnThree">
                        <th style="font-weight:bold; text-align:center; vertical-align:top; padding:0 5px; padding-left:6px; border-bottom: 1px solid #000; border-left:1px solid #000;"><xsl:value-of select="$columnThree"/></th>
                    </xsl:if>
                </tr>
            </thead>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="createColSpan">
        <xsl:param name="colCount" as="xs:integer"/>
        
        <colgroup>
            <xsl:for-each select="1 to $colCount">
                <col>
                    <xsl:attribute name="style" select="concat('width:',concat(format-number(100 div $colCount,'###,###,##0.00','en'),'%'))"></xsl:attribute>
                </col>
            </xsl:for-each>
        </colgroup>
    </xsl:template>
    
    <xsl:template name="addCommentsRow">
        <xsl:param name="measurement"/>
        <xsl:param name="spanningRowTwoLabel" as="xs:string"/>
        <xsl:param name="colValue" as="xs:string"/>
        <xsl:param name="colCount" as="xs:integer"/>
        
        <tr class="ddgrouper ddremovable" dd:btnfloatingstyle="top-right">
            <td style="border-top:1px solid #000;">
                <xsl:attribute name="colspan" select="$colCount"/>
                <table style="table-layout: fixed;width:100%; border:0;" dd:whitespacecolseparator="true">
                    <colgroup>
                        <col style="width:32%;"/>
                        <col style="width:68%;"/>
                    </colgroup>
                    <tr>
                        <td style="vertical-align:top;"><span style="white-space:nowrap;font-weight:bold;"><xsl:value-of select="concat($spanningRowTwoLabel,':')"/></span></td>
                        <td  style="word-wrap: break-word;">
                            <xsl:value-of disable-output-escaping="yes" select="$colValue"/> 
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </xsl:template>
    
    <!-- template to output the table rows for the measurement -->
    <xsl:template name="tempTableRow">
        <xsl:param name="measurement"/>
        <xsl:param name="columnOne" as="xs:string" select="''"/>
        <xsl:param name="columnTwo" as="xs:string" select="''"/>
        <xsl:param name="columnThree" as="xs:string" select="''"/>
        <xsl:param name="spanningRowTwoLabel" as="xs:string" select="''"/>
        <xsl:param name="colCount" as="xs:integer"/>
        <xsl:param name="entityID" as="xs:string" select="''"/>
        <xsl:param name="contentType" as="xs:string" select="''"/>
        
        <xsl:if test="$measurement and ($columnOne or $columnTwo or $columnThree or $spanningRowTwoLabel)">
            
            <tr class="ddemrcontentitem ddremovable" dd:btnfloatingstyle="top-right" style="border-top: 1px solid #000;">
                <xsl:attribute name="dd:entityid" select="$entityID"/>
                <xsl:attribute name="dd:contenttype" select="$contentType"/>
                <td>
                    <xsl:attribute name="colspan" select="$colCount"/>
                    <table dd:whitespacecolseparator="true" style="table-layout: fixed;width: 100%; border-collapse: collapse; border-spacing: 0;">
                        
                        <xsl:call-template name="createColSpan">
                            <xsl:with-param name="colCount" select="$colCount"/>
                        </xsl:call-template> 
                        
                        <tbody>
                            <tr>
                                <xsl:if test="$columnOne">
                                    <td style="word-break: break-all;padding-left:6px; vertical-align:top;border-right:1px solid #000;">
                                        <xsl:if test="$measurement/@column-one"><xsl:value-of disable-output-escaping="yes" select="$measurement/@column-one"/></xsl:if>
                                    </td>
                                </xsl:if>
                                <xsl:if test="$columnTwo">
                                    <td>
                                        <xsl:choose>
                                            <xsl:when test="$colCount = 2">
                                                <xsl:attribute name="style" select="'word-break: break-all;padding-left:6px; '"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:attribute name="style" select="'word-break: break-all;padding-left:6px; border-right:1px solid #000'"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:if test="$measurement/@column-two">
											<xsl:choose>
												<xsl:when test="$measurement/@interpretation = 'CRITICAL'">
													<xsl:copy-of select="$CriticalRangeImage"/>								
													<span style="padding-left: 2px; color:#CC0000;">
														<xsl:value-of disable-output-escaping="yes" select="$measurement/@column-two"/>
													</span>
												</xsl:when>
												<xsl:when test="$measurement/@interpretation = 'ABNORMAL'">
													<xsl:copy-of select="$AbnormalRangeImage"/>	
													<span style="padding-left: 2px; color:#814126;">
														<xsl:value-of disable-output-escaping="yes" select="$measurement/@column-two"/>
													</span>
												</xsl:when>
												<xsl:when test="$measurement/@interpretation = 'HIGH'">
													<xsl:copy-of select="$HighRangeImage"/>	
													<span style="padding-left: 2px; color:#FF6100;">
														<xsl:value-of disable-output-escaping="yes" select="$measurement/@column-two"/>
													</span>
												</xsl:when>
												<xsl:when test="$measurement/@interpretation = 'LOW'">
													<xsl:copy-of select="$LowRangeImage"/>	
													<span style="padding-left: 2px; color:#0053E6;">
														<xsl:value-of disable-output-escaping="yes" select="$measurement/@column-two"/>
													</span>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of disable-output-escaping="yes" select="$measurement/@column-two"/>
												</xsl:otherwise>
											</xsl:choose>		
                                        </xsl:if>
                                    </td>
                                </xsl:if>
                                <xsl:if test="$columnThree">
                                    <td style="word-break: break-all;padding-left:6px; vertical-align:top;">
                                        <xsl:if test="$measurement/@column-three"><xsl:value-of disable-output-escaping="yes" select="$measurement/@column-three"/></xsl:if>
                                    </td>
                                </xsl:if>
                            </tr>
                            
                            <xsl:if test="$spanningRowTwoLabel and string-length($measurement/@comment) &gt; 0">
                                
                                <xsl:call-template name="addCommentsRow">
                                    <xsl:with-param name="spanningRowTwoLabel" select="$spanningRowTwoLabel"/>
                                    <xsl:with-param name="colValue" select="$measurement/@comment"/>
                                    <xsl:with-param name="colCount" select="$colCount"/>
                                </xsl:call-template>
                            </xsl:if>
                            
                        </tbody>
                    </table>
                </td>
            </tr>
        </xsl:if>
    </xsl:template>
    
    <!-- template to output the table body for measurements -->
    <xsl:template name="tempTableBody">
        <xsl:param name="measurements"/>
        <xsl:param name="columnOne" as="xs:string" select="''"/>
        <xsl:param name="columnTwo" as="xs:string" select="''"/>
        <xsl:param name="columnThree" as="xs:string" select="''"/>
        <xsl:param name="spanningRowTwoLabel" as="xs:string" select="''"/> 
        <xsl:param name="colCount" as="xs:integer"/>
        <tbody>
            <xsl:for-each select="$measurements/measurement">
                <xsl:call-template name="tempTableRow">
                    <xsl:with-param name="measurement" select="."/>
                    <xsl:with-param name="columnOne" select="$columnOne"/>
                    <xsl:with-param name="columnTwo" select="$columnTwo"/>
                    <xsl:with-param name="columnThree" select="$columnThree"/>
                    <xsl:with-param name="spanningRowTwoLabel" select="$spanningRowTwoLabel"/>
                    <xsl:with-param name="colCount" select="$colCount"/>
                    <xsl:with-param name="entityID" select="@id"/>
                    <xsl:with-param name="contentType" select="@content-type"/>
                </xsl:call-template>
            </xsl:for-each>
        </tbody>
    </xsl:template>
    
    <xsl:template name="getColumnNumber" as="xs:integer">
        <xsl:param name="colHeadingOne" as="xs:string"/>
        <xsl:param name="colHeadingTwo" as="xs:string"/>
        <xsl:param name="colHeadingThree" as="xs:string"/>
        
        <xsl:variable name="colCount" as="xs:integer">
            <xsl:choose>
                <xsl:when test="$colHeadingOne and $colHeadingTwo and $colHeadingThree">
                    <xsl:value-of select="3"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="2"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$colCount"/>
    </xsl:template>
	
    <!-- template to output up to a 3 column table with zebra striping -->
    <xsl:template name="tempMeasurementsTable">
        <xsl:param name="measurements"/>
        <xsl:param name="colHeadingOne" as="xs:string"/>
        <xsl:param name="colHeadingTwo" as="xs:string"/>
        <xsl:param name="colHeadingThree" as="xs:string"/>
        <xsl:param name="spanningRowTwoLabel" as="xs:string"/>
        
        <xsl:if test="$measurements/measurement">
            
            <table class="ddremovable" style="table-layout: fixed;border:1px solid #000; border-spacing:0; border-collapse:collapse;" dd:btnfloatingstyle="top-right" dd:zebrastripecolor="#F4F4F4" dd:zebraheadercolor="#F4F4F4" dd:whitespacecolseparator="true">
                
                <xsl:variable name="colCount" as="xs:integer">
                    <xsl:call-template name="getColumnNumber">
                        <xsl:with-param name="colHeadingOne" select="$colHeadingOne"/> 
                        <xsl:with-param name="colHeadingTwo" select="$colHeadingTwo"/>
                        <xsl:with-param name="colHeadingThree" select="$colHeadingThree"/>
                    </xsl:call-template>
                </xsl:variable>
                
                <xsl:call-template name="createColSpan">
                    <xsl:with-param name="colCount" select="$colCount"/>
                </xsl:call-template>
                
                <xsl:call-template name="tempTableHead">
                    <xsl:with-param name="columnOne" select="$colHeadingOne"/>
                    <xsl:with-param name="columnTwo" select="$colHeadingTwo"/>
                    <xsl:with-param name="columnThree" select="$colHeadingThree"/>
                </xsl:call-template>
                
                <xsl:call-template name="tempTableBody">
                    <xsl:with-param name="measurements" select="$measurements"/>
                    <xsl:with-param name="columnOne" select="$colHeadingOne"/>
                    <xsl:with-param name="columnTwo" select="$colHeadingTwo"/>
                    <xsl:with-param name="columnThree" select="$colHeadingThree"/>
                    <xsl:with-param name="spanningRowTwoLabel" select="$spanningRowTwoLabel"/>
                    <xsl:with-param name="colCount" select="$colCount"/>
                </xsl:call-template>
            </table>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>