<%@ LANGUAGE="JScript" CODEPAGE="1251" %>
<% 
Response.Expires = -1 
Session.Timeout = 480
%>
<!--  #include file="connstr.inc" -->
<%
var s=''+Request.ServerVariables('Request_Method');
var dt="";
var plan="";
if (s.indexOf('POST')>=0) {
  dt=(Request.Form("dt")!='undefined')?unescape(Request.Form("dt")):null;
  plan=(Request.Form("plan")!='undefined')?unescape(Request.Form("plan")):null;
} else {
  plan=unescape(Request.QueryString("plan"));
  dt=unescape(Request.QueryString("dt"));
}
if ((plan=="undefined")||(dt=="undefined")) {
  Response.AddHeader("Error-Message","Bad parameters");
} else {
try {
  plan = plan.replace(/,/g,"").replace(" ","");
  var sql="exec cfgetcol '"+dt+"',"+plan;
  var conn=getConnection(false);
  conn.CommandTimeout=160;
  var rs=conn.Execute(sql);
  var str="";
  var i=1;
  while (rs) {
    while (!rs.eof) {
      if (i % 2) {
        str+="|"+rs(0).value;
      } else {
        var s = ""+rs(0).value;
        if (s=='null') s="";
        str += "="+s;
      }
      rs.MoveNext();
    };
    i++;
    rs=rs.NextRecordset;
  }
  if (str.length>0) str=str.substr(1);
  Response.Write(str);
} catch(e) {
  Response.AddHeader("Content-Type", "text/plain; charset=windows-1251")
  Response.AddHeader("Error-Message","Ошибка выполнения запроса");
  Response.Write(e.message);
}
}
%>