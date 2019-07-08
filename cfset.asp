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
var val="";
if (s.indexOf('POST')>=0) {
  id=(Request.Form("id")!='undefined')?unescape(Request.Form("id")):null;
  dt=(Request.Form("dt")!='undefined')?unescape(Request.Form("dt")):null;
  val=(Request.Form("val")!='undefined')?unescape(Request.Form("val")):null;
} else {
  id=unescape(Request.QueryString("id"));
  val=unescape(Request.QueryString("val"));
  dt=unescape(Request.QueryString("dt"));
}
if ((id=="undefined")||(val=="undefined")||(dt=="undefined")) {
  Response.AddHeader("Error-Message","Bad parameters");
} else {
try {
  val = val.replace(/,/g,"").replace(" ","");
  if (val=="") val="0";
  var sql="exec cfset "+id+",'"+dt+"',"+val;
  var conn=getConnection(false);
  conn.CommandTimeout=160;
  var rs=conn.Execute(sql);
} catch(e) {
  Response.AddHeader("Content-Type", "text/plain; charset=windows-1251")
  Response.AddHeader("Error-Message",e.message);
}
}
%>