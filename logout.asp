<%@ LANGUAGE="JScript" CODEPAGE=1251 %>
<!--  #include file="connstr.inc" -->
<% Session.Abandon %>
<%
Session.Contents("UserName")='';
Session.Contents("Password")='';
var conn=getConnection(false);
try {
if (conn!=null)
  conn.Close();
  } catch(e) {}
%>
<% Response.Redirect("default.asp") %>
