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
<script language="JavaScript">
function getreport()
{
since=document.getElementById('since').value;
till=document.getElementById('till').value;
cmd="cassa.asp?since="+since+"&till="+till;
window.open(cmd,'_self')
};
</script>
</HEAD>
<BODY>
<% 
WriteHeader(); 
var since = Session.Contents('since');
var till = Session.Contents('till');
if (since=="NaN") 
  since = new Date();
if (till=="NaN") till = new Date().setDate(31);
%>
	<div id="container">
		<div id="inner">
<h1>Касса</h1>
<form name="criteria" action="javascript:getreport()" method="POST">
<fieldset>
с&nbsp;<input class="date" type="text" id="since"  value="<%=dateToStr(since) %>"> 
по&nbsp;<input class="date" type="text" id="till"  value="<%=dateToStr(till) %>">
<input name="go" type="submit" value="выполнить" class="button1" />
</fieldset>
</form>
		</div>
	</div> <!--end container-->
</BODY>
</HTML>
