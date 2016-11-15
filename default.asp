<%@ LANGUAGE="JScript" CODEPAGE=1251 %>
<% 
Response.Expires = -1 
Session.Timeout = 480
%>
<!--  #include file="connstr.inc" -->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
<meta name="description" content="Прометей, главная страница">
<meta name="title" content="Прометей">
<title>Prometey</title>
<% 
var s=''+Request.ServerVariables('Request_Method');
if (s.indexOf('POST')<0) {
  style=''+Request.QueryString("style");
  if (style=='alt') {
    var oldstyle=Session.Contents("Style");
    if (oldstyle=='style1.css') {style='style2.css';} else {style='style1.css';};
    Session.Contents("Style")=style;
  }
};
WriteStyle(); 
%>
</head>
<body>
<% WriteHeader(); %>
	<div id="container">
<% WriteMenu('default'); %>
		<div id="inner">
<!--
				<div id="greeting">
					<h1>Address</h1>
					<div class="contacts">
					</div>
					<div class="contacts">
					</div>
				</div>
				<div class="about">
				</div>
-->
		</div>
	</div> <!--end container-->
<% WriteFooter(); %>
</body>
</html>