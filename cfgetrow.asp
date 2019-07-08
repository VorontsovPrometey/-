<%@ LANGUAGE="JScript" CODEPAGE="1251" %>
<% 
Response.Expires = -1 
Session.Timeout = 480
%>
<!--  #include file="connstr.inc" -->
<%
function addDays(date, days) {
  var result = new Date(date);
  result.setDate(result.getDate() + days);
  return result;
}

function parseYMD (str) {
        // validate year as 4 digits, month as 01-12, and day as 01-31 
        if ((str = str.match (/^(\d{4})(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])$/))) {
           // make a date
           str[0] = new Date (+str[1], +str[2] - 1, +str[3]);
           // check if month stayed the same (ie that day number is valid)
           if (str[0].getMonth () === +str[2] - 1)
              return str[0];
        }
        return undefined;
}

var s=''+Request.ServerVariables('Request_Method');
var dt="";
var plan="";
var since=new Date();
var till=new Date();

if (s.indexOf('POST')>=0) {
  dt=(Request.Form("id")!='undefined')?unescape(Request.Form("id")):null;
  plan=(Request.Form("plan")!='undefined')?unescape(Request.Form("plan")):null;
  since=(""+Request.Form("since"));
  till=(""+Request.Form("till"));
} else {
  plan=unescape(Request.QueryString("plan"));
  dt=unescape(Request.QueryString("id"));
  since=""+Request.QueryString("since");
  till=""+Request.QueryString("till");
}
if ((plan=="undefined")||(dt=="undefined")) {
  Response.AddHeader("Error-Message","Bad parameters");
} else {
try {
  plan = plan.replace(/,/g,"").replace(" ","");
  var sql="exec cfgetrow "+dt+","+plan+",'"+since+"','"+till+"'";
//Response.Write(sql);
 var conn=getConnection(false);
  conn.CommandTimeout=160;
  var rs=conn.Execute(sql);
  var str="";
  var i=0;
  var begin = parseYMD(since);
  while (rs) {
    if (!rs.eof) {
      var dt = addDays(begin,i);
      var d = dateToSQL(dt);
      str+="|"+d.substr(0,4)+'-'+d.substr(4,2)+'-'+d.substr(6,2);
      var st = ""+rs(0).value;
      if (st=='null') st="";
      str += "="+st;
    };
    i++;
    rs=rs.NextRecordset;
  }
  if (str.length>0) str=str.substr(1);
  Response.Write(str);
} catch(e) {
  Response.AddHeader("Content-Type", "text/plain; charset=windows-1251")
  Response.AddHeader("Error-Message","Ошибка выполнения запроса");
  Response.Write(e.message);
}
}
%>