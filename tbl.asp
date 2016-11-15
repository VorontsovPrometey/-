<%@ LANGUAGE="JScript" CODEPAGE="1251" %>
<% Response.Expires = -1 
Server.ScriptTimeOut
%>
<!--  #include file="connstr.inc" -->
<!--  #include file="table.inc" -->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
<%
WriteStyle(); 
%>
<title>Таблица</title>
</head>
<body>
<% WriteHeader(); %>
	<div id="container">
<%
var s=''+Request.ServerVariables('Request_Method');
var since;
var till;
var divis;
var doctype;
var pmode=1;
if (s.indexOf('POST')>=0) {
  sql=unescape(Request.Form("query"))
  sh=(Request.Form("sh")!='undefined')?unescape(Request.Form("sh")):null;
  since=(Request.Form("since")!='undefined')?unescape(Request.Form("since")):null;
  till=(Request.Form("till")!='undefined')?unescape(Request.Form("till")):null;
  divis=(Request.Form("divis")!='undefined')?unescape(Request.Form("divis")):null;
  doctype=(Request.Form("doctype")!='undefined')?unescape(Request.Form("doctype")):null;
  pmode=(Request.Form("pmode")!='undefined')?unescape(Request.Form("pmode")):pmode;
} else {
  sql=unescape(Request.QueryString("query"));
  sh=(Request.QueryString("sh")!='undefined')?unescape(Request.QueryString("sh")):null;
  since=(Request.QueryString("since")!='undefined')?unescape(Request.QueryString("since")):null;
  till=(Request.QueryString("till")!='undefined')?unescape(Request.QueryString("till")):null;
  divis=(Request.QueryString("divis")!='undefined')?unescape(Request.QueryString("divis")):null;
  doctype=(Request.QueryString("doctype")!='undefined')?unescape(Request.QueryString("doctype")):null;
  pmode=(Request.QueryString("pmode")!='undefined')?unescape(Request.QueryString("pmode")):pmode;
  parm=(Request.QueryString("parm")!='undefined')?unescape(Request.QueryString("parm")):'';
}
if (since!=null) {
  Session.Contents('since')=new Date(parseDate(since));
  since="'"+since+"'";
} else since="null";
if (till!=null) {
  Session.Contents('till')=new Date(parseDate(till));
  till="'"+till+"'";
} else till="null";
if (divis!='null') {
  divis="'"+divis+"'";
} else divis="null";
if (doctype==null)
  doctype="null";
if (pmode=='undefined') pmode=1;
//if (parm!='') {Response.Write(parm);}
var list = null;
var link=null;
var cmd=null;
if (sql=='repOwn71') {sql="exec "+sql+" "+since+","+till; list=["oper","originalnum","docdate","currencyname","sn","debet","credit","sk"];}
if (sql=='repNaklin') {sql="exec "+sql+" "+since+","+till+","+divis;}
if (sql=='repBankin') {sql="exec "+sql+" "+since+","+till+","+divis;}
if (sql=='repBankout') {sql="exec "+sql+" "+since+","+till+","+divis;}
if (sql=='docList') {
  var where = "'where d.docdate between '"+since+"' and '"+till+"'";
  if (divis!="null")
    where+=" and d.divis=''"+divis+"''";
  where = where + "'";
  if (doctype==6) list=["id","divisname","opername","docdate","ТТН","номер автомобиля","товар (услуга)","поставщик","договор с поставщиком","количество отгруженн","количество полученно","% влаги","% сора","количество","цена","цена индикативная","менеджер"];
  sql="exec "+sql+" "+doctype+",1000,"+where;
}
var conn=getConnection();
if (pmode==1) //(list==null)
  Response.Write(execute(conn,sql,null));
else {
var conn=getConnection();
try {
  rs = conn.Execute(sql);
  printTable(rs,link,cmd,list);
  }
  catch(e) {
     sayerror('Error',e);
  }
}
%>
	</div>
</body>
</html>