<%@ LANGUAGE="JScript" CODEPAGE="1251" %>
<% 
trySession();
Response.CacheControl = "no-cache"
Response.AddHeader("Pragma", "no-cache") 
Response.Expires = -1 
Session.Timeout = 480
%>
<!--  #include file="connstr.inc" -->
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<%
WriteStyle(); 

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


// дата
var s=''+Request.ServerVariables('Request_Method');
var d=new Date();
var diff=5;
if ((s.indexOf('POST')>=0)&&(''+Request.Form("ondate")!='undefined')) {
  d=parseDate(""+Request.Form("ondate"));
} else {
//  d=''+d.getDate()+'.'+(d.getMonth()+1)+'.'+d.getYear()
  d=new Date(Session.Contents('till'));
}
var since=new Date();
if ((s.indexOf('POST')>=0)&&(''+Request.Form("since")!='undefined')) {
  since=parseDate(""+Request.Form("since"));
} else {
//  since.setDate(1);
  since=new Date((Session.Contents('since')));
}
if ((s.indexOf('POST')>=0)&&(''+Request.Form("diff")!='undefined')) {
  diff=1*Request.Form("diff");
}
%>
<style>

summary > span {
	background-color: #fbfbe5;
	margin-left: -1.1em;
}

summary {
	cursor: pointer;
	outline: 0;
}
summary::-webkit-details-marker { color:#fbfbe5 }
table {border: 1px solid}
</style>
<script language="JavaScript">
function callCassa() {
  cmd="cassa.asp?since=<%=dateToSQL(since) %>&till=<%=dateToSQL(d) %>";
  window.open(cmd,'_blank')
}

function sm(cost,divis) {
//  cmd="sm.asp?since=<%=since %>&till=<%=d %>&divis="+divis+"&cost="+cost;
  var sql="repAnalWeb '"+cost+"','"+divis+"',null,'<%=dateToSQL(since) %>','<%=dateToSQL(d) %>',null";
  var cmd="tbl.asp?query="+escape(sql);
  window.open(cmd,'_blank')
}
function inc(cost,divis) {
//  cmd="sm.asp?since=<%=since %>&till=<%=d %>&divis="+divis+"&cost="+cost;
  var sql="repAnalWeb '"+cost+"','"+divis+"',null,'<%=dateToSQL(since) %>','<%=dateToSQL(d) %>',null";
  var cmd="tbl.asp?query="+escape(sql);
  window.open(cmd,'_blank')
}
function g(goods,incom,divis) {
  var sql="repAnalWeb '"+incom+"','"+divis+"','"+goods+"','<%=dateToSQL(since) %>','<%=dateToSQL(d) %>',null";
  var cmd="tbl.asp?query="+escape(sql);
  window.open(cmd,'_blank')
}
</script>
</HEAD>
<BODY>
<% WriteHeader(); 

function writecolgroup(){
Response.Write('<colgroup>'
+'<col class="string" width="40%"/>'
+'<col class="digit" width="10%"/>'
+'<col class="digit" width="10%"/>'
+'<col class="digit" width="10%"/>'
+'<col class="digit" width="10%"/>'
+'<col class="digit" width="10%"/>'
+'<col class="digit" width="10%"/>'
+'</colgroup>');
}

// выполняем и запоминаем
  var conn=null;
  var sql="exec repDeltaAcc '"+dateToSQL(since)+"','"+dateToSQL(d)+"',null,1,"+diff;
%>
	<div id="container">
		<div id="inner">
<h1>Дельта</h1>
<form name="criteria" action="delta2.asp" method="POST">
<fieldset>
с&nbsp;<input class="date" type=Text name="since" size=5 maxlength=10 value="<%=dateToStr(since) %>"> 
по&nbsp;<input class="date" type=Text name="ondate" size=5 maxlength=10 value="<%=dateToStr(d) %>">
<br/>%<select name="diff"><option value="5" <% if (diff==5){%>selected<%}%>>5%</option>
<option value="2" <% if (diff==2){%>selected<%}%>>2%</option>
<option value="0"  <% if (diff==0){%>selected<%}%>>все</option></select>
<input name="go" type="submit" value="пересчитать" class="button1" />
</fieldset>
</form>

<%
  var divisname='';
  var since;
  var till;
  var delta=0.0;
  var last;
  try {

    conn=getConnection(false);
    conn.CommandTimeout=160;

    var rs=conn.Execute(sql);
    if (!rs.eof) 
    {
      divisname=rs('divisname').value;
      since=rs('since').value;
      till=rs('till').value;
      last=rs('last').value;
      delta=(1.0*rs('delta').value).formatMoney(0, '.', ',');
    };
%>
<h2>Дельта: <%=(1.0*rs("delta").value).formatMoney(0, '.', ',')%></h2>
<table name="tbl" id="tbl" class="grid" width="100%">
<%
    rs=rs.NextRecordset;
    writecolgroup();
%>
<thead>
<tr>
<th>Показатель</th>
<th>Всего</th>
<th>в т.ч. $</th>
<th>в т.ч. eur</th>
<th>в т.ч. грн</th>
<!--<th>процент</th>-->
<th>Изменилось с <%=since%></th>
<th>Изменилось с <%=last%></th>
</tr>
</thead>
<tbody>
<%
    var prevlevl = 1; var levl=0;
    while (!rs.eof) 
    {
      var down=false; var up=false;
      levl=rs("levl").value;
      var proc=rs("prcnt").value;
      var qch=rs("qch").value;
//      if ((levl==1)&&(proc>0)) down=true;
      if ((qch>0)) down=true;
      if (levl<prevlevl) up=true; 
      if (up==true) 
      {
         for (var i=levl;i<prevlevl;i++) {
%></tbody></table></detail></td>
<%       }
         //levl=prevlevl;
      }
      if (down==true) {
%><tr><td colspan="7"><details><summary align="left"><span>
<table width="100%">
<% writecolgroup(); %>
<tbody>
<%
      }
%>
<tr><td><%=rs('name').value%><%=1.0*rs('prcnt').value==0?'':' ('+(1.0*rs('prcnt').value).formatMoney(0, '.', ',')+'%)'%></td>
<td class="boldnumber"><b><%=(1.0*rs('total').value).formatMoney(0, '.', ',')%></b></td>
<td class="number"><%=(1.0*rs('usd').value).formatMoney(0, '.', ',')%></td>
<td class="number"><%=(1.0*rs('eur').value).formatMoney(0, '.', ',')%></td>
<td class="number"><%=(1.0*rs('uah').value).formatMoney(0, '.', ',')%></td>
<!--<td class="number"><%=levl==1?'':(1.0*rs('prcnt').value).formatMoney(0, '.', ',')%>-->
<td class="number"><%=(1.0*rs('diff').value).formatMoney(0, '.', ',')%></td>
<td class="number"><%=rs('change').value==0?'':(1.0*rs('change').value).formatMoney(0, '.', ',')%></td>
</tr>
<% 
      if (down==true)
      {
%></tbody></table></span></summary>
<table width="100%">
<% writecolgroup(); %>
<tbody align="right">
<%
      }
%>
<%    prevlevl = levl;
      rs.MoveNext();
    };
         for (var i=levl;i>1;i--) {
%></tbody></table></detail></td>
<%       }

%>
<tr><td colspan="7"><h2>Результат деятельности за период с <%=since%> по <%=till%></h2></td>
<%
    rs=rs.NextRecordset;
    if (!rs.eof) 
    {
%>
<tr><td>Прибыль</td><td class="number"><%=(1.0*rs("profit").value).formatMoney(0, '.', ',')%></td>
<tr><td>Дополнительная прибыль</td><td class="number"><%=(1.0*rs("a105").value).formatMoney(0, '.', ',')%></td>
<tr><td>Дополнительные убытки</td><td class="number"><%=(1.0*rs("a106").value).formatMoney(0, '.', ',')%></td>
<tr><td>Результат деятельности</td><td class="number"><%=(1.0*rs("result").value).formatMoney(0, '.', ',')%></td>

<tr><td colspan="7"><h2>Прибыль за дату <%=rs("profitday").value%></h2></td>
<tr><td> - от продажи товара</td><td class="number"><%=(1.0*rs("realizprofit").value).formatMoney(0, '.', ',')%></td>
<tr><td> - от услуг элеваторов</td><td class="number"><%=(1.0*rs("elevatorsprofit").value).formatMoney(0, '.', ',')%></td>
<tr><td> - от курсовой разницы</td><td class="number"><%=(1.0*rs("curratediffprofit").value).formatMoney(0, '.', ',')%></td>
<tr><td> Итого : </td><td class="number"><%=(1.0*rs("dayprofitsum").value).formatMoney(0, '.', ',')%></td>
<tr><td colspan="7"><h2>Справки</h2></td>
<tr><td>Недопоставки по договорам</td><td class="number"><%=(1.0*rs("contracts").value).formatMoney(0, '.', ',')%></td>
<tr><td>Расходы по смете</td><td class="number"><%=(1.0*rs("monthcost").value).formatMoney(0, '.', ',')%></td>
<tr><td>Курсовая разница USD</td><td class="number"><%=(1.0*rs("rateresult").value).formatMoney(0, '.', ',')%></td>
<td class="number"><%=(1.0*rs("prevusd").value).formatMoney(0, '.', ',')%></td>
<td class="number"><%=(1.0*rs("rate").value-rs("rateprev").value).formatMoney(0, '.', ',')%></td>
<tr><td>Курсовая разница EUR</td><td class="number"><%=(1.0*rs("rateeurresult").value).formatMoney(0, '.', ',')%></td>
<td class="number"><%=(1.0*rs("preveur").value).formatMoney(0, '.', ',')%></td>
<td class="number"><%=(1.0*rs("rateeur").value-rs("ratepreveur").value).formatMoney(0, '.', ',')%></td>
<%
    };
%>
</tbody>
</table>
<a href="elev.asp" target="_blank">Остатки на элеваторах</a>
<br/>
<h2>Комментарии</h2>
<ul>
<%
    rs=rs.NextRecordset;
    while (!rs.eof) 
    {
%><li><em><%=rs(1).value%><em><%=rs(2).value%></li>
<%
      rs.MoveNext();
    };

  } catch(e) {
    Response.Write(e.message+'; Ошибка выполнения запроса: '+sql);
  }
%>
</ul>
</div>
</div> <!--end container-->
</BODY>
</HTML>
