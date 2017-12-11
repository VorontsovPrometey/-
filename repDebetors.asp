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
	row = tBody.rows[i]; // Попытка перейти к следующей строке
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
	row = tBody.rows[i]; // Попытка перейти к следующей строке
	while (row && row.className.substring(3)*1 > lv) {
		row.style.display = 'none';
		i+=1;
		row = tBody.rows[i];
	}
}

function sh(el) {
	var row = el.parentNode.parentNode.parentNode;
	var lv = row.className.substring(3)*1; // Уровень строки, циферка после 'lev'
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
<title>Просроченные дебеторы</title>

</head>

<body>
<% WriteHeader(); %>
	<div id="container">
		<div id="inner">

<h1>Задолженность дебеторов более 10 дней</h1>
<button onclick="SwapAll(false);">Свернуть все</button></a>
<button onclick="SwapAll(true);">Развернуть все</button></a>
<br><br>
<table class="treetable">
<thead>
<tr>
<th>Показатель</th> 
<th>Дебетор</th> 
<th>Сумма, грн</th> 
<th>Дней</th>
<th>Последняя оплата</th>
<th>Последняя поставка</th>
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
  var sql="exec repDebitorsWeb null";
  try {
    conn=getConnection(false);
    conn.CommandTimeout=160;
    var rs=conn.Execute(sql);
    while (!rs.eof) 
    {
       var levl=rs("levl").value;
       if (levl>=1) {rs.MoveNext(); continue;};
       var dtdate= rs("dtdate").value;
	   var ctdate= rs("ctdate").value;
	   var accname=rs("accname").value;
	   var prevsaldo=rs("prevsaldo").value;	   
	   if (prevsaldo!=null) prevsaldo= (1.0*prevsaldo).formatMoney(0, '.', ' ');
       var contragent=rs("debitorname").value;
       var amount=rs("saldo").value;	   
	   if (amount!=null) amount= (1.0*amount).formatMoney(0, '.', ' ');
       var term=rs("term").value;
       if (levl==-1) {
%>
<tr class="lev<%=levl+2%>">
<td><label><input type="checkbox"><a onclick="sh(this)"><%=accname%></a></label></td>
<%
       } else { 
%>
<tr class="lev<%=levl+2%>">
<td><%=accname%></td>
<%
       }
%>
<td><%=contragent%></td>
<td><%=amount%></td>
<td><%=term%></td>
<td><%=dtdate%></td>
<td><%=ctdate%></td>
</tr>
<%
      rs.MoveNext();
    };
  } catch(e) {
    Response.Write(e.message+'; Ошибка выполнения запроса: '+sql);
  }
%>
		</div>
	</div> <!--end container-->
</body>
</html>