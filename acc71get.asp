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
//cmd="osv.asp?acc=71&a1=5&a2=6&h1='Подотчетники'&mode=1&since="+since+"&till="+till;
cmd="tbl.asp?query=repOwn71&pmode=2&since="+since+"&till="+till;
window.open(cmd,'_self')
};
</script>
</HEAD>
<BODY>
<% WriteHeader(); %>
	<div id="container">
		<div id="inner">
<h1>Подотчетники</h1>
<form name="criteria" action="javascript:getreport()" method="POST">
<fieldset>
с&nbsp;<input class="date" type=Text id="since"  value="<%=dateToStr(Session.Contents('since')) %>"> 
по&nbsp;<input class="date" type=Text id="till"  value="<%=dateToStr(Session.Contents('till')) %>">

<input name="go" type="submit" value="выполнить" class="button1" />
</fieldset>
</form>
		</div>
	</div> <!--end container-->
</BODY>
</HTML>
