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
<STYLE>
html {
	font-size: 72.5%;
	font-family: verdana;
}
table {
	border-collapse:collapse;
	font-size: 100%;
	font-family: verdana;
}
body {
	background-color: rgb(243, 243, 243);
	margin: 0px;
	padding: 0px;
	height: 100%;
}

.itog {background-color:#FAFAD2;}
.header {background-color:#DCDCDC;}
.plan {color: maroon; background-color:#DCDCDC;}
.fact {color: black; background-color:#DCDCDC;}
.inc {background-color: #E0FFFF;}
.dec {background-color: #FFB6C1;}
.dig {text-align: right;}
.qty {font-style: italic;}

input {width:90px;
  font-size: 100%;
  font-family: verdana;
  vertical-align: top;
}

th:first-child, td:first-child  { 
  width:220px;
  min-width: 220px;
  max-width: 220px;
  word-break: break-all;
}
td input {width:90px;
  font-size: 100%;
  font-family: verdana;
  vertical-align: top;
}
thead tr th:,
tbody tr td:{
  word-break: break-all;
  white-space: nowrap;
  vertical-align: top;
}
</STYLE>

<script>
"use strict";
let btBlue = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAACW0lEQVR42m2TX0hTURzHv+f+2e7uXKMsXRQx2h4iwkClegnCSS8qBSa9BFYICfXQHqopqJWgqx72UmAgmdBLmNAffZpK0EuF+hARgQ5EiqZRYbq/997dzr1nW3dzF77cwznn+zm/3zm/H8H2z0N1EY6dAbg8XnNmM76C1J9ZOnpKFbduJmXjm/Cf6vc2XZBPNNZj3y7JXPj+O43384tYmXuWxPLbu3TqPpVuBRAItjFHS2/n+Y521B9wl+J19ltc3cDziUmkpofGoWYvGSuFLbfEs3fCHdS8Z4eNGkleFoCum/r5N4sJClFeDoTo7D1i5ny4KVbXHZZ9NU6AI0yVADmm2HoCn0ZCSXyZ8xlbQtyV0eGG443gRR7gSSkEpWZoOjRFw8KHeeQed/UQuKqj9r43zfurZUDgmPhyAPLmHKAyffuVRGawbYbAW7ckBEf9bpcdEDkmPg8pj8AwK0wbmxmoka5lgoNHl3DjiV+SRcBOUzDSsEYBFENnAA3IakgnFODBZQpw744iMtsMhwDOANgKkDKAqhfNuQz9p1XgemDGvEQMvRjGoSOAJLAobJYojK9wOjWjYP76Geg918Oe8WRrDKGIDEkEcVCzXcjfhQVg5J5RoacpIEXDDweTeDflKxYSBkbC4ukWOJwii8SWf1KjGLTC6SpSWwqU6DRwu7tYSKxo7dIYBh911radQU0VjcS8C44BaO46BazTi1t7/QrouzqOTLqklP83U2t7v/NaUN57rAFVEm9Ob9Gcf3xcQOJhJImpyYrNtL2daz0B+HysnWOxFazFK7bzP8WO+D+sLvrfAAAAAElFTkSuQmCC';
let btYellow = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAACW0lEQVR42mNkwAQSQJwgwcfkrCjCogASuP/mz4MXn/7tBTIXAPELZMWMaOyycBOuuqJQAy5DC0cGRl5ZsMT/z48Zzp/Yz9C3+sK3lWe+NQGFukDCyAYwcrIyzl+QIRcfFJvNwChpxsDIiOqs/0Dl/5+fYli3eCpDwoxHC7///p8IEoYpK1+ZK9URlFDIwMgjieouFFOA6MtzhnUL+hnCJz+rAIp0gpRKhFtw3V3UHMjFJKrHALaaEclTDDDHQmmgU/69vsQQV7v+28oT35RBSipOtkm3GzoEMzAwMzMwMEHMwHDFf4g3GP4B8d+/DOcPrGUwr3paySghwLT7wVwNFyZRA7BmOGZEcwEM/4UY8u/1BQaF5Bt7GK3U2W/v61RQYeKTA7oAqhlGI4N/CM0g+t+nRwxOFQ/uMFppsN/e3yWhwsAlwsDAAtLMyMDIjOQKmAuAGv+DDPgL5PwB0t/eMDiWvbjDKCEI9MJSaRdGVqBuNlaw7YwsOAz4A3XFr98M/3//YVCIfroHEojTJdoNNNiAGoFcoBkMOAwA2/wbZNB/hgs3fjGYZ76oBEdjhDPX3YUNIlyMbEDrWRmhXkEz4C/MgP8M/3/9ZYhvePNtxV5INIIT0qoO0Y4Ad1EGBg4BiBeQAxIacGAv/PjAsGHna4awitfwhARJyuyM8xe2i8YH+uoyMHLJQw2ASv/7DzHg20OG9ZsvM8RXvl74/SdqUoZnpggfrrriTDkuA2M1BkY2AYgPfn1guHD2FkPv9EffVmzBnpkws7MYs7OSAosCKFXevQ/Mzq/+Ys3OAAw/4oQno+m2AAAAAElFTkSuQmCC';
let btSave = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAACgklEQVR42o3TS0hUURjA8f+dl+NjnEbG9yPMUZOExlVFwYgVQQvLR4hUlFC7VhotisBFT7MoFFpIWhKEkvZYtGrhhD009BbVomIoNQODaNTGcR46fXeui1YyBz7u4d57fufxfUcB7JjMHeQUVklfcRoh3WTEJGE0GjEYFGKrMVZWV/EHAszNTF+Q/56w1hTMll6aulsw5cRftNakUVvmINNhx56ehkmQD3N/CMng0al5rnR0Rph42iy/DulARvEktbeqpAcmA+f3ZVC/2YnDbiPZaiG4HKJ6cJzKNBPFZgtdYxFQ70QYHz4qIwY0QKWhy41F1i5xea+TxopMbKkpRFei+Bf+Utf/ApfNTG66jd6vycgHmOiL8mrwuIJzk8rh226SdODm7iwOVWTF976wGOC3f4Hht18gFGQmambAnyX9VYhEof/kO4XMEpUTPW6sJjSkpsBCaYY1fmjL4bBsIczSUpBAIMjsMvhiGQLICkIC9GhAtkvlVJ8OaKFtxWwAo4RB0Y9asiCizCoRlsHLUT26WwTIFaDtvrsy38brhnIZp7BeWxFsx9BnPs4uwvUjAuSVqpx94PYUb2BkfwmJtOpnPrzf/HCpWYCCMpX2Abdno52RPcWJAc+/450SoL1JgEIBLj50e4oE8BQlBnin8U7Pw7lGDShXuTosQDojOwsSA17+wDuzAGfqBSgS4NojHdienxjwZlYHTtfFgUk6H1dtyU5hdFueVPP6WYhKFnaN/eTTryVoO6gqWKx3BTiGywXJUgOpZj1SzHpdaE3L+ZLcgcBaBKUWfD4BDtzTpnNgSbpBYclWuXpKvHjiRaRdtbXVxP4rJu0ZXYkx43tPONT6D2yQ8LNVoCvdAAAAAElFTkSuQmCC';
var qdates = 7;
var tbl;
var dates = [];
var from;
var sel;
let hcols = 4;
let hrows = 1;
let frows = 1;
let totalscol = 2;
var heute =  1;  // индекс колонки с сегодняшней датой. Делит план и факт
var now = "<%  
var now = dateToStr(new Date());
Response.Write(now.substr(6,4)+"-"+now.substr(3,2)+"-"+now.substr(0,2)) 
var s=''+Request.ServerVariables('Request_Method');
var since=new Date();
if ((s.indexOf('POST')>=0)&&(''+Request.Form("since")!='undefined')) {
  since=parseDate(""+Request.Form("since"));
} else {
  since=new Date((Session.Contents('since')));
}
var till=new Date();
if ((s.indexOf('POST')>=0)&&(''+Request.Form("till")!='undefined')) {
  till=parseDate(""+Request.Form("till"));
  Session.Contents('till')=till;
} else {
  till=new Date((Session.Contents('till')));
}
%>";
var heuts=new Date(now).toISOString().slice(0, 10).replace(/-/g,"");
let since=new Date("<%=since%>").toISOString().slice(0, 10).replace(/-/g,"");
let till=new Date("<%=till%>").toISOString().slice(0, 10).replace(/-/g,"");
<%
var dates = new Array();
var rows = new Array();
var vals = {};
var saldo = {};
try {
  var sql="exec repCFl '"+dateToSQL(since)+"','"+dateToSQL(till)+"'";
  var conn=getConnection(false);
  conn.CommandTimeout=160;
  var rs=conn.Execute(sql);

  while (!rs.eof) {
     dates.push({dt: ""+rs('dt').value});
     rs.MoveNext();
  };
  rs=rs.NextRecordset;
  while (!rs.eof) {
     rows.push({id: ""+rs('id').value, 
	name: ""+rs('name').value, 
	qp: 1*rs('qp').value, 
	qf: 1*rs('qf').value, 
	qr: 1*rs('qr').value,
	prnt: ""+rs('prnt').value,
	inc: 1*rs('inc').value
	});
     rs.MoveNext();
  };
  rs=rs.NextRecordset;
  while (!rs.eof) {
     vals[""+rs('id').value+"."+rs('date').value] = 1.0*rs('value').value;
     rs.MoveNext();
  };
  rs=rs.NextRecordset;
  while (!rs.eof) {
     saldo[""+rs('id').value] = 1.0*rs('value').value;
     rs.MoveNext();
  };
}catch(e) {
   sayerror("",e);
}
%>
var data = [<%
for (var i=0;i<rows.length;i++) {
  var id = rows[i].id;
  if (i>0) {%>,<%};
  if (rows[i].prnt=="null") {
     var rest=1.0;
     if (saldo[id]) {rest=saldo[id];};
%>{i:"<%=id%>", x:0,z:0, n:"<%=rows[i].name%>", a:"<%=1.0*rest%>",  dates:[<%
    for (var d=0;d<dates.length;d++) {
      if (d>0) {%>,<%};
%>{d:"<%=dates[d].dt%>",v:0.0,a:0.0,i:0.0,o:0.0,z:0.0}<%
    };
  } else {
    var inc=0;
%>{i:"<%=id%>", p:"<%=rows[i].prnt%>",qp:"<%=rows[i].qp%>",qf:"<%=rows[i].qf%>", x:0,z:0, n:"<%=rows[i].name%>", s:"<%=rows[i].inc%>",  dates:[<%
    for (var d=0;d<dates.length;d++) {
      if (d>0) {%>,<%};
      var val = 0.0;
      var key = ""+id+"."+dates[d].dt;
      if (vals[key]) {val=vals[key];};
%>{d:"<%=dates[d].dt%>",v:<%=1.0*val%>}<%
    };
  };
  %>]}
<%
}
%>];
var btprev;
var btnext;
// прячем / показываем детальные строки группы
function vis(event) {
  for (var r=hrows; r<tbl.rows.length-frows; r++) {
    var row = tbl.rows[r];
    let parent = row.getAttribute("data-parent");
    if ((parent) && (parent==event.currentTarget.id) ) {
      row.style.display = row.style.display=="none"?"table-row":"none";
    }
  }
}

function colToDate(col) {
  return dates[from+col];
}

function rowId(r) {
  return data[r].i;
}
// визуализация данных
function dmy(s) {
  return s.substr(8,2)+'.'+s.substr(5,2)+'.'+s.substr(0,4);
}

function dataToTable() {
  say("");
  // заголовок
  var row = tbl.rows[0];
  for (var d = 0; d< qdates; d++) {
    var cell = row.cells[d+hcols];
    cell.innerHTML = dmy(dates[from + d]) 
      + "<br/>" 
      + '<image id="cp'+dates[from + d]+'" class="cp" /><image id="cf'+dates[from + d]+'" class="cf" /><image id="cs'+dates[from + d]+'" class="cs" />';
    if (from+d>heute)
      cell.setAttribute("class","plan");
    else
      cell.setAttribute("class","fact");
  }
  // кнопки заголовка
  var buttons = document.getElementsByClassName("cp");
  for (var b = 0; b < buttons.length; b++) {
    buttons[b].src = btBlue;
    buttons[b].onclick=setplancol;
  }
  buttons = document.getElementsByClassName("cf");
  for (var b = 0; b < buttons.length; b++) {
    buttons[b].src = btYellow;
    buttons[b].onclick=setfactcol;
  }
  buttons = document.getElementsByClassName("cs");
  for (var b = 0; b < buttons.length; b++) {
    buttons[b].src = btSave;
    buttons[b].onclick=savecol;
  }
  // нижний заголовок
  row = tbl.rows[tbl.rows.length-1];
  for (var d = 0; d< qdates; d++) {
    var cell = row.cells[d+hcols];
    cell.innerHTML = dmy(dates[from + d]);
    if (from+d>heute)
      cell.setAttribute("class","plan");
    else
      cell.setAttribute("class","fact");
  }
  // строки
  for (var r=hrows; r<tbl.rows.length-frows; r++) {
    var row = tbl.rows[r];
    let dat = data[r-hrows];
    row.cells[1].innerHTML=dat.x;
    row.cells[2].innerHTML=dat.z
    let isitog = row.getAttribute("class")=="itog";
    row.cells[0].innerHTML = (isitog?"":"*") + dat.n;
    for (var d = 0; d < qdates; d++) {
      let hc = dat.dates[from + d];
      if (isitog) {
        row.cells[d+hcols].innerHTML = "" + hc.a + "<br/>+"+ hc.i+ "<br/>-" + hc.o +  "<br/>="+hc.z;
      } else {
        let col = colToDate(d);
        let rid = rowId(r-hrows);
        var btf = "";
        var btp = "";
        if (dat.qp==1) btp = '<image id="p'+rid+"_"+col+'" class="bqp" />';
        if (dat.qf==1) btf = '<image id="f'+rid+"_"+col+'" class="bqf" />';
        row.cells[d+hcols].innerHTML = "<input id='e"+rid+"_"+col+"' type='number' step='any' value='"+hc.v+"'></br>"
           + btp+btf+'<image id="s'+rid+"_"+col+'" class="bs" />';
;
        var ed = document.getElementById("e"+rid+"_"+col);
        ed.onchange=chval;
      }
    }
  }
  btPrev.disabled = (from==0);
  btNext.disabled = (from+qdates == dates.length);
  var buttons = document.getElementsByClassName("bs");
  for (var b = 0; b < buttons.length; b++) {
    buttons[b].src = btSave;
    buttons[b].onclick = save;
  }
  buttons = document.getElementsByClassName("bqp");
  for (var b = 0; b < buttons.length; b++) {
    buttons[b].src = btBlue;
    buttons[b].onclick = setplan;
  }
  buttons = document.getElementsByClassName("bqf");
  for (var b = 0; b < buttons.length; b++) {
    buttons[b].src = btYellow;
    buttons[b].onclick = setfact;
  }
}
// скролл на следующую дату
function nextDate() {
  if (from+qdates < dates.length) {from++;}
  dataToTable();
}
// скролл на предыдущую дату
function prevDate() {
  if (from > 0) {from--;};
  dataToTable();
}
// выбрана дата в списке
function selDate() {
  var ind = sel.selectedIndex;
  if (ind>=0) {
    if (ind+qdates < dates.length)
      from = ind;
    else
      from = dates.length - qdates;
  }
  dataToTable();
}
// пересчет даты в группе
function recalcDate(dt,p) {
//console.log(dt,rid,c,r,p);
  if (p) {
    let c = dateIndexByDate(dt);
    let pind = dataIndexByRID(p);
    var totalinc = 0.0;
    var totaldec = 0.0;
    for (var i = 0; i<data.length;i++) {
      if ((data[i].p)&&(data[i].p == p)) {
        if (data[i].s==1)
          totalinc += Math.round(data[i].dates[c].v )
        else
          totaldec += Math.round(data[i].dates[c].v )
      }
    };
    let pi = dataIndexByRID(p);
    data[pi].dates[c].v = totalinc - totaldec;
    data[pi].dates[c].i = totalinc;
    data[pi].dates[c].o = totaldec;
  }
}
// пересчет всех дат в группе
function recalcDates(p) {
  for (var i=0;i<dates.length;i++)
    recalcDate(dates[i],p);
}
// индекс массива данных с укзанным кодом строки
function dataIndexByRID(rid) {
  for (var i=0; i<data.length; i++) {
    if (data[i].i==rid){
      return i;
    }
  }
  return -1;
}
// индекс массива данных с укзанной датой
function dateIndexByDate(dt) {
  for (var i=0; i<dates.length;i++) {
    if (dates[i]==dt) {
      return i;
    }
  }
  return -1;
}

// пересчет итогов в строке
function recalcRow(rid) {
  let r = dataIndexByRID(rid);
  var totalp = 0.0;
  var totalf = 0.0;
  var row = tbl.rows[r+hrows];
  // после даты "сегодня" - план
  for (var i = heute+1; i<data[r].dates.length;i++)
    totalf += Math.round(data[r].dates[i].v);
  data[r].x = totalf;
  // до даты "сегодня" - факт
  for (var i = 0; i<=heute;i++)
    totalp += Math.round(data[r].dates[i].v);
  data[r].z = totalp;
  // отоги ОСБ
  if (!data[r].p) {
    var saldo = 1.0 * data[r].a;
    for (var i = 0; i<data[r].dates.length;i++) {
      var dtc = data[r].dates[i];
      dtc.a = saldo;
      saldo = saldo + 1.0*dtc.i - 1.0*dtc.o;
      dtc.z = saldo;
    }
  }
}

// введены данные
function chval(event) {
  let a = event.currentTarget.id.substr(1).split("_");
  let val = document.getElementById(event.currentTarget.id).value;
  if (val) {
    // сохраняем в массиве
    let r = dataIndexByRID(a[0]);
    let c = dateIndexByDate(a[1]);
    data[r].dates[c].v = 1.0*val;
    // пересчет итогов
    let p =  data[r].p;
    if (p) {
      recalcDate(a[1],p);
      recalcRow(p);
    }
    recalcRow(a[0]);
    // визуализация
    dataToTable();
  }
}
function chv0(event) {
  let a = event.currentTarget.id.substr(2);
  let val = document.getElementById(event.currentTarget.id).value;
  if (val) {
    // сохраняем в массиве
    let r = dataIndexByRID(a);
    data[r].a = 1.0*val;
    // пересчет итогов
    recalcRow(a);
    // визуализация
    dataToTable();
  }
}
function unicodeToChar(text) {
   if (text)
     return text.replace(/\\u[\dA-F]{4}/gi, 
          function (match) {
               return String.fromCharCode(parseInt(match.replace(/\\u/g, ''), 16));
          })
  else {
   return text;
  }
}
function say(msg) {
  document.getElementById("info").innerHTML=msg;
}
function getTable(storage, table, orderby, f, info, sel, met) {
if (!sel) sel = "sel";
let spr = storage?localStorage[storage]:null;
if ((spr)&&(spr!="undefined")) {if (f) {f(spr,sel);};}
else { // нет, берем с сервера
var xhttp = new XMLHttpRequest();
xhttp.withCredentials = true;
var res = null
let url = table?("/v?table="+table + (orderby?"&orderby="+orderby:"")):orderby;
if (!met) met = "GET";
if (!f) {
  xhttp.responseType = '';
}
xhttp.open(met, url, false);
xhttp.onreadystatechange = 
function() {
  if (this.readyState == this.DONE) {
    info.innerHTML = ((this.status==200)||(this.status==204))?"OK":unicodeToChar(this.getResponseHeader("Error-Message")+this.responseText);
  }
};
xhttp.onerror = 
function(e) {
  var error = unicodeToChar(this.getResponseHeader("Error-Message"));
  error += this.responseText;
  info.innerHTML = error?error:"error";
  info.scrollIntoView();
}

xhttp.onload = function() {
  var error = unicodeToChar(this.getResponseHeader("Error-Message"));
  if (error) {
    error += this.responseText;
    if (info) {info.innerHTML = error?error:"error"; info.scrollIntoView();}
    return;
  } else {
    info.innerHTML = "OK";
  };
  var s = "";
  if (storage) {
    localStorage[storage] = this.responseText;
    s = localStorage[storage];
  } else {s = this.responseText;}
  if (f) {
    res = f(s,sel);
  }
}
xhttp.send();
}
return res;
}
function setplan() {
  say("");
  let inp = document.getElementById("e"+this.id.substr(1));
  if (!inp)  return;
  let a = this.id.substr(1).split("_");
  getTable(null, null, "cfget.asp?id="+a[0]+"&dt="+a[1].replace(/-/g,"")+"&plan=1", toInput, document.getElementById("info"), inp.id, "GET");
}
function setfact() {
  say("");
  let inp = document.getElementById("e"+this.id.substr(1));
  if (!inp)  return;
  let a = this.id.substr(1).split("_");
  getTable(null, null, "cfget.asp?id="+a[0]+"&dt="+a[1].replace(/-/g,"")+"&plan=0", toInput, document.getElementById("info"), inp.id, "GET");
}
function toInput(txt,tel) {
  var inp = document.getElementById(tel);
  if (inp) {
    inp.value=1.0*txt;
    let a = tel.substr(1).split("_");
    let r = dataIndexByRID(a[0]);
    let c = dateIndexByDate(a[1]);
    data[r].dates[c].v = inp.value;
//console.log(inp.value, inp.id);
    recalc(tel);
  }
}

function save() {
  say("");
  let inp = document.getElementById("e"+this.id.substr(1));
  if (!inp)  return;
  let a = this.id.substr(1).split("_");
  let url = "cfset.asp?id="+a[0]+"&dt="+a[1].replace(/-/g,"")+"&val="+inp.value;
  getTable(null, null, url, recalc, document.getElementById("info"), inp.id, "GET");
}

function setplancol() {
  say("");
  getTable(null, null, "cfgetcol.asp?dt="+this.id.substr(2).replace(/-/g,"")+"&plan=1", toCol, document.getElementById("info"), this.id.substr(2), "GET");
}
function setfactcol() {
  say("");
  getTable(null, null, "cfgetcol.asp?dt="+this.id.substr(2).replace(/-/g,"")+"&plan=0", toCol, document.getElementById("info"), this.id.substr(2), "GET");
}

function recalc(tel) {
  let inp = document.getElementById(tel);
  if (inp) {
    let a = inp.id.substr(1).split("_");
    let rid = a[0];
    let colid=a[1];
    recalcRow(rid);
    let c = dateIndexByDate(colid);
    for (var i=0;i<data.length;i++) {
      if (!data[i].p) {
        recalcDate(dates[c],data[i].i);
        recalcRow(data[i].i);
      }
    }
   // визуализация
   dataToTable();
   say("готово");
  }
}

function savecol() {
  let colid=this.id.substr(2);
  let col = dateIndexByDate(colid);
  if (col<0) return;
  for (var r=0; r<data.length; r++) {
    let rid = data[r].i;
    let inp = document.getElementById("e"+rid+"_"+colid);
    if (inp)
      getTable(null, null, "cfset.asp?id="+rid+"&dt="+colid+"&val="+inp.value, recalc, document.getElementById("info"), inp.id, "GET");
  }
}

function toCol(txt,tel) {
  let c = dateIndexByDate(tel);
  let ar=txt.split("|");
  let col = dateIndexByDate(tel);
  if (col<0) return;
  for (var i=0; i<ar.length; i++) {
    var va = ar[i].split("=");
    if (va.length==2) {
      let val = 1.0*va[1];
      let rid = va[0];
      for (var r=0; r<data.length; r++) {
        if (data[r].i==rid) {
          let cd = tel;
          let inp = document.getElementById("e"+ rid +"_" + cd);
          inp.value = val;
          data[r].dates[c].v = val;
          break;
        };
      }; // rid
      recalcRow(rid);
    }
  }
 // итоги
  for (var i=0;i<data.length;i++) {
   if (!data[i].p) {
      recalcDate(dates[c],data[i].i);
      recalcRow(data[i].i);
    }
  }
 // визуализация
  dataToTable();
  say("готово");
}

</script>

</HEAD>
<BODY>
<h1>Денежный поток</h1>
<form name="criteria" action="cf.asp" method="POST">
<fieldset>
с&nbsp;<input class="date" type=Text id="since" name="since"  value="<%=dateToStr(since) %>"> 
по&nbsp;<input class="date" type=Text id="till" name="till"  value="<%=dateToStr(till) %>">
<input name="go" type="submit" value="выполнить" class="button1" />
</fieldset>
</form>
<p>
<BUTTON id="btPrev" onclick="prevDate()"><-</BUTTON>
<select id="seldate"></select>
<BUTTON id="btNext" onclick="nextDate()">-></BUTTON>
Кнопки означают: <image class="bqp"/>рассчитать план <image class="bqf"/>взять факт <image class="bs"/>сохранить 
</p>
<div id="info"></div>
<table id="tbl" cellspacing="0" border="1" cellpadding="2">
<thead><tr class="header"><th>название</th><th>план</th><th>факт</th><th>на начало</th></tr></thead>
<tbody></tbody>
<tfoot><tr class="header"><th>название</th><th>план</th><th>факт</th><th>на начало</th></tr></tfoot>
</table>
</BODY>

<script>
tbl = document.getElementById("tbl");
btNext = document.getElementById("btNext");
btPrev = document.getElementById("btPrev");
since="2099-01-01";
till = "2000-02-05";
// массив дат
if (data.length>0){
  for (var d=0; d<data[0].dates.length; d++) {
    let dt = data[0].dates[d].d;
    if (dt<since) since=dt;
    if (dt>till) till=dt;
    if (dt==now) heute = d;
    dates.push(dt);
  }
}
heuts=new Date(now).toISOString().slice(0, 10).replace(/-/g,"");

if (dates.length<qdates) qdates = dates.length;
from = 0;
// колонки заголовка
var row = tbl.tHead.children[0];
for (var c=0; c<qdates;c++) {
  var th = document.createElement('th');
  row.appendChild(th);
}
// колонки футера
var frow = tbl.tFoot.children[0];
for (var c=0; c<qdates;c++) {
  var th = document.createElement('th');
  frow.appendChild(th);
}
frow.cells[1].innerHTML= "план";
frow.cells[1].setAttribute("class","plan");
frow.cells[2].innerHTML= "факт";
// итоговые колонки
row.cells[1].innerHTML= "план";
row.cells[1].setAttribute("class","plan");
row.cells[2].innerHTML= "факт";

var parent = undefined;
// строки данных
for (var r=0; r<data.length;r++) {
  var row = tbl.insertRow(tbl.rows.length-1);
  row.id = "r"+data[r].i;
  row.setAttribute("lang","en-UK");
  row.setAttribute("dp",".");
  row.setAttribute("align","right");
  if (data[r].s==1) // увеличение
    row.setAttribute("class","inc");
  if (data[r].s==-1) // уменьшение
    row.setAttribute("class","dec");
  if (data[r].p) { // детальная строка
    row.setAttribute("data-parent","r"+data[r].p);
    parent = data[r].p;
  } else { // итоговая строка
    row.onclick = vis;
    row.setAttribute("class","itog");
  }
  // ячейка названия
  var cell = row.insertCell(0);
  cell.innerHTML = data[r].n;
  cell.id="cr"+data[r].i;
  cell.setAttribute("align","left");
  // ячейки итогов
  for (var c=0; c<totalscol;c++) {
    var cell = row.insertCell(row.cells.length);
  }
  // ячейка начального остатка
  cell = row.insertCell(row.cells.length);
  cell.id="ca"+data[r].i;
  if (!data[r].p) { // итоговая строка
    cell.innerHTML = '<input id="ce'+data[r].i+'" type="number" step="any" value="'+data[r].a+'">';
    var ed = document.getElementById("ce"+data[r].i);
    ed.onchange=chv0;
  }
  // ячейки дат
  for (var c=0; c<qdates;c++) {
    var cell = row.insertCell(row.cells.length);
  }
  // итоговая строка. Пересчет итога предыдущей группы
  if (!(data[r].p) && (parent)) {
    recalcDates(parent);
    recalcRow(parent);
  };
  // расчет итога в строке
  recalcRow(data[r].i);
}
// Пересчет итога предыдущей группы
if (parent) {
  recalcDates(parent);
  recalcRow(parent);
};
// визуализация данных в таблице
dataToTable();
// список дат
sel = document.getElementById("seldate");
for (var i=0; i<dates.length;i++) {
  var option = document.createElement("option");
  option.text = dates[i];
  sel.add(option); 
}
// прячем неитоги
sel.onchange=selDate;
for (var r = hrows;r<tbl.rows.length-frows; r++)
  if (tbl.rows[r].getAttribute("data-parent"))
    tbl.rows[r].style.display = "none";
</script>
</HTML>
