<%@ LANGUAGE="JScript" CODEPAGE="1251" %>
<% Response.Expires = -1 %>
<!--  #include file="connstr.inc" -->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
<script language="javascript">
function ResetAll() {
	var cs = document.getElementsByTagName('input');
	for (i=0; i < cs.length; i++) {
		if (cs[i].type == 'checkbox') {
			cs[i].checked = false;
		}
	}
}

function ShowLevel(row,lv) {
	var tBody = row.parentNode;
	var i = row.rowIndex;
	row = tBody.rows[i]; // ������� ������� � ��������� ������
	while (row && row.className.substring(3)*1 > lv) {
		if (row.className.substring(3)*1 == lv+1) {
			row.style.display = 'table-row';
			if ((row.querySelector('td input')) && row.querySelector('td input').checked) {
				ShowLevel(row,lv+1);
			}
		}
		i+=1;
		row = tBody.rows[i];
	}
}

function HideLevel(row,lv) {
	var i = row.rowIndex;
	var tBody = row.parentNode;
	row = tBody.rows[i]; // ������� ������� � ��������� ������
	while (row && row.className.substring(3)*1 > lv) {
		row.style.display = 'none';
		i+=1;
		row = tBody.rows[i];
	}
}

function sh(el) {
	var row = el.parentNode.parentNode.parentNode;
	var lv = row.className.substring(3)*1; // ������� ������, ������� ����� 'lev'
	if (row.querySelector('td input').checked) {
		HideLevel(row,lv);
	} else {
		ShowLevel(row,lv);
	}
}

function SwapAll(b) {
	var tbl = document.getElementsByClassName('treetable')[0];
	for (i=1; i < tbl.rows.length; i++) {
		if (tbl.rows[i].className != 'lev1') {
			if (b) {tbl.rows[i].style.display = 'table-row';}
			else {tbl.rows[i].style.display = 'none';}
		}

		if (tbl.rows[i].querySelector('td input')) {tbl.rows[i].querySelector('td input').checked = b;}
	}
}
</script>
<style>
.treetable {
	border-collapse:collapse;
}
.treetable th {
	background:#4682B4;
	color: #FFFFFF;
}
.treetable td, th {
	padding:3px;
	border:1px solid #D3D3D3;
	width:200px;
}
.treetable label a{
	cursor:pointer;
	color:black;
	font-weight:bold;
	padding-left:16px;
}
.treetable tr {
	display:none;
}
.treetable thead tr {
	display:table-row;
}
.treetable .lev1 {
	background:#EEE8CD;
	display:table-row;
}
.lev2 {
	background:#fbfbe5;
}
.lev3 {
	background:#fbfbe5;
}
input[type="checkbox"]{
	display:none;
}
input + a {
	background:url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAsAAAALCAIAAAAmzuBxAAAACXBIWXMAAAsSAAALEgHS3X78AAAAkElEQVQYlXWOvRWDQAyDv/DYK2wQSro8OkpGuRFcUjJCRmEE0TldCpsjPy9qzj7Jki62Pgh4vnqbbbEWuN+use/PlArwHccWGg780psENGFY6W4YgxZIAM339WmT3m397YYxxn6aASslFfVotYLTT3NwcuTKlFpNR2sdEak4acdKeafPlE2SZ7sw/1BEtX94AXYTVmyR94mPAAAAAElFTkSuQmCC)
	no-repeat 0px 5px;
}
input:checked + a{
	background:url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAsAAAALCAIAAAAmzuBxAAAACXBIWXMAAAsSAAALEgHS3X78AAAAeklEQVQYlX2PsRGDMAxFX3zeK9mAlHRcupSM4hFUUjJCRpI70VHIJr7D8BtJ977+SQ9Zf7isVG16WSQC0/D0OW/FqoBlDFkIVJ2xAhA8sI/NHbcYiFrPfI0fGklKagDx2F4ltdtaM0J9L3dxcVxi+zv62E+MwPs7c60dClRP6iug7wUAAAAASUVORK5CYII=)
	no-repeat 0px 5px;
}
td+td+td+td {text-align:right;}
</style>

<% WriteStyle()
%>
<title>������� ���� �� �������� ����������</title>

</head>

<body>
<% WriteHeader(); %>
	<div id="container">
		<div id="inner">

<h1>������� ���� �� �������� ����������</h1>
<button onclick="SwapAll(false);">�������� ���</button></a>
<button onclick="SwapAll(true);">���������� ���</button></a>
<br><br>
<table class="treetable">
<thead>
<tr>
<th>��������</th> 
<th>������</th> 
<th>���������</th>
<th>�������(��������)</th> 
<th>����� �� ���������, �</th> 
<th>������� �����, �</th>
<th>���������� ����������, �</th> 
<th>�������� ���������, �</th>
<th>����� ��������, �</th> 
<th>���� �������, � ������</th> 
<th>������� ���� ������� ����</th>
</tr>
</thead>
<%
Number.prototype.formatMoney = function(c, d, t){
var n = this, 
    c = isNaN(c = Math.abs(c)) ? 2 : c, 
    d = d == undefined ? "." : d, 
    t = t == undefined ? "," : t, 
    s = n < 0 ? "-" : "", 
    i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "", 
    j = (j = i.length) > 3 ? j % 3 : 0;
   return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
 };

  var conn=null;
  var sql="exec repContractQuote null, null, 2, 0, 840";
  try {
    conn=getConnection(false);
    conn.CommandTimeout=160;
    var rs=conn.Execute(sql);
    while (!rs.eof) 
    {
       var levl=rs("levl").value;
       if (levl>=1) {rs.MoveNext(); continue;};
       var name=rs("name").value;
	   if (name!=null && name=="�������") name="������� (���������)";
       var rest=rs("rest").value;
       var since=rs("since").value;
       var till=rs("till").value;
       var trader=rs("contragentname").value;
       var traderport= rs("placename").value != null ? trader + " (" + rs("placename").value + ")" : trader;
       var amount=rs("amount").value;	   
	   var supplyRest=amount;
	   if (amount!=null) amount= (1.0*amount).formatMoney(0, '.', ',');
       var fact=rs("fact").value;
	   supplyRest = supplyRest - fact;
       if (fact!=null) fact= (1.0*fact).formatMoney(0, '.', ',');
	   if (supplyRest!=null) supplyRest= (1.0*supplyRest).formatMoney(0, '.', ',');
       var rest=rs("rest").value;
       if (rest!=null) rest= (1.0*rest).formatMoney(0, '.', ',');	   
       var valprice=rs("valprice").value;
       if (valprice!=null) valprice= (1.0*valprice).formatMoney(2, '.', ',');	   
	   var avgprice=rs("avgprice").value;
       if (avgprice!=null) avgprice= (1.0*avgprice).formatMoney(2, '.', ',');
	   var needtobuy=rs("needtobuy").value;
       if (needtobuy!=null) needtobuy= (1.0*needtobuy).formatMoney(0, '.', ',');
	   
       if (levl==-1) {
%>
<tr class="lev<%=levl+2%>">
<td><label><input type="checkbox"><a onclick="sh(this)"><%=name%></a></label></td>
<%
       } else { 
%>
<tr class="lev<%=levl+2%>">
<td><%=name%></td>
<%
       }
%>
<td><%=since%></td>
<td><%=till%></td>
<td><%=traderport%></td>
<td><%=amount%></td>
<td><b><%=rest%></b></td>
<td><%=fact%></td>
<td><%=supplyRest%></td>
<td><b><%=needtobuy%></b></td>
<td><%=valprice%></td>
<td><%=avgprice%></td>
</tr>
<%
      rs.MoveNext();
    };
  } catch(e) {
    Response.Write(e.message+'; ������ ���������� �������: '+sql);
  }
%>
		</div>
	</div> <!--end container-->
</body>
</html>