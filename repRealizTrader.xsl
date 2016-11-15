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
<col class="int" align="right"/>
<col class="int" align="right"/>
<col class="int" align="right"/>
<col class="int" align="right"/>
<col class="int" align="right"/>
<col class="int" align="right"/>
</colgroup>
<thead>
<tr>
<td class="column_header">Контрагент</td>
<td class="column_header">Культура</td>
<td class="column_header">Количество,т</td>
<td class="column_header">Сумма</td>
<td class="column_header">Сумма,$</td>
<td class="column_header">Прибыль</td>
<td class="column_header">НДС</td>
<td class="column_header">Прибыль с НДС</td>
</tr>
</thead>
<tbody id="oTBody">
	<xsl:apply-templates select="*/*[2]" />
</tbody>
</table>
</xsl:template>

<!-- тэги tr -->
<xsl:template match="*/*[2]/*">
	<tr>
	<xsl:if test="position() mod 2 = 0">
		<xsl:attribute name="class">odd</xsl:attribute> 
	</xsl:if> 
		<td>
	<xsl:value-of select="@contragentname" />
		</td>
		<td>
	<xsl:value-of select="@goodsname" />
		</td>
		<td class="digit">
	<xsl:value-of select="@amount" />
		</td>
		<td class="digit">
	<xsl:value-of select="@summa" />
		</td>
		<td class="digit">
	<xsl:value-of select="@usd" />
		</td>
		<td class="digit">
	<xsl:value-of select="@profit" />
		</td>
		<td class="digit">
	<xsl:value-of select="@nds" />
		</td>
		<td class="digit">
	<xsl:value-of select="@profitnds" />
		</td>
	</tr>                                        
</xsl:template>

</xsl:stylesheet>
