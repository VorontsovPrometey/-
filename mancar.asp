<%@ LANGUAGE="JScript" CODEPAGE="1251" %>
<% 
Response.Expires = -1 
Session.Timeout = 600
Server.ScriptTimeOut = 600 
%>
<!--  #include file="connstr.inc" -->
<%
var conn=null;
var sql="exec graingreen..rep_mancar";
  try {
    conn=getConnection(false);
    conn.CommandTimeout=600;
    var rs=conn.Execute(sql);
%>
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<%
WriteStyle(); 
%>
<style>
#manager {width: 45%; float:left;}
#car {width: 45%; float: right;}
</style>
</HEAD>
<BODY>
<% WriteHeader(); %>
<div id="container">

<div id="manager">
<h2>Менеджеры</h2>
<table>
<table name="tmanager" id="tmanager" class="grid" width="100%">
<colgroup>
<col class="string" width="15%"/>
<col class="string" width="15%"/>
<col class="string" width="15%"/>
<col class="string" width="30%"/>
<col class="string" width="25%"/>
</colgroup>
<thead>
<tr>
<th>Фамилия</th>
<th>Куда уехал</th>
<th>Кем направлен</th>
<th>Цель командировки</th>
<th>Командирован с - по</th>
</tr>
</thead>
<tbody>
<%
    while (!rs.eof) 
    {
%><tr><td><%=rs("managername").value%></td><td><%=rs("pointname").value%></td><td><%=rs("sendername").value%></td><td><%=rs("comment").value%></td>
<td><%=dateToStr(rs("since").value)%> - <%=dateToStr(rs("till").value)%></td>
</tr><%
      rs.MoveNext();
    };
%>
</tbody>
</table>
</div>

<div id="car">
<h2>В какой район необходима машина</h2>
<table>
<table name="tcar" id="tcar" class="grid" width="100%">
<colgroup>
<col class="string" width="30%"/>
<col class="string" width="30%"/>
<col class="digit" width="20%"/>
<col class="digit" width="20%"/>
</colgroup>
<thead>
<tr>
<th>Откуда</th>
<th>Куда</th>
<th>Километраж</th>
<th>Стоимость</th>
</tr>
</thead>
<tbody>
<%
    rs=rs.NextRecordset;
    while (!rs.eof) 
    {
%><tr><td><%=rs("departurename").value%></td><td><%=rs("arrivalname").value%></td><td class="digit"><%=rs("path").value%></td><td class="digit"><%=rs("cost").value%></td><%
%></tr><%
      rs.MoveNext();
    };
%>
</tbody>
</table>
</div>

</div> <!--end container-->
<%
  } catch(e) {
    Response.Write(e.message+'; Ошибка выполнения запроса ');
  }
%>
</BODY>
</HTML>
</script>
