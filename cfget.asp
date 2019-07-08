<%@ LANGUAGE="JScript" CODEPAGE="1251" %>
<% 
Response.Expires = -1 
Session.Timeout = 480
%>
<!--  #include file="connstr.inc" -->
<%
var s=''+Request.ServerVariables('Request_Method');
var id="";
var dt="";
var plan="";
if (s.indexOf('POST')>=0) {
  id=(Request.Form("id")!='undefined')?unescape(Request.Form("id")):null;
  dt=(Request.Form("dt")!='undefined')?unescape(Request.Form("dt")):null;
  plan=(Request.Form("plan")!='undefined')?unescape(Request.Form("plan")):null;
} else {
  id=unescape(Request.QueryString("id"));
  plan=unescape(Request.QueryString("plan"));
  dt=unescape(Request.QueryString("dt"));
}
if ((id=="undefined")||(plan=="undefined")||(dt=="undefined")) {
  Response.AddHeader("Error-Message","Bad parameters");
} else {
try {
  plan = plan.replace(/,/g,"").replace(" ","");
  var sql="exec cfget "+id+",'"+dt+"',"+plan;
  var conn=getConnection(false);
  conn.CommandTimeout=160;
  var rs=conn.Execute(sql);
  if (!rs.eof) {
    var s = ""+rs(0).value;
    if (s=='null') s="";
    Response.Write(s);
  };
} catch(e) {
  Response.AddHeader("Content-Type", "text/plain; charset=windows-1251")
  Response.AddHeader("Error-Message",e.message);
  Response.Write(e.message);
}
}
%>