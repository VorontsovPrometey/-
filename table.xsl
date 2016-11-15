<?xml version="1.0" encoding="windows-1251"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xs="http://www.w3.org/2001/XMLSchema" 
xmlns:rs="urn:schemas-microsoft-com:rowset"
xmlns:dt='uuid:C2F41010-65B3-11d1-A29F-00AA00C14882'
xmlns:msdata="urn:schemas-microsoft-com:xml-msdata" 
xmlns:ms="urn:schemas-microsoft-com:xslt"
xmlns:msxsl="urn:schemas-microsoft-com:xslt"
xmlns:msprop="urn:schemas-microsoft-com:xml-msprop">

<xsl:decimal-format name="ex" decimal-separator="." grouping-separator=","
   infinity="INFINITY" minus-sign="-" NaN="-" percent="%"
   per-mille="m" zero-digit="0" digit="#" pattern-separator=";" /> 

<xsl:output method="html" />

<xsl:template match="/">


<table class="sort-table">
<colgroup>
	<xsl:call-template name="colgroup"/>
</colgroup>
<thead>
<tr>
	<xsl:call-template name="thead"/>
</tr>
</thead>
<tbody>
	<xsl:apply-templates select="*/*[2]" />
</tbody>
</table>

</xsl:template>

<!--  тэги col -->
<xsl:template name="colgroup">
	<xsl:for-each select="*/*[1]/*/*/*/@dt:type">
		<xsl:choose>                 
			<xsl:when test=".='int'">
<col class="int" align="right" />
			</xsl:when>
			<xsl:when test=".='decimal'">
<col class="int" align="right" />
			</xsl:when>
			<xsl:when test=".='number'">
<col class="int" align="right" />
			</xsl:when>
			<xsl:when test=".='dateTime'">
<col class="datetime" />
			</xsl:when>
			<xsl:when test=".='xs:base64Binary'">
<col class="blob" />
			</xsl:when>
			<xsl:otherwise>
<col />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
</xsl:template>

<!-- тэги thead -->
<xsl:template name="thead">
	<xsl:for-each select="*/*[1]/*/*/@name">
		<xsl:choose>                 
			<xsl:when test="./../*[1]/@dt:type='uuid'">
			</xsl:when>
			<xsl:otherwise>
<td class="column_header">
	<xsl:choose>                 
		<xsl:when test="ms:string-compare(../@rs:name, '')=0">
	<xsl:value-of select="../@name" />
			</xsl:when>
			<xsl:otherwise>
	<xsl:value-of select="../@rs:name" />
			</xsl:otherwise>
		</xsl:choose>
</td>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
</xsl:template>

<!-- тэги tr -->
<xsl:template match="*/*[2]/*">
	<tr>
	<xsl:if test="position() mod 2 = 0">
		<xsl:attribute name="class">odd</xsl:attribute> 
	</xsl:if> 
	<xsl:call-template name="td">
		<xsl:with-param name="row" select="."/>
	</xsl:call-template>
	</tr>                                        
</xsl:template>

<!-- колонки -->
<xsl:template name="td">
	<xsl:param name="row"/>
	<xsl:for-each select="/*/*[1]/*/*/@name">
		<xsl:choose>                 
			<xsl:when test="./../*[1]/@dt:type='uuid'">
			</xsl:when>
			<xsl:otherwise>
		<td>
		<xsl:choose>                 
			<xsl:when test="./../*[1]/@dt:type='dateTime'">
	<xsl:value-of select="ms:format-date($row/@*[local-name()=current()],'dd.MM.yy')" />
			</xsl:when>
			<xsl:when test="./../*[1]/@dt:type='number'">
				<xsl:attribute name="class">digit</xsl:attribute>	
				<xsl:value-of select="format-number($row/@*[local-name()=current()],'#,##0.00','ex')" />
			</xsl:when>
			<xsl:otherwise>
	<xsl:value-of select="$row/@*[local-name()=current()]" />
			</xsl:otherwise>
		</xsl:choose>
		</td>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
</xsl:template>

</xsl:stylesheet>
