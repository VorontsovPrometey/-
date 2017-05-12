<SCRIPT LANGUAGE=JScript RUNAT=Server>
function ConStr() { 
  if ((Session.Contents('UserId')=='')||(Session.Contents('Password')=='')) {
     if (''+Request.Form("UID")!='undefined') {
       var s=''+Request.Form("UID");
       Session.Contents("UserId")=s;

       if (''+Request.Form("PWD")!='undefined') {
         var s=''+Request.Form("PWD");
         if (s!='') 
           Session.Contents("Password")=s;
       }
       if (''+Request.Form("ECS")!='undefined') {
         s=''+Request.Form("ECS");
       if (s!='') {
         s=s.substr(22);
         s=s.substring(0, s.length-9);
         var enc='';
         for (i=0;i<s.length;i++) {
           var d=s.charCodeAt(i);
           d=d ^ 123;
           enc+=String.fromCharCode(d);
         }
         Session.Contents("Password")=(enc);
       }
       }
    }
  }
  if ((Session.Contents("UserId")=="")||(Session.Contents("Password")==""))
    return ''
  return Session.Contents("ConStr")+Session.Contents("Database")+";Password="+
         Session.Contents("Password")+
         ";User ID="+Session.Contents("UserId")
}
function getConnection(newconnection) 
{ 
oConn=Session.Contents("Connection");
if ((newconnection)&(oConn.State>0))
  oConn.Close();
if (oConn.State==0)
{
  var s=ConStr();
  if (s!='')
  {
    try {
      oConn.Open(s);
    } catch (e) {
    sayerror('',e)
  }
}
}
return oConn;
}
function sayerror(msg, e)
{
Response.Write('<div class=error>'+msg+'</div>')
if (e!=null)
  Response.Write('<div class=error>'+e.message+'</div>')
}
function zamena(stf,old,rplc) {
var New='';
while (stf.indexOf(old)!=-1) {
var strt=stf.indexOf(old);
New+=stf.substring(0,strt);
New+=rplc;
stf=stf.substring(strt+old.length,stf.length);
} return New+stf;
}
function dateFormat(ds,type) {
 if (ds==null) {return ds}
 else {
 dt=new Date(Date.parse(ds));
 m=dt.getMonth()+1;
 if (m<10) {m='0'+m} else {m=''+m};
 d=dt.getDate();
 if (d<10) {d='0'+d} else {d=''+d};
 if (type==999135)
   return dt.getFullYear()+'.'+m+'.'+d+' '+dt.getHours()+':'+dt.getMinutes()+':'+dt.getSeconds()//+'.'+dt.getMilliseconds()
 else
   return d+'.'+m+'.'+dt.getFullYear()
 }
}
function dateToANSI(dt) {
// dd.mm.yyyy -> yyyymmdd
  return dt.substr(6,4)+dt.substr(3,2)+dt.substr(0,2)
}
function fieldStr(fld) {
var t=fld.Type;
return ((((t==7)||(t==135)||(t==133))?dateFormat(fld.Value,t):((fld.Value==null?'-':(zamena(''+fld.Value,"'",""))))))
}
function translate(lex){
  switch (lex) {
   case 'comment': return 'комментарий';
   case 'contragent': return 'контрагент';
   case 'credit': return 'кредит';
   case 'currencyname': return 'валюта';
   case 'currentprice': return 'учетная цена';
   case 'debet': return 'дебет';
   case 'divisname': return 'подразделение';
   case 'docdate': return 'дата';
   case 'dt': return 'дата';
   case 'id': return 'код';
   case 'kind': return 'тип';
   case 'name': return 'название';
   case 'oper': return 'операция';
   case 'opername': return 'операция';
   case 'originalnum': return 'номер';
   case 'price': return 'цена';
   case 'qsaldo': return 'остаток,количество';
   case 'quantity': return 'количество';
   case 'sk': return 'остаток,сумма';
   case 'sn': return 'остаток,сумма';
   case 'ssaldo': return 'остаток,сумма';
   case 'summa': return 'сумма';
   case 'typename': return 'тип документа';
  }
  return lex;
}

function printTable(oRs,link,cmd,list) {
if (cmd==null) cmd='exec';
if (oRs.State!=0) {
Response.write('<table class="sort-table" cellspacing="1" cellpadding="1">')
var wrap=(cmd=='sel')?' nowrap':'';
Response.write('<thead>')
var rec=0;
if ((list==null)||(list=='')) {
  list = [];
  for(i=0;i<oRs.fields.count;i++) {
    var f = oRs(i);
    if (f.Type!=72)
      list[list.length]=f.Name;
  }
}
if ((link!=null)&&(oRs(link)==null)) link=null;
for(i=0;i<list.length;i++) {
    var f = oRs(list[i]);
    if (f!=null) {
//      if (f.Name==link) rec=i;
      Response.write('<td><span id="t_info_'+i+'">'+translate(f.Name)+'</span></td>');
    } //else Response.write('<td>'+translate(list[i])+'</td>');
  }

Response.write('</thead><tbody>')
while (!oRs.eof) 
{
   rec++;
   Response.write('<tr valign="top" '+(rec % 2 ==0?'class="odd"':'')+'>');
   if (link!=null) Response.Write('<span id="r'+oRs(link)+'">');
   for(j=0;j<list.length; j++) {
     var f = oRs(list[j]);
     if (f!=null)
     {
     t=f.Type;
     Response.write('<td')
     if ((t==20)||(t==6)||(t==14)||(t==5)||(t==3)||(t==131)||(t==4)||(t==2)||(t==16))
       Response.write(' align=right nowrap')
     else
       Response.write(wrap);
     Response.write('>')
     if ((link!=null)&&(f.Name==link))
       Response.write('<a href=javascript:'+cmd+'("'+f.value+'")>');
     Response.write(fieldStr(f));
     if ((link!=null)&&(f.Name==link))
       Response.write('</a>')
     Response.write('</td>')
     }
   }
   if (link!='') Response.write('</span>')
   oRs.MoveNext();
   i++;
} 
Response.write('</table>')
}
}

function BuildMenu(url) {
var result='';
if (url!='default') {result+='<li><a href="default.asp">Главная</a>'};
//if (Session.Contents("Isboss")==true) 
s=(''+Session.Contents("Password"));
if (s!='') { 
  result+='<li><a href="logout.asp">Выйти</a>';
  if (url=='default') {result+='<li><a href="newpwd.asp">Сменить пароль</a>';};
  if (Session.Contents("Isboss")==true) 
  { result+='<li><a href="delta2.asp" target="_blank">Дельта</a>';
    result+='<li><a href="costincom.asp" target="_blank">Доходы и расходы</a>';
//    result+='<li><a href="auto3.asp"  target="_blank">Содержание авто</a>';
    result+='<li><a href="repContractAvg.asp" target="_blank">Средние цены по валютным контрактам</a>';
    result+='<li><a href="repContractQuota.asp" target="_blank">Квоты</a>';
    result+='<li><a href="cassaget.asp" target="_blank">Касса</a>';
  };
  if ((Session.Contents("Isboss")==true)||(Session.Contents("Ismanager")==true)) {
    result+='<li><a href="conman.asp" target="_blank">Поставки на контракты</a>';
  }
  if ((Session.Contents("Isboss")==true)||(Session.Contents("Islogist")==true)||(Session.Contents("Ismanager")==true)) {
    result+='<li><a href="elev.asp" target="_blank">Остатки на элеваторах</a>';
    result+='<li><a href="elevin.asp" target="_blank">Поступления на элеваторы (нал/безнал)</a>';
  }
  if ((Session.Contents("Islogist")==true)) {
    result+='<li><a href="repContractQuota.asp" target="_blank">Квоты</a>';
  }
  if (Session.Contents("Ismanager")==true) 
  { 
    result+='<li><a href="repContractQuota.asp" target="_blank">Квоты</a>';
    result+='<li><a href="naklinget.asp" target="_blank">Приходные накладные</a>';
    result+='<li><a href="bankinget.asp" target="_blank">Поступление на счет</a>';
    result+='<li><a href="bankoutget.asp" target="_blank">Оплата со счета</a>';
    result+='<li><a href="acc71get.asp" target="_blank">Подотчетники</a>';
  };
  if ((Session.Contents("Isboss")==true)||(Session.Contents("Ismanager")==true)||(Session.Contents("Isbuch")==true)||(Session.Contents("Isbank")==true)||(Session.Contents("Islogist")==true)) 
  {
    result+='<li><a href="prices.asp" target="_blank">Закупочные цены</a><li><a href="pricesarc.asp" target="_blank">Архив закупочных цен</a>';
  };
  if (Session.Contents("Ispricer")==true) 
    result+='<li><a href="pricesdraft.asp" target="_blank">Проект закупочных цен</a>';
//  if (Session.Contents("Isforeigner")==true) {result+='<li><a href="divrep.asp">Отчет</a>';};
} else { 
//  result+='<li><a href="newuser.asp">New user</a>'; 
 if (url=='default') {result+='<li><a href="login.asp">Регистрация</a>'};
};
//if (url=='default') {result+='<li><a href="default.asp?style=alt">Другой стиль</a>'};
return result;
}

function WriteStyle() {
Response.write('<link rel="stylesheet" href="'+Session.Contents("Style")+'" type="text/css" title="default" id="default">');
};

function WriteMenu(url) {
Response.write('<div id="menu"><ul>'+BuildMenu(url)+'</ul></div>');
};

function WriteFooter() {
Response.write('<div id="footer"><a href="default.asp">&copy; Прометей.</a></div>');
};
function WriteHeader() {
//Response.write('<div id="header"><img src="images/fnslogo.gif" /></div>');
Response.write('<div id="header"><p class="logo">'+((""+Session.Contents("Database")=="fa")?'Прометей':"Производственная компания")+'</p> <p class="slogan"></p></div>');
};
function trySession()
{
  if (Session.Contents('UserId')==null)
  {
    Response.Redirect("login.asp");
  };
}

function isMSIE () {
   var ua = (''+Request.ServerVariables('HTTP_USER_AGENT')).toLowerCase(); 
   // browser name
   return ( (ua.indexOf('msie') != -1) && (ua.indexOf('opera') == -1) && (ua.indexOf('webtv') == -1) );
};
function addCommas(nStr)
{
	nStr += '';
	x = nStr.split('.');
	x1 = x[0];
	x2 = x.length > 1 ? '.' + x[1] : '';
	var rgx = /(\d+)(\d{3})/;
	while (rgx.test(x1)) {
		x1 = x1.replace(rgx, '$1' + ',' + '$2');
	}
	return x1 + x2;
}

function Cash(money) {
money=Math.round(money*100).toString();
if (money<10) return '0.0'+money;
return (money<100)?'0.'+money:''+money.substring(0,money.length-2)+'.'+money.substring(money.length-2,money.length);
}
function cash(money) {
if (isNaN(money)) money = 0;
return addCommas( (money<0)?'-'+Cash(money*-1):Cash(money) );
}
function cash2(money) {
if (isNaN(money)) money = 0;
return (money<0)?'-'+Cash(money*-1):Cash(money) ;
}
function dateToSQL(ds) {
  dt=new Date(Date.parse(ds));
  month=dt.getMonth()+1;
  smonth=(month<10?'0'+month:''+month);
  day=dt.getDate();
  sday=(day<10?'0'+day:''+day);
  return dt.getFullYear()+smonth+sday;
}
function dateToStr(ds) {
  dt=new Date(ds);//new Date(Date.parse(ds));
  month=dt.getMonth()+1;
  smonth=(month<10?'0'+month:''+month);
  day=dt.getDate();
  sday=(day<10?'0'+day:''+day);
  return sday+'.'+smonth+'.'+dt.getFullYear();
}
function dateTimeToStr(ds) {
  dt=new Date(ds);//new Date(Date.parse(ds));
  month=dt.getMonth()+1;
  smonth=(month<10?'0'+month:''+month);
  day=dt.getDate();
  sday=(day<10?'0'+day:''+day);
  return sday+'.'+smonth+'.'+dt.getFullYear()+' '+dt.getHours()+':'+dt.getMinutes()+':'+dt.getSeconds();
}
function parseDate(value) {
	// parse date 24.12.2009
	var tmp = value.split(".");
	var dt=new Date();
	dt.setFullYear(tmp[2]);
	dt.setDate(1);
	dt.setMonth(tmp[1]-1);
	dt.setDate(tmp[0]);
	return dt;
}
function getRS(id){
var rs = Session.Contents('rs_'+id);
if (rs==null) 
{
  var conn=getConnection();
  conn.CommandTimeout = 0;
  rs=conn.Execute(id);
  Session.Contents('rs_'+id)=rs;
};
return rs;
};
function getAcc() {return getRS('select acc,name from ownacc order by acc');};
function getAnal() {return getRS('select * from anal order by anal');};
function getDivis() {return getRS('select * from ownfirm order by id');};
</SCRIPT>
