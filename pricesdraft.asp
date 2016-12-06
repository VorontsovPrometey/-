<%@ LANGUAGE="JScript" CODEPAGE="1251" %>
<% 
Response.Expires = -1 
Session.Timeout = 600
Server.ScriptTimeOut = 600 
%>
<!--  #include file="connstr.inc" -->
<%
function add(key,value){this.key=key; this.value=value;}
function addcell(elevator,culture,price1,price2,price3)
{
  this.elevator=elevator; this.culture=culture;
  this.price1=price1;this.price2=price2;this.price3=price3;
}

var dt = new Date();
var ondate=dateTimeToStr(dt);
var culture=new Array();
var elevator=new Array();
var cell=new Array();
var conn=null;
var sql="exec graingreen..pricesArchGrid -1";
var since;
var qcol=0;
var qelev=0;
var qcell=0;
  try {
    conn=getConnection(false);
    conn.CommandTimeout=600;
    var rs=conn.Execute(sql);
    if (!rs.eof) {since=rs("prevdt").value; };
    rs=rs.NextRecordset;
    while (!rs.eof) 
    {
      culture[qcol]=new add(1*rs(0),''+rs(1));
      qcol++;
      rs.MoveNext();
    };
    rs=rs.NextRecordset;
    while (!rs.eof) 
    {
      elevator[qelev]=new add(1*rs(0),''+rs(1));
      qelev++;
      rs.MoveNext();
    };

    rs=rs.NextRecordset;
    while (!rs.eof) 
    {
      cell[qcell]=new addcell(1*rs(1),1*rs(2),rs(3).value,rs(4).value,rs(5).value);
      qcell++;
      rs.MoveNext();
    };


%>
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<%
WriteStyle(); 
%>
<style>
.p1 {background-color:#fffbf0;}
.p2 {background-color:#C0C0C0;}
.p3 {background-color:#a6caf0;}
#prices {width: 100%}
</style>
<script src="datetimepicker_css.js"></script>
</HEAD>
<BODY>
<% WriteHeader(); %>
<div id="container">
<div id="prices">
<h2>Проект закупочных цен</h2>
<table name="tbl" id="tbl" class="grid" width="100%">
<colgroup>
<col class="string" width="10%"/>
<col class="digit" width="5%"/>
<%
  for(var i=0;i<qcol;i++)
  {
    %><col class="digit" width="<%=85/qcol%>%"/>
<%
  }
%>
</colgroup>
<thead>
<tr>
<th>Элеваторы</th>
<th>Цена</th>
<%
  for(var i=0;i<qcol;i++)
  {
    %><th><%=culture[i].value%></th>
<%
  }
%>
</tr>
</thead>
<tbody>
<%
function getv(e,p,c)
{
  var res = '';
  for(var i=0;i<qcell;i++)
  {
    if (cell[i].elevator==e)
    {
      for(var j=i;j<qcell;j++)
      {
        if (cell[j].elevator!=e) break;
        if (cell[j].culture>c) break;
        if (cell[j].culture==c)
        {
          if (p==1) return cell[j].price1;
          else if(p==2) return cell[j].price2;
          else if (p==3) return cell[j].price3;
          break;
        }
      }
      break;
    } 
    else
      if (cell[i].elevator>e) break;
  }
  return res;
}

  for(var e=0;e<qelev;e++)
  {
    for (var p=1;p<=3;p++)
    {
    %><tr class="p<%=p%>"><td><%=p==1?elevator[e].value:''%></td><td>цена <%=p%></td><%
      for(var c=0;c<qcol;c++)
      {
        var v=getv(elevator[e].key,p,culture[c].key);
    %><td class="digit"><%=v%></td><%
      }
    %></tr>
<%
    }
  }
%>
</tbody>
</table>

<div id="transit">
<h2>Транзит</h2>
<table>
<table name="ttransit" id="ttransit" class="grid" width="100%">
<colgroup>
<col class="string" width="25%"/>
<col class="string" width="20%"/>
<col class="string" width="15%"/>
<col class="digit" width="10%"/>
<col class="digit" width="10%"/>
<col class="digit" width="10%"/>
<col class="digit" width="10%"/>
</colgroup>
<thead>
<tr>
<th>Порт</th>
<th>Трейдер</th>
<th>Культура</th>
<th>Цена 1</th>
<th>Цена 2</th>
<th>Цена 3</th>
<th>Количество</th>
</tr>
</thead>
<tbody>
<%
    rs=rs.NextRecordset;
    while (!rs.eof) 
    {
%><tr><td><%=rs("portname").value%></td><td><%=rs("tradername").value%></td><td><%=rs("culturename").value%></td><td class="digit"><%=rs("price1").value%></td><td class="digit"><%=rs("price2").value%></td>
<td class="digit"><%=rs("price3").value%></td><td class="digit"><%=rs("amount").value%></td><%
%></tr><%
      rs.MoveNext();
    };
%>
</tbody>
</table>
</div>

<div id="valcon">
<h2>Валютные контракты</h2>
<table>
<table name="tvalcon" id="tvalcon" class="grid" width="100%">
<colgroup>
<col class="string" width="10%"/>
<col class="string" width="15%"/>
<col class="string" width="10%"/>
<col class="digit" width="10%"/>
<col class="digit" width="10%"/>
<col class="digit" width="10%"/>
<col class="digit" width="10%"/>
<col class="digit" width="10%"/>
<col class="digit" width="10%"/>
</colgroup>
<thead>
<tr>
<th>Порт</th>
<th>Трейдер</th>
<th>Культура</th>
<th>Цена 1</th>
<th>Цена 2</th>
<th>Цена 3</th>
<th>Сроки</th>
<th>Осталось тонн</th>
<th>Валютная цена</th>
</tr>
</thead>
<tbody>
<%
    rs=rs.NextRecordset;
    while (!rs.eof) 
    {
%><tr><td><%=rs("portname").value%></td><td><%=rs("tradername").value%></td><td><%=rs("culturename").value%></td><td class="digit"><%=rs("price1").value%></td>
<td class="digit"><%=rs("price2").value%></td><td class="digit"><%=rs("price3").value%></td><td><%=dateToStr(rs("since").value)%> - <%=dateToStr(rs("till").value)%></td><td class="digit"><%=rs("kol").value%></td><td class="digit"><%=rs("priceval").value%></td><%
%></tr><%
      rs.MoveNext();
    };
%>
</tbody>
</table>
</div>

<div id="recast">
<h2>Переработка</h2>
<table>
<table name="trecast" id="trecast" class="grid" width="100%">
<colgroup>
<col class="string" width="25%"/>
<col class="string" width="25%"/>
<col class="string" width="20%"/>
<col class="digit" width="10%"/>
<col class="digit" width="10%"/>
<col class="digit" width="10%"/>
</colgroup>
<thead>
<tr>
<th>Завод</th>
<th>Предприятие</th>
<th>Культура</th>
<th>Цена 1</th>
<th>Цена 2</th>
<th>Количество</th>
</tr>
</thead>
<tbody>
<%
    rs=rs.NextRecordset;
    while (!rs.eof) 
    {
%><tr><td><%=rs("portname").value%></td><td><%=rs("tradername").value%></td><td><%=rs("culturename").value%></td><td class="digit"><%=rs("price1").value%></td><td class="digit"><%=rs("price2").value%></td>
<td class="digit"><%=rs("amount").value%></td><%
%></tr><%
      rs.MoveNext();
    };
%>
</tbody>
</table>
</div>

</div>
<form id="dt" action="pricesapply.asp" method="POST">
<fieldset>
Применить с:&nbsp;
<input type="Text" id="dtm" name="dtm" maxlength="25" size="25" value="<%=(since) %>"/>
<img src="images2/cal.gif" onclick="javascript:NewCssCal('dtm','ddMMyyyy','dropdown',true,'24')" style="cursor:pointer"/>
<br>
<input type="submit" value="утвердить" class="big_button" />

</fieldset>

</form>
</div> <!--end container-->
<%
  } catch(e) {
    Response.Write(e.message+'; Ошибка выполнения запроса ');
  }
%>
</BODY>
</HTML>
