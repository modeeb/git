<?xml version="1.0" encoding="UTF-8"?>
<?dynamic-document type="format" version="7.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<!-- Comment this line to debug --> <xsl:import href="/cernerbasiccontent/formats/medsrec.xslt"/>
	<!-- Uncomment this line to debug <xsl:import href="../medsrec.xslt" /> -->
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	
	<!-- Locale defined for CommonFxn.xslt (If not defined, defaults to en_US, Value defined here overrides all other values) -->
	<xsl:param as="xs:string" name="current-locale" select="'sv'"/>
	
	<!-- Strings defined for medsrec.xslt, String values defined here override the default values defined in medsrec.xslt -->
	<xsl:variable name="What" as="xs:string">
		<xsl:value-of select="'Vad'"/>
	</xsl:variable>
	
	<xsl:variable name="HowMuch" as="xs:string">
		<xsl:value-of select="'Hur mycket'"/>
	</xsl:variable>
	
	<xsl:variable name="How" as="xs:string">
		<xsl:value-of select="'Hur'"/>
	</xsl:variable>
	
	<xsl:variable name="When" as="xs:string">
		<xsl:value-of select="'N&#228;r'"/>
	</xsl:variable>
	
	<xsl:variable name="Why" as="xs:string">
		<xsl:value-of select="'Varf&#246;r'"/>
	</xsl:variable>
	
	<xsl:variable name="AsNeeded" as="xs:string">
		<xsl:value-of select="'vid behov'"/>
	</xsl:variable>
	
	<xsl:variable name="Instructions" as="xs:string">
		<xsl:value-of select="'Instruktioner'"/>
	</xsl:variable>
	
	<xsl:variable name="Duration" as="xs:string">
		<xsl:value-of select="'Tids&#229;tg&#229;ng: '"/>
	</xsl:variable>
	
	<xsl:variable name="Comments" as="xs:string">
		<xsl:value-of select="'Kommentar'"/>
	</xsl:variable>
	
	<xsl:variable name="Pickup" as="xs:string">
		<xsl:value-of select="'H&#228;mta p&#229;'"/>
	</xsl:variable>
	
	<xsl:variable name="Refills" as="xs:string">
		<xsl:value-of select="'Uttag:'"/>
	</xsl:variable>
	
	<xsl:variable name="New" as="xs:string">
		<xsl:value-of select="'Ny'"/>
	</xsl:variable>
	
	<xsl:variable name="Changed" as="xs:string">
		<xsl:value-of select="'&#196;ndrad'"/>
	</xsl:variable>
	
	<xsl:variable name="Unchanged" as="xs:string">
		<xsl:value-of select="'Of&#246;r&#228;ndrad'"/>
	</xsl:variable>
	
	<xsl:variable name="NextLastDose" as="xs:string">
		<xsl:value-of select="'N&#228;sta dos'"/>
	</xsl:variable>
	<xsl:variable name="StopTaking" as="xs:string">
		<xsl:value-of select="'Sluta ta'"/>
	</xsl:variable>
	
	<xsl:variable name="ContactPhysician" as="xs:string">
		<xsl:value-of select="'Kontakta f&#246;rskrivande l&#228;kare vid fr&#229;gor eller problem'"/>
	</xsl:variable>
	
	<xsl:variable name="Connector" as="xs:string">
		<xsl:value-of select="'%s %s'"/>
	</xsl:variable>
	
	<!-- Displays Frequency followed by PRN. -->
	<!-- Swap placeholders to display PRN followed by Frequency -->
	<xsl:variable name="FreqPRNConnector" as="xs:string">
		<xsl:value-of select="'%1$s enligt behov f&#246;r %2$s'"/>
	</xsl:variable>
	
	<!-- Used to display either of PRN Reason or PRN Instructions -->
	<xsl:variable name="PRNConnector" as="xs:string">
		<xsl:value-of select="'vid behov f&#246;r %1$s'"/>
	</xsl:variable>

	<xsl:variable name="SeeInstructions" as="xs:string">
		<xsl:value-of select="'Se instruktion'"/>
	</xsl:variable>
	
	<xsl:variable name="Printed" as="xs:string">
		<xsl:value-of select="'Utskrivet recept'"/>
	</xsl:variable>

	<xsl:variable name="DisplayNote" as="xs:string">
		<xsl:value-of select="'F&#246;rskrivna l&#228;kemedel som inte n&#228;mns ovan ska tas enligt anvisningarna. Om du har n&#229;gra fr&#229;gor eller k&#228;nner dig os&#228;ker ang&#229;ende n&#229;gra av dina andra l&#228;kemedel ska du kontakta den f&#246;rskrivande l&#228;karen.'"/>
	</xsl:variable>

	<xsl:variable name="UnchangedMedsDisplayNote" as="xs:string">
		<xsl:value-of select="'F&#246;rskrivna l&#228;kemedel ska tas enligt anvisningarna. Om du har n&#229;gra fr&#229;gor eller k&#228;nner dig os&#228;ker ang&#229;ende n&#229;gra av dina andra l&#228;kemedel ska du kontakta den f&#246;rskrivande l&#228;karen.'"/>
	</xsl:variable>
	
</xsl:stylesheet>