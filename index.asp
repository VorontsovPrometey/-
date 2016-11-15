<%@ LANGUAGE="JScript" CODEPAGE=1251 %>
<% Response.Expires = 0 %>
<!--  #include file="connstr.inc" -->
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
<% WriteStyle(); %>
</HEAD>
<BODY>
<% 
var m=''+Request.ServerVariables('Request_Method');
if (m.indexOf('GET')>=0)
{
  var s=''+Request.QueryString("pwd");
  Session.Contents("Password")=s;
  s=''+Request.QueryString("uid");
  Session.Contents("UserId")=s;
//  s=''+Request.QueryString("db");
  Session.Contents("Database")="fa";
  Session.Contents('UserName')='';
  Session.Contents('UserDivis')='';
  Session.Contents('UserLocationName')='';
//  Session.Contents("FastCanal")=((''+Request.Query("fast"))=="1");
} 
else
{
if ((Request.Form.Count==0)||(Request.Form("UID")=='')||(Request.Form("UID")=='undefined'))
{
  Response.Redirect("default.asp");
} else 
{
if (Request.Form("UID")!='') {
  var s=''+Request.Form("PWD");
  Session.Contents("Password")=s;
  s=''+Request.Form("UID");
  Session.Contents("UserId")=s;
//  s=''+Request.Form("db");
  Session.Contents("Database")="fa";
  Session.Contents('UserName')='';
  Session.Contents('UserDivis')='';
  Session.Contents('UserLocationName')='';
  Session.Contents("FastCanal")=((''+Request.Form("fast"))=="1");
}
}
}
var conn=getConnection(true);
var oRs;
if ((conn==null)||(conn.State==0))
  sayerror('Connection not established',null)
else
{
if (!((conn==null)||(conn.State==0))) {
  try {
    oRs = conn.Execute("select * from dbo.userRoles('"+Session.Contents("UserId")+"')");
    while (!oRs.eof) {
      s=''+oRs(0);
      Session.Contents('Is'+s)=true;
      oRs.MoveNext;
    };
  }
  catch(e) {
     sayerror('Error getting user permissions',e);
  }
}
//  if (Session.Contents('Isboss')==true) 
  {Response.Redirect("default.asp");};
}

%>
<% WriteHeader(); %>
	<div id="container">
<% WriteMenu('index'); %>
	</div> <!--end container-->
<% WriteFooter(); %>
</body>
</html>