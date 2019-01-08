<%@ LANGUAGE="JScript" CODEPAGE="1251" %>
<% 
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
%>
<style>
}</style>

<script>
"use strict";
let heute="<%  
var now = dateToStr(new Date());
Response.Write(now.substr(6,4)+"-"+now.substr(3,2)+"-"+now.substr(0,2)) %>";
</script>

</HEAD>
<BODY>
<% WriteHeader(); %>
	<div id="container">
<h1>Товарные остатки</h1>
<form name="criteria" action="sbd.asp" method="POST">
<fieldset>
с&nbsp;<input class="date" type=Text id="since"  value="<%=dateToStr(Session.Contents('since')) %>"> 
по&nbsp;<input class="date" type=Text id="till"  value="<%=dateToStr(Session.Contents('till')) %>">
<input name="go" type="submit" value="выполнить" class="button1" />
</fieldset>
</form>
<table class="zui-table" id="thetable">
<thead>
<tr>
<th>Культура</th>
<th>Показатель</th>
<%
var s=''+Request.ServerVariables('Request_Method');
var since=new Date();
if ((s.indexOf('POST')>=0)&&(''+Request.Form("since")!='undefined')) {
  since=parseDate(""+Request.Form("since"));
} else {
  since=new Date((Session.Contents('since')));
}
var till=new Date();
if ((s.indexOf('POST')>=0)&&(''+Request.Form("till")!='undefined')) {
  till=parseDate(""+Request.Form("till"));
} else {
  till=new Date((Session.Contents('till')));
}
var dates = new Array();

try {
  var sql="exec repStoreByDays '"+dateToSQL(since)+"','"+dateToSQL(till)+"'";
  var conn=getConnection(false);
  conn.CommandTimeout=160;
  var rs=conn.Execute(sql);
  while (!rs.eof) {
     dates.push({dt: ""+rs('dt').value});
     rs.MoveNext();
  };
for (var i=0;i<dates.length;i++) {
%><th><%=dates[i].dt%></th>
<%};%>
</tr>
</thead>
<tbody>
<%
  var vals = {};
  var name="";
  rs=rs.NextRecordset;
  var oldgoods=null;
  while (!rs.eof) {
    var goods=rs('goods').value;
    var dt=""+rs('dt').value;
    name=""+rs('name').value;
    if ((oldgoods)&&(oldgoods!=goods)) {
%>
<tr><td><b><%=name%></b></td><td>остаток<br/><i>изменение</i></td>
<%   
     var q=0;
     for (var i=0;i<dates.length;i++) {
%><td class="number"><%
       var v = vals[dates[i].dt];
       if (!v) v=0.0;
       q+=v;
%><%=q%><br/><i><%=v%></i><%
%></td><%
    };
    vals = {};
%></tr><%
    };
    oldgoods = goods;
    vals[dt] = 1.0*+rs('skk').value;
    rs.MoveNext();
  };
%>
<tr><td><b><%=name%></b></td><td>остаток<br/><i>изменение</i></td>
<%   
     var q=0;
     for (var i=0;i<dates.length;i++) {
%><td class="number"><%
       var v = 1.0*vals[dates[i]];
       if (!v) v=0.0;
       q+=v;
%><%=q%><br/><i><%=v%></i><%
%></td><%
     }
} catch(e) {
   sayerror("",e);
}
%>
</tr>
</tbody>
<tfoot>
</tfoot>
</table>
	</div> <!--end container-->
</BODY>
</HTML>
