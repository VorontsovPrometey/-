<%@ LANGUAGE="JScript" CODEPAGE=1251 %>
<% Response.Expires = 0 %>
<!--  #include file="connstr.inc" -->
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<% WriteStyle(); %>
</HEAD>
<body>
<% WriteHeader(); %>
	<div id="container">
<% WriteMenu('login'); %>
		<form name="login" action="index.asp" method=POST>
			<fieldset id="user">
				<legend>Регистрация</legend>
				<label for="UID">псевдоним:</label>
				<input type="Text" name="UID" tabindex="1" maxlength="20" />
				<br>
				<label for="PWD">пароль:</label>
				<input type="password" name="PWD" tabindex="2" maxlength="20">
			</fieldset>
			<p>
			<INPUT TYPE=submit id="button1" class="button1" value="login">
			</p>
		</form>
	</div>
<% WriteFooter(); %>
</body>
</html>
