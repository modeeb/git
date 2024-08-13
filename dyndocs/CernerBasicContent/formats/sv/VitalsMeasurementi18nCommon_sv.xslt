<?xml version="1.0" encoding="UTF-8"?>
<?dynamic-document type="format" version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">
	
        <!-- Comment this line to debug --><xsl:import href="/cernerbasiccontent/formats/sv/dateformat_sv.xslt"/>
        <!-- Uncomment this line to debug <xsl:import href="./dateformat_sv.xslt" /> -->
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	
	<!-- Locale defined for CommonFxn.xslt (If not defined, defaults to en_US, Value defined here overrides all other values) -->
	<xsl:param name="current-locale" as="xs:string" select="'sv'"/>
	
	<!-- Strings defined for VitalsMeasurementCommon.xslt, String values defined here override the default values defined in VitalsMeasurementCommon.xslt -->
	<xsl:variable name="maxTemp" as="xs:string">
		<xsl:value-of select="'TMAX'"/>
	</xsl:variable>
	<xsl:variable name="minTemp" as="xs:string">
		<xsl:value-of select="'TMIN'"/>
	</xsl:variable>
	<xsl:variable name="AbbreviationDisplay" as="xs:string">
		<xsl:value-of select="'%s:'"/>
	</xsl:variable>
	<xsl:variable name="MethodDisplay" as="xs:string">
		<xsl:value-of select="'(%s)'"/>
	</xsl:variable>
	<!-- Degree Celsius unicode representation, Link to html codes: http://www.w3.org/TR/WD-html40-970708/sgml/entities.html -->
	<xsl:variable name="DegreeCelsius"><![CDATA[&#176;]]>C</xsl:variable>
	<!-- Degree Fahrenheit unicode representation, Link to html codes: http://www.w3.org/TR/WD-html40-970708/sgml/entities.html -->
	<xsl:variable name="DegreeFahrenheit"><![CDATA[&#176;]]>F</xsl:variable>
	
	<!--For Visit Summary and Patient Facing templates we will display vital signs differently.
	For Patient Facing templates the value of isPatientFacingTemplate boolean will be true, else false.-->
	<xsl:variable name="isPatientFacingTemplate" as="xs:boolean" select="false()"/>
	
	<!-- Strings defined for VitalsMeasurementED.xslt, String values defined here override the default values defined in VitalsMeasurementED.xslt -->
	<!-- String constants for Abbreviations-->
	<xsl:variable name="sAbbrvTemperature" as="xs:string"><xsl:value-of select="'Temperatur'"/></xsl:variable>
	<xsl:variable name="sAbbrvHeartRate" as="xs:string"><xsl:value-of select="'Hj&#228;rtfrekvens'"/></xsl:variable>
	<xsl:variable name="sAbbrvRespiratoryRate" as="xs:string"><xsl:value-of select="'Andningsfrekvens'"/></xsl:variable>
	<xsl:variable name="sAbbrvBloodPressure" as="xs:string"><xsl:value-of select="'Blodtryck'"/></xsl:variable>
	<xsl:variable name="sAbbrvOrthoBloodPressure" as="xs:string"><xsl:value-of select="'Ortostatiskt blodtryck'"/></xsl:variable>
	<xsl:variable name="sAbbrvSpO2" as="xs:string"><xsl:value-of select="'Perifer syrem&#228;ttnad'"/></xsl:variable>
	<xsl:variable name="sAbbrvHeight" as="xs:string"><xsl:value-of select="'L&#228;ngd'"/></xsl:variable>
	<xsl:variable name="sAbbrvWeight" as="xs:string"><xsl:value-of select="'Vikt'"/></xsl:variable>
	<xsl:variable name="sAbbrvBMI" as="xs:string"><xsl:value-of select="'BMI'"/></xsl:variable>
	<xsl:variable name="sAbbrvICP" as="xs:string"><xsl:value-of select="'Intrakraniellt tryck'"/></xsl:variable>
	<xsl:variable name="sAbbrvGCS" as="xs:string"><xsl:value-of select="'GCS-po&#228;ng'"/></xsl:variable>
	<xsl:variable name="sAbbrvNIH" as="xs:string"><xsl:value-of select="'Po&#228;ng p&#229; NIH-strokeskala'"/></xsl:variable>
	<xsl:variable name="sAbbrvPVR" as="xs:string"><xsl:value-of select="'Residualurin'"/></xsl:variable>
	<xsl:variable name="sAbbrvOrthoHeartRate" as="xs:string"><xsl:value-of select="'Ortostatisk hj&#228;rtfrekvens'"/></xsl:variable>
	
	<!-- String constants for Methods-->
	<xsl:variable name="sMthdEmpty" as="xs:string"><xsl:value-of select="''"/></xsl:variable>
	<xsl:variable name="sMthdAxillary" as="xs:string"><xsl:value-of select="'Axill&#228;r'"/></xsl:variable>
	<xsl:variable name="sMthdBladder" as="xs:string"><xsl:value-of select="'Bl&#229;sa'"/></xsl:variable>
	<xsl:variable name="sMthdBrain" as="xs:string"><xsl:value-of select="'Hj&#228;rna'"/></xsl:variable>
	<xsl:variable name="sMthdEsophageal" as="xs:string"><xsl:value-of select="'Esofageal'"/></xsl:variable>
	<xsl:variable name="sMthdIntravascular" as="xs:string"><xsl:value-of select="'Intravaskul&#228;r'"/></xsl:variable>
	<xsl:variable name="sMthdOral" as="xs:string"><xsl:value-of select="'Oral'"/></xsl:variable>
	<xsl:variable name="sMthdRectal" as="xs:string"><xsl:value-of select="'Rektal'"/></xsl:variable>
	<xsl:variable name="sMthdSkin" as="xs:string"><xsl:value-of select="'Hud'"/></xsl:variable>
	<xsl:variable name="sMthdTemporalArtery" as="xs:string"><xsl:value-of select="'Panna'"/></xsl:variable>
	<xsl:variable name="sMthdTympanic" as="xs:string"><xsl:value-of select="'H&#246;rselg&#229;ng'"/></xsl:variable>
	<xsl:variable name="sMthdCore" as="xs:string"><xsl:value-of select="'K&#228;rna'"/></xsl:variable>
	<xsl:variable name="sMthdApical" as="xs:string"><xsl:value-of select="'Apikal'"/></xsl:variable>
	<xsl:variable name="sMthdMonitored" as="xs:string"><xsl:value-of select="'&#214;vervakad'"/></xsl:variable>
	<xsl:variable name="sMthdSpontaneous" as="xs:string"><xsl:value-of select="'Spontan'"/></xsl:variable>
	<xsl:variable name="sMthdtotal" as="xs:string"><xsl:value-of select="'Totalt'"/></xsl:variable>
	<xsl:variable name="sMthdactivity" as="xs:string"><xsl:value-of select="'Aktivitet'"/></xsl:variable>
	<xsl:variable name="sMthdassisted" as="xs:string"><xsl:value-of select="'Assisterad'"/></xsl:variable>
	<xsl:variable name="sMthdline" as="xs:string"><xsl:value-of select="'Rad'"/></xsl:variable>
	<xsl:variable name="sMthdsitting" as="xs:string"><xsl:value-of select="'Sittande'"/></xsl:variable>
	<xsl:variable name="sMthdstanding" as="xs:string"><xsl:value-of select="'St&#229;ende'"/></xsl:variable>
	<xsl:variable name="sMthdsupine" as="xs:string"><xsl:value-of select="'Ryggl&#228;ge'"/></xsl:variable>
	<xsl:variable name="sMthdPeripheral" as="xs:string" select="'Perifer'"/>
	<xsl:variable name="sMthdWeightEstimated" as="xs:string" select="'Ber&#228;knad'"/>
	<xsl:variable name="sMthdWeightDosing" as="xs:string" select="'Dosering'"/>
	<xsl:variable name="sMthdWeightBirth" as="xs:string" select="'F&#246;delse'"/>
	
</xsl:stylesheet>