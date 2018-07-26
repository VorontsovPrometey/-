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
%>
<script language="JavaScript">

function sm(cost,divis) {
//  cmd="sm.asp?since=<%=since %>&till=<%=d %>&divis="+divis+"&cost="+cost;
  var sql="repAnalWebCosts '"+cost+"','"+divis+"','<%=dateToSQL(since) %>','<%=dateToSQL(d) %>',null";
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
function prof(goods) {
  var sql="webContractProfitByPeriod '<%=dateToSQL(since) %>','<%=dateToSQL(d) %>','"+goods+"'";
  var cmd="tbl.asp?query="+escape(sql);
  window.open(cmd,'_blank')
}
</script>
</HEAD>
<BODY>
<% WriteHeader(); 
function adddivis(divis,kind,name,cost,incom,profit,mtb,dopcost,dopincom,future){
  this.divis=divis; this.kind=kind; this.name=name; this.cost=cost; this.incom=incom;
  this.profit=profit; this.mtb=mtb; this.dopcost=dopcost; this.dopincom=dopincom; this.future=future;
}
function addgoods(divis,incom,analkey,name,amount,summa){
  this.divis=divis; this.incom=incom; this.analkey=analkey; this.name=name; this.amount=1.0*amount; this.summa=1.0*summa;
}
function addcosts(divis,kind,cost,name,summa){
  this.divis=divis; this.kind=kind; this.cost=cost; this.name=name; this.summa=summa;
}
function addincoms(divis,kind,incom,name,summa){
  this.divis=divis; this.kind=kind; this.incom=incom; this.name=name; this.summa=summa;
}
function addgrdivis(mainDivis,divis,mainDivisName,divisName,summa){
  this.mainDivis=mainDivis; this.divis=divis; this.mainDivisName=mainDivisName; this.divisName=divisName; this.summa=summa;
}
var divisrows=new Array();
var goodsrows=new Array();
var costrows=new Array();
var incomrows=new Array();
var grdivisrows=new Array();

function writecolgroup(){
Response.Write('<colgroup>'
+'<col class="string" width="30%"/>'
+'<col class="digit" width="10%"/>'
+'<col class="digit" width="10%"/>'
+'<col class="digit" width="10%"/>'
+'<col class="digit" width="10%"/>'
+'<col class="digit" width="10%"/>'
+'<col class="digit" width="10%"/>'
+'</colgroup>');
}

function processDivis(kind, divis) 
{
  var qg=0;
  for (var i=0; i<goodsrows.length;i++) {
    var c=goodsrows[i];
    if (c.divis==divis) qg++;
  }
%>
<tr>
<td colspan="7">
<details><summary align="left"></summary>
<div style="display:block">
	<table width="100%">
	<colgroup>
		<col  width="50%"/>
		<col  width="50%"/>
	</colgroup>
	<tbody>
	<tr>
	<td>
	<h3>Расходы</h3>
<%
	if (divis==grdivisrows[0].mainDivis)
	{
	  for (var t=0; t<grdivisrows.length;t++) {
	  var gd=grdivisrows[t];
%>
	<details><summary align="left">
		<table width="100%">
		<colgroup>
		<col  width="50%"/>
		<col  width="50%"/>
		</colgroup>
		<tr>
			<th><%=gd.divisName%></th>
			<th><%=gd.summa.formatMoney(0, '.', ',')%></th>
		</tr>
		</table>
	</summary>
	<table class="grid" width="100%">
	<tbody>
	<tr>
	<th>статья</th>
	<th>сумма</th>
	</tr>
<%
  for (var i=0; i<costrows.length;i++) {
    var c=costrows[i];
    if (c.divis==gd.divis&&c.kind==kind) {
%>
	<tr>
	<td><%=c.name%></td>
	<td class="digit"><a href="javascript:sm('<%=c.cost%>','<%=c.divis%>')"><%=c.summa.formatMoney(0, '.', ',')%></a></td>
	</tr>
<%
    }
  }
%>
	</table>
	</details>
<%
		}	
	} else {
%>
	<table class="grid" width="100%">
	<tbody>
	<tr>
	<th>статья</th>
	<th>сумма</th>
	</tr>
<%
  for (var i=0; i<costrows.length;i++) {
    var c=costrows[i];
    if (c.divis==divis&&c.kind==kind) {
%>
	<tr>
	<td><%=c.name%></td>
	<td class="digit"><a href="javascript:sm('<%=c.cost%>','<%=c.divis%>')"><%=c.summa.formatMoney(0, '.', ',')%></a></td>
	</tr>
<%
    }
  }
%>
	</table>
<%
  }
%>
	</td>
	<td>
	<h3>Доходы</h3>
	<table class="grid" width="100%">
	<colgroup>
		<col  width="70%"/>
<% if (qg>0) { %>
		<col  width="15%"/>
<% } %>
		<col/>
	</colgroup>
	<th>
	<tr>
	<th>статья</th>
<% if (qg>0) { %>
	<th>количество</th>
<% } %>
	<th>сумма</th>
	</tr>
	</th>
	<tbody>
<%
  var q=0.0; sm=0.0;
  for (var i=0; i<goodsrows.length;i++) {
    var c=goodsrows[i];
    if (c.divis==divis) {
      if (c.analkey!=null) {
        q=q+1.0*c.amount; sm=sm+1.0*c.summa;
      };
%>
	<tr>
	<td><%=c.name %></td>
	<td class="digit"><%=c.amount.formatMoney(0, '.', ',')%></td>
	<td class="digit"><a href="javascript:prof('<%=c.analkey%>')"><%=c.summa.formatMoney(0, '.', ',')%></a></td>

	</tr>
<%
    }
  }
  if (qg>0) {
%>
	<tr>
	<td>всего реализация</td>
	<td class="digit"><%=q.formatMoney(0, '.', ',')%></td>
	<td class="digit"><%=sm.formatMoney(0, '.', ',')%></td>
	</tr>
<%
  }
  for (var i=0; i<incomrows.length;i++) {
    var c=incomrows[i];
    if (c.divis==divis&&c.kind==kind) {
%>
	<tr>
	<td><%=c.name %></td>
<% if (qg>0) { %>
	<td class="digit"></td>
<% } %>
	<td class="digit"><a href="javascript:inc('<%=c.incom%>','<%=c.divis%>')"><%=c.summa.formatMoney(0, '.', ',')%></a></td>
	</tr>
<%
    }
  }
%>
	</tbody>
	</table>
	</td>
	</tr>
	</tbody>
	</table>
</div>
</details>
</td>
</tr>
<%
};
// выполняем и запоминаем
  var conn=null;
  var sql="exec repCostIncomsNew null,'"+dateToSQL(since)+"','"+dateToSQL(d)+"'";
  try {

    conn=getConnection(false);
    conn.CommandTimeout=160;

    var rs=conn.Execute(sql);
    var rowno=0;
    while (!rs.eof) {
      divisrows[rowno]=new adddivis(rs(0).value,rs(1).value,rs(2).value,1*rs(3),1*rs(4),1*rs(5),1*rs(6),1*rs(7),1*rs(8),1*rs(9));
      rowno++;
      rs.MoveNext();
    };
    rs=rs.NextRecordset;

    rowno=0;
    while (!rs.eof) {
      goodsrows[rowno]=new addgoods(rs(0).value,rs(1).value,rs(2).value,rs(3).value,1*rs(4).value,rs(5).value);
      rowno++;
      rs.MoveNext();
    };
    rs=rs.NextRecordset;
	
    rowno=0;
    while (!rs.eof) {
      costrows[rowno]=new addcosts(rs(0).value,rs(1).value,rs(2).value,rs(3).value,1*rs(4).value);
      rowno++;
      rs.MoveNext();
    };
    rs=rs.NextRecordset;

	var rowno=0;
    while (!rs.eof) {
      grdivisrows[rowno]=new addgrdivis(rs(0).value,rs(1).value,rs(2).value,rs(3).value,1*rs(4));
      rowno++;
      rs.MoveNext();
    };
    rs=rs.NextRecordset;	
	
    rowno=0;
    while (!rs.eof) {
      incomrows[rowno]=new addincoms(rs(0).value,rs(1).value,rs(2).value,rs(3).value,1*rs(4).value);
      rowno++;
      rs.MoveNext();
    };
    rs=rs.NextRecordset;
  } catch(e) {
    Response.Write(e.message+'; Ошибка выполнения запроса: '+sql);
  }
%>
	<div id="container">
		<div id="inner">
<h1>Прибыль текущая</h1>
<form name="criteria" action="costincomnew.asp" method="POST">
<fieldset>
с&nbsp;<input class="date" type=Text name="since" size=5 maxlength=10 value="<%=dateToStr(since) %>"> 
по&nbsp;<input class="date" type=Text name="ondate" size=5 maxlength=10 value="<%=dateToStr(d) %>">
<input name="go" type="submit" value="пересчитать" class="button1" />
</fieldset>
</form>

<table name="tbl" id="tbl" class="grid" width="100%">
<% writecolgroup(); %>
<thead>
<tr>
<th>Подразделение</th>
<th>Расходы</th>
<th>Доходы</th>
<th>в т.ч.доп расходы</th>
<th>в т.ч.доп доходы</th>
<th>Прибыль</th>
<th>Лизинг и оборудование</th>
</tr>
</thead>
<tbody align="right">
<%
var level=0; prevkind=0; prevdiv=null;
for (var i=0;i<divisrows.length;i++)
{
  var r = divisrows[i];
  if ((r.kind>1)&&(prevkind==1)) 
  {
%></tbody></table></details></td></tr><%
    level--;
  }
%><tr><td><%=r.name%></td><td><%=r.cost.formatMoney(0, '.', ',')%></td><td><%=r.incom.formatMoney(0, '.', ',')%></td><td><%=r.dopcost.formatMoney(0, '.', ',')%></td><td><%=r.dopincom.formatMoney(0, '.', ',')%></td><td><%=r.profit.formatMoney(0, '.', ',')%></td><td><%=r.mtb.formatMoney(0, '.', ',')%></td></tr>
<%
  if (r.kind==15) 
  {
 %><tr><td>---------------------------------------</td><td>--------------------</td><td>--------------------</td>
													   <td>--------------------</td><td>--------------------</td>
													   <td>--------------------</td><td>--------------------</td></tr><%
  }
  if (((r.divis==null)&&(r.kind==1))) 
  {
    level++; 
%><tr><td colspan="7"><details><summary align="left">в т.ч.</summary>
<table width="100%">
<% writecolgroup(); %>
<tbody align="right">
<%
  }
  if (r.divis!=null) 
    processDivis(r.kind, r.divis);
  prevkind = r.kind;
  prevdiv = r.divis;
}
%>
</tbody>
</table>
</div>
</div> <!--end container-->
</BODY>
</HTML>
