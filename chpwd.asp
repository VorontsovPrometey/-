<%@ LANGUAGE="JScript" CODEPAGE=1251 %>
<% Response.Expires = 0 %>
<!--  #include file="connstr.inc" -->
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
<% WriteStyle(); %>
</HEAD>
<BODY>
<% WriteHeader(); %>
	<div id="container">
<% WriteMenu('chpwd'); %>
<% 
var conn=getConnection();
var s=''+Request.Form("pwd");
if (s=='') {
  sayerror('Пустой пароль недопустим');
} else {
try {
  conn.Execute("EXEC sp_password '"+Session.Contents("Password")+"','"+s+"'");
  Session.Contents("Password")=s;
  Response.Write('Пароль изменен');
}
catch(e) {
   sayerror('Ошибка при смене пароля: ',e);
}
}
%>
	</div>
<% WriteFooter(); %>
</BODY>
</HTML>