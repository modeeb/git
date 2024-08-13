<?xml version="1.0" encoding="UTF-8"?>
<?dynamic-document type="format" version="7.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    xmlns:xr-date-formatter="java:com.cerner.xsl.util.XSLTDateUtilities" 
    xmlns:n="urn:com-cerner-patient-ehr:v3" 
    xmlns:cdocfx="urn:com-cerner-physician-documentation-functions" 
    xmlns:dd="DynamicDocumentation" 
    xmlns:doc="java:com.cerner.documentation.extension.XSLTFuncs"
    exclude-result-prefixes="xsl xs fn n doc cdocfx xr-date-formatter">
    
    <!-- Comment out this line to debug --> <xsl:include href="/cernerbasiccontent/formats/addressfxn.xslt"/>
    <!-- Uncomment this line to debug> <xsl:include href="AddressFxn.xslt"/> -->
    <!-- Required to include CommonFxn.xslt -->
    <!-- Comment out this line to debug --> <xsl:include href="/cernerbasiccontent/formats/commonfxn.xslt"/>
    <!-- Uncomment this line to debug> <xsl:include href="CommonFxn.xslt"/> -->
    
    
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    <xsl:param as="xs:string" name="current-locale" select="'en_US'"/>

    <!-- This will be over-written during Run-Time -->
    <xsl:variable name="bIsUTCOn" as="xs:boolean" select="true()"/>

    <xsl:variable name="DATE_SEQUENCE_UTC_ON_DAY" as="xs:string" select="'ddd hh:mm a zzz'"/>

    <xsl:variable name="DATE_SEQUENCE_UTC_OFF_DAY" as="xs:string" select="'ddd hh:mm a'"/>

    <xsl:variable name="DATE_ONLY_SEQUENCE" as="xs:string" select="'MM/dd/yyyy'"/>

    <xsl:variable name="DATE_SEQUENCE_DAY" as="xs:string" select="'EEEE'"/>

    <xsl:variable name="DATE_SEQUENCE_DATE" as="xs:string" select="'MMM. d, yyyy'"/>

    <xsl:variable name="DATE_SEQUENCE_TIME" as="xs:string" select="'h:mm a zzz'"/>


    <!-- Default string constants -->
    <xsl:variable name="Type">
        <xsl:value-of select="'Type:'"/>
    </xsl:variable>

    <xsl:variable name="When" as="xs:string">
        <xsl:value-of select="'When:'"/>
    </xsl:variable>

    <xsl:variable name="With" as="xs:string">
        <xsl:value-of select="'With:'"/>
    </xsl:variable>
    
    <xsl:variable name="Where" as="xs:string">
        <xsl:value-of select="'Where:'"/>
    </xsl:variable>

    <xsl:variable name="Contact" as="xs:string">
        <xsl:value-of select="'Contact Information'"/>
    </xsl:variable>

    <xsl:variable name="Status" as="xs:string">
        <xsl:value-of select="'Status:'"/>
    </xsl:variable>
    
    <xsl:variable name="NoStatus" as="xs:string">
        <xsl:value-of select="'No Data Available'"/>
    </xsl:variable>
    
    <xsl:variable name="VideoVisit" as="xs:string">
        <xsl:value-of select="'Video Visit'"/>
    </xsl:variable>
    
    <xsl:variable name="VideoIcon">
		<img width="15px" height="15px" src='data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAJYAAACWCAYAAAA8AXHiAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAuIwAALiMBeKU/dgAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAMWSURBVHic7d2vbhRRFIDxrxMQTUgNGoGCIAuBd4A0CNK	+Ab4JPAG2oq8AL4CqwIDEISEBRZpQBbKkrKCIpUC7M7Pz78wd9n6/5CQ7ak7u/cRmzYIkSZIkSZIkSZIkSZIkSZIkSZIkSZIkSZK6WrvwfBnYAbaAG8DG6BvpzAw4Al4DL4Avadfp7jbwCTh1JjffgafVVzdd94Bj0h+gUz97VRc4RevAIekPzWk2D8qvcVoK4DFwLfUiauxZ6gWaKIBHqZdQK5vA9dRLLFMAt1Ivodamfme7BXA19RZqbcp3tgvsFyz+lqXpK1IvUGEX2IfpLqj/z5+owLA0jHNRgWGpv4WowLDUT2lUYFjqrjIqMCx1UxsVGJbaWxoVGJbaaRQVGJaaaxwVGJaaaRUVGJaWax0VGJbqdYoKDEvVOkcFhqVyvaICw9Ki3lGBYem8QaICw9Jfg0UFhqW5QaMCw1JAVGBYuQuJCgwrZ2FRgWHlKjQqMKwchUcFhpWbUaICw8rJaFGBYeVi1KjAsHIwelRgWKsuSVRgWKvsDomiAsNaZVdSvtywFMKwFMKwFMKwFMKwFMKwFMKwFMKwFMKwFMKwFMKwFMKwFMKwFMKwFMKwFMKwFMKwFMKwFMKwVtdb4CDVyw1rdc2Y/5F8krgMa7Uli8uwVl+SuAwrD6PHZVj5GDUuw8rLaHEZVn5Gicuw8hQel2HlKzQuw8pbWFyGpZC4DEsQEJdh6cygcRmW/jVYXIaliwaJy7BUpndchqUqveIyLNXpHJdhaZlOcRmWmmgdl2GpqVZxGZbaaByXYamtRnEZlrpYGpdhqavauAxLfVTGZVjqqzQuw9IQFuIqgNNk66irn6kXKDEDtoFXMA/rW9J11MXX1AtUOAEeAgcF8D7xMmrvQ+oFasyA7QJ4mXoTtfIO+Jx6iSVOANaBQ+bftZzpz/2ym5yqu8Ax6Q/NqZ+9qgucsk3gI+kPz1mcY+BJ9dVNz9qF50vADrAF3AQ2Rt9IZ34AR8Ab4Pnvz5IkSZIkSZIkSZIkSZIkSZIkSZIkSZIkScrAL5JP6iTifx4hAAAAAElFTkSuQmCC'/>
	</xsl:variable>
	
	<!-- Functions -->

	<!-- Define Scheduling Appointment Types that are considered "Tele-Health, Video, Virtual, or Remote" in order to not display the location.
		 Instead we will display a video icon and the verbiage "Video Visit" for the "Where" label. 
		 This uses the display field from Codeset 14230 -->
	<!-- Parameters: -->
	<!-- 	AppointmentType - Name of Appointment -->
	<xsl:function name="cdocfx:isAppointmentTypeVirtual" as="xs:boolean">
		<xsl:param name="AppointmentType"/>
		<xsl:choose>
			<xsl:when test="cdocfx:getCodeDisplayByID($AppointmentType)='PLACE_VIRTUAL_APPOINTMENT_TYPE_NAMES_HERE'">
				<xsl:value-of select="fn:true()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="fn:false()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	<!-- Templates -->
	<xsl:template name="tempApptType">
            <xsl:if test="@appointment-type-code">
                <xsl:variable name="apptTypeDisplay" select="cdocfx:getCodeDisplayByID(@appointment-type-code)"/>
                    <tr>
                        <td style="vertical-align:top; padding-left:50px;">
                            <span style="font-weight:bold">
                                <xsl:value-of select="$Type"/>
                            </span>
                        </td>
                        <td>
                            <xsl:value-of select="$apptTypeDisplay"/>
                        </td>
                    </tr>
            </xsl:if>
    </xsl:template>

	<xsl:template name="tempApptPersonnel">
		<xsl:if test="@appointment-personnel-id != 0">
			<tr>
				<td style="vertical-align:top; padding-left:50px;">
					<span style="font-weight:bold">
						<xsl:value-of select="$With"/>
					</span>
				</td>
				<td>
					<xsl:choose>
						<xsl:when test="@appointment-personnel-id">
							<xsl:value-of select="cdocfx:getProviderNameFullByID(@appointment-personnel-id)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="''"/>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>
	
    <xsl:template name="tempApptLocation">
		<xsl:param name="location"/>
		<xsl:param name="appttype"/>
		
		<tr>
			<td style="vertical-align:top; padding-left:50px;">
				<span style="font-weight:bold">
					<xsl:value-of select="$Where"/>
				</span>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="cdocfx:isAppointmentTypeVirtual($appttype)=true()">
						<xsl:copy-of select="$VideoIcon"/>
						<span style="padding-left:4px;vertical-align:top;">
							<xsl:value-of select="$VideoVisit"/>
						</span>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="$location/@description">
							<xsl:value-of select="$location/@description"/>
						</xsl:if>
						<xsl:if test="$location/@description and $location/n:business-address">
							<xsl:text disable-output-escaping="yes"><![CDATA[&#124;]]></xsl:text>
						</xsl:if>
						<xsl:if test="$location/n:business-address">
							<xsl:call-template name="DisplayAddress">
								<xsl:with-param name="address" select="$location/n:business-address"/>
							</xsl:call-template>
							<xsl:if test="$location/@business-phone">
								<br/>
								<xsl:value-of select="$location/@business-phone"/>
							</xsl:if>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template name="tempApptStatus">
		<tr>
            <td style="vertical-align:top; padding-left:50px;">
				<span style="font-weight:bold"><xsl:value-of select="$Status"/></span>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="@schedule-state-code">
						<xsl:value-of select="cdocfx:getCodeDisplayByID(@schedule-state-code)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$NoStatus"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>

    <xsl:template match="/">
        <xsl:choose>
            <!-- When there is a scheduled appointment documented.  -->
            <xsl:when test="count(n:report/n:clinical-data/n:future-appointment-data/n:appointment) &gt; 0">

                <table dd:btnfloatingstyle="top-right" dd:whitespacecolseparator="true" style="border-collapse: collapse; table-layout: fixed;"> 
                    <!-- Separate columns by a space in plain text conversion -->
                    <tbody>
                        <xsl:for-each select="n:report/n:clinical-data/n:future-appointment-data/n:appointment">
                            <!-- sort by date time of appointment -->
                            <xsl:sort select="n:appointment-begin-dt-tm" order="ascending"/>

                                <!-- Adding condition to only display Future appointments having confirmed status and Future appointments having no status.
                                We are excluding the following statuses: Hold,Scheduled -->
                                <xsl:if test="(@schedule-state-code and cdocfx:getCodeMeanByID(@schedule-state-code) = 'CONFIRMED') or (not(@schedule-state-code))">
                                    <xsl:variable name="ApptDtTm" as="xs:dateTime" select="n:appointment-begin-dt-tm"/>
                                    <!--This check is made to display only future appointment i.e., appointment date time should be greater than current date time -->
                                    <xsl:if test="doc:getTimeInMillisecs(xs:string($ApptDtTm)) &gt; doc:getTimeInMillisecs(xs:string(current-dateTime()))">
                                        <tr class="ddemrcontentitem ddremovable" dd:btnfloatingstyle="top-right">
                                            <xsl:attribute name="dd:entityid" select="@schedule-event-id"/>
                                            <xsl:attribute name="dd:contenttype" select="'FUTURE_APPTS'"/>
                                            <td style="vertical-align:top; padding-left:6px; word-wrap: break-word;">
                                                <!-- This is a derived variable and doesn't need to go in the i18n string tables -->
                                                <xsl:variable name="DATE_SEQUENCE" as="xs:string" select="cdocfx:getDateDisplayPattern($bIsUTCOn, $DATE_SEQUENCE_UTC_ON_DAY, $DATE_SEQUENCE_UTC_OFF_DAY)"/>
                                                <xsl:variable name="ApptTimeZone" as="xs:string" select="n:appointment-begin-dt-tm/@time-zone"/>
                                                <xsl:variable name="time" select="substring(xs:string(xs:time($ApptDtTm)), 0, 9)"/>
                                                <xsl:variable name="midnight" select="'00:00:00'"/>
                                                <span style="font-weight: bold;">
                                                    <xsl:value-of select="xr-date-formatter:formatDate($ApptDtTm, $DATE_SEQUENCE_DAY, $ApptTimeZone, $current-locale)"/>
                                                    <br/>
                                                    <span style="font-weight: 550;font-size: 12pt;">
                                                        <xsl:value-of select="xr-date-formatter:formatDate($ApptDtTm, $DATE_SEQUENCE_DATE, $ApptTimeZone, $current-locale)"/>
                                                    </span>
                                                    <br/>
                                                    <xsl:if test="$time != $midnight">
                                                        <span style="font-weight: bold;">
                                                            <xsl:value-of select="xr-date-formatter:formatDate($ApptDtTm, $DATE_SEQUENCE_TIME, $ApptTimeZone, $current-locale)"/>
                                                        </span>
                                                    </xsl:if>
                                                    <br/>
                                                    <br/>
                                                </span>
                                            </td>
                                            <xsl:if test="@appointment-location-code">
												<xsl:variable name="location" select="cdocfx:getLocationById(@appointment-location-code)"/>
												<td style="vertical-align:top;padding-left:6px;padding-bottom:10px;word-wrap:break-word">
													<table dd:whitespacecolseparator="true">
														<xsl:call-template name="tempApptType"/>
														<xsl:call-template name="tempApptPersonnel"/>
														<xsl:choose>
															<xsl:when test="@appointment-type-code">
																<xsl:variable name="ApptType" select="@appointment-type-code"/>
																<xsl:call-template name="tempApptLocation">
																	<xsl:with-param name="location" select="$location"/>
																	<xsl:with-param name="appttype" select="$ApptType"/>
																</xsl:call-template>
															</xsl:when>
															<xsl:otherwise>
																<xsl:call-template name="tempApptLocation">
																	<xsl:with-param name="location" select="$location"/>
																</xsl:call-template>
															</xsl:otherwise>
														</xsl:choose>
														<xsl:call-template name="tempApptStatus"/>
													</table>
												</td>
											</xsl:if>
                                        </tr>
                                    </xsl:if>
                                </xsl:if>
                        </xsl:for-each>
                    </tbody>
                </table>
            </xsl:when>
            <xsl:otherwise>
                <!-- Display Nothing -->
                <xsl:value-of select="''"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>