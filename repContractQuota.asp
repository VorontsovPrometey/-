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
function SwapGoods(b) {
	var tbl = document.getElementsByClassName('treetable')[0];
	for (i=1; i < tbl.rows.length; i++) {
		if (tbl.rows[i].className != 'lev1' && tbl.rows[i].className != 'lev3') {
			if (b) {tbl.rows[i].style.display = 'table-row';
					if (tbl.rows[i].querySelector('td input')) {tbl.rows[i].querySelector('td input').checked = !b;}}
			else {tbl.rows[i].style.display = 'none';}
		}
		else { if (tbl.rows[i].querySelector('td input')) {tbl.rows[i].querySelector('td input').checked = b;}}
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
	background:#f0f0e5;
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
<title>Квоты по контрактам</title>

</head>

<body>
<% WriteHeader(); %>
	<div id="container">
		<div id="inner">

<h1>Квоты по контрактам</h1>
<button onclick="SwapAll(false);">Свернуть все</button></a>
<button onclick="SwapAll(true);">Развернуть все</button></a>
<br><br>
<table class="treetable">
<thead>
<tr>
<th>Культура</th> 
<th>Культура</th> 
<th>Начало</th> 
<th>Окончание</th>
<th>Трейдер(терминал)</th> 
<th>Объем по контракту, т</th> 
<th>Зарезер- вировано, т</th> 
<th>Остаток, т</th> 
<th>Цена продажи, грн</th> 
<th>Цена продажи, валюта</th> 
<th>Цена учетная, грн</th> 
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
  var sql="exec repContractQuote";
  try {
    conn=getConnection(false);
    conn.CommandTimeout=160;
    var rs=conn.Execute(sql);
    while (!rs.eof) 
    {
       var levl=rs("levl").value;
       var name=rs("name").value;
	   var goodsname= rs("goodsname").value;
	   var datearray = rs("since").value == null ? "" : rs("since").value.split("-");
       var since= datearray=="" ? "" : datearray[2] + '.' + datearray[1] + '.' + datearray[0];
	   var datearray = rs("till").value == null ? "" : rs("till").value.split("-");
       var till = datearray=="" ? "" : datearray[2] + '.' + datearray[1] + '.' + datearray[0];
       var trader=rs("contragentname").value;
       var traderport= rs("placename").value != null ? trader + " (" + rs("placename").value + ")" : trader;
	   var amount=rs("amount").value;
       if (amount!=null) amount= (1.0*amount).formatMoney(3, '.', ',');
       var valprice=rs("valprice").value;
       if (valprice!=null) valprice= (1.0*valprice).formatMoney(2, '.', ',');
       if (Session.Contents("Ismanager")==true) valprice='';

       var reserved=rs("reserved").value;
       if (reserved!=null) reserved= (1.0*reserved).formatMoney(3, '.', ',');
       var rest=rs("rest").value;
       if (rest!=null) rest= (1.0*rest).formatMoney(3, '.', ',');
       var price=rs("price").value;
       if (price!=null) price= (1.0*price).formatMoney(2, '.', ',');
       var cost=rs("cost").value;
       if (cost!=null) cost= (1.0*cost).formatMoney(2, '.', ',');
       var curname=rs("curname").value;
       if (levl<=0) {
%>
<tr class="lev<%=levl+2%>">
<td  <% if (1==1) { %>style="background:<%=rs("color").value%>" <% }; %>><label><input type="checkbox"><a onclick="sh(this)"><%=levl==0?trader:name%></a></label></td>
<%
       } else { 
%>
<tr class="lev<%=levl+2%>">
<td><%=name%></td>
<%
       }
%>
<td><%=goodsname%></td>
<td><%=since%></td>
<td><%=till%></td>
<td><%=traderport%></td>
<td><%=amount%></td>
<td><%=reserved%></td>
<td><b><%=rest%></b></td>
<td><%=price%></td>
<td><%=valprice%>&nbsp;<%=curname%></td>
<td><%=cost%></td>
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
<script language="javascript">
SwapGoods(true);
</script>
</html>