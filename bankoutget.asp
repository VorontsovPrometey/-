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
divis=document.getElementById('divis').value;
//cmd="bankout.asp?since="+since+"&till="+till+"&divis="+divis;
cmd="tbl.asp?query=repBankout&pmode=2&since="+since+"&till="+till+"&divis="+divis;
window.open(cmd,'_self')
};
</script>
</HEAD>
<BODY>
<% WriteHeader(); %>
	<div id="container">
		<div id="inner">
<h1>Оплата со счета</h1>
<form name="criteria" action="javascript:getreport()" method="POST">
<fieldset>
с&nbsp;<input class="date" type=Text id="since"  value="<%=dateToStr(Session.Contents('since')) %>"> 
по&nbsp;<input class="date" type=Text id="till"  value="<%=dateToStr(Session.Contents('till')) %>">
<br/>Подразделение:<br/><select id="divis"><option value="null">все</option>
<%
var acc=getDivis();
acc.MoveFirst();
while (!acc.eof)
{
  %><option value="<%=1*acc(0)%>"><%=''+acc(1)%></option>
  <%
  acc.MoveNext();
}
%>
</select>

<input name="go" type="submit" value="выполнить" class="button1" />
</fieldset>
</form>
		</div>
	</div> <!--end container-->
</BODY>
</HTML>
