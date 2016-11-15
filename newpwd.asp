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
<% WriteMenu('newpwd'); %>
		<form name="login" action="chpwd.asp" method=POST>
			<fieldset id="newpassword">
				<legend>Смена пароля</legend>
				<label for="PWD">новый пароль:</label>
				<input type="password" name="PWD" maxlength="20" />
			</fieldset>
			<INPUT TYPE=submit id="button1" class="button1" value="submit">
		</form>
	</div> <!--end container-->
<% WriteFooter(); %>
</BODY>
</HTML>