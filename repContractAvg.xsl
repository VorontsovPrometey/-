<?xml version="1.0" encoding="windows-1251"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xs="http://www.w3.org/2001/XMLSchema" 
xmlns:rs="urn:schemas-microsoft-com:rowset"
xmlns:dt='uuid:C2F41010-65B3-11d1-A29F-00AA00C14882'
xmlns:msdata="urn:schemas-microsoft-com:xml-msdata" 
xmlns:ms="urn:schemas-microsoft-com:xslt"
xmlns:msprop="urn:schemas-microsoft-com:xml-msprop">

<xsl:decimal-format name="ex" decimal-separator="." grouping-separator=","
   infinity="INFINITY" minus-sign="-" NaN="-" percent="%"
   per-mille="m" zero-digit="0" digit="#" pattern-separator=";" /> 

<xsl:output method="html" />

<xsl:template match="/">

<table class="sort-table" id="oTable" style="width:100	%">
<colgroup>
<col/>
<col/>
<col/>
<col/>
<col/>
<col/>
<col class="int" align="right"/>
<col class="int" align="right"/>
<col class="int" align="right"/>
</colgroup>
<thead>
<tr>
<td class="column_header">Контрагент</td>
<td class="column_header">Культура</td>
<td class="column_header">Доставка в</td>
<td class="column_header">Дата</td>
<td class="column_header">Осталось,т</td>
<td class="column_header">Цена,$</td>
<td class="column_header">Цена закупки</td>
</tr>
</thead>
<tbody id="oTBody">
	<xsl:apply-templates select="*/*[2]" />
</tbody>
</table>
</xsl:template>

<!-- тэги tr -->
<xsl:template match="*/*[2]/*">
	<xsl:if test="@levl = 1">
	<tr>
	<xsl:if test="position() mod 22222 = 0">
		<xsl:attribute name="class">odd</xsl:attribute> 
	</xsl:if> 
		<td>
	<xsl:value-of select="@contractorname" />
		</td>
		<td>
	<xsl:value-of select="@culturename" />
		</td>
		<td>
	<xsl:value-of select="@placename" />
		</td>
		<td>
	<xsl:value-of select="ms:format-date(@dt,'dd.MM.yy')" />
		</td>
		<td class="digit">
	<xsl:value-of select="format-number(@rest,'#0','ex')" />
		</td>
		<td class="digit">
	<xsl:value-of select="format-number(@price,'#0.00','ex')" />
		</td>
		<td class="digit">
	<xsl:value-of select="format-number(@pricein,'#0','ex')" />
		</td>
	</tr>                                        
	</xsl:if> 
</xsl:template>

</xsl:stylesheet>
