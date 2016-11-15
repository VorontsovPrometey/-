<%@ LANGUAGE="JScript" CODEPAGE="1251" %>
<% Response.Expires = -1 %>
<!--  #include file="connstr.inc" -->
<!--  #include file="table.inc" -->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
<% WriteStyle()
%>
<title>Реализация по контрактам</title>

</head>

<body>
<% WriteHeader(); %>
	<div id="container">
		<div id="inner">

<h1>Реализация по контрактам</h1>
<%
var s=''+Request.ServerVariables('Request_Method');
if (s.indexOf('POST')>=0) {
} else {
  since=unescape(Request.QueryString("since"));
  till=unescape(Request.QueryString("till"));
//  divis=unescape(Request.QueryString("divis"));
//  if (divis=='undefined') divis='null';
  Session.Contents('since')=new Date(parseDate(since));
  Session.Contents('till')=new Date(parseDate(till));
}
Response.Write('с '+since+' по '+till);
%><hr/>
<%
var sql="exec repRealizTrader '"+since+"','"+till+"',null";
var conn=getConnection();
Response.Write(execute2(conn,sql,
  new Array(Server.MapPath("repRealizTrader.xsl"))
  ));
%>
		</div>
	</div> <!--end container-->
</body>
</html>