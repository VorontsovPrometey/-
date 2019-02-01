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
<style>
input {width:50pt; text-align:right;}
.dig {text-align: right;}
.qty {font-style: italic;}
.inc {background-color: #B0E0E6;}
.exp {background-color: #FFDAB9;}
.inct {background-color: #B0E0E6; text-align: right;}
.expt {background-color: #FFDAB9; text-align: right;}
.total {font-style: bold; text-align: right;}
.zui-table {
    border: none;
    border-right: solid 1px #DDEFEF;
    border-collapse: separate;
    border-spacing: 0;
    font: normal 13px Arial, sans-serif;
}
.zui-table thead th {
    background-color: #DDEFEF;
    border: none;
    color: #336B6B;
    padding: 10px;
    text-align: left;
    text-shadow: 1px 1px 1px #fff;
    white-space: nowrap;
}
.zui-table tbody th {
    text-align: left;
}
.zui-table tbody td {
    border-bottom: solid 1px #DDEFEF;
    color: #333;
//    text-align: right;
    padding: 10px;
    text-shadow: 1px 1px 1px #fff;
    white-space: nowrap;
}
.zui-wrapper {
    position: relative;
}
.zui-scroller {
    margin-left: 241px;
    overflow-x: scroll;
    overflow-y: visible;
    padding-bottom: 5px;
    width: 1280px;
}
.zui-table .zui-sticky-col {
    border-left: solid 1px #DDEFEF;
    border-right: solid 1px #DDEFEF;
    left: 0;
    position: absolute;
    top: auto;
    width: 220px;
}
}</style>

<script>
"use strict";
let btBlue = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAACW0lEQVR42m2TX0hTURzHv+f+2e7uXKMsXRQx2h4iwkClegnCSS8qBSa9BFYICfXQHqopqJWgqx72UmAgmdBLmNAffZpK0EuF+hARgQ5EiqZRYbq/997dzr1nW3dzF77cwznn+zm/3zm/H8H2z0N1EY6dAbg8XnNmM76C1J9ZOnpKFbduJmXjm/Cf6vc2XZBPNNZj3y7JXPj+O43384tYmXuWxPLbu3TqPpVuBRAItjFHS2/n+Y521B9wl+J19ltc3cDziUmkpofGoWYvGSuFLbfEs3fCHdS8Z4eNGkleFoCum/r5N4sJClFeDoTo7D1i5ny4KVbXHZZ9NU6AI0yVADmm2HoCn0ZCSXyZ8xlbQtyV0eGG443gRR7gSSkEpWZoOjRFw8KHeeQed/UQuKqj9r43zfurZUDgmPhyAPLmHKAyffuVRGawbYbAW7ckBEf9bpcdEDkmPg8pj8AwK0wbmxmoka5lgoNHl3DjiV+SRcBOUzDSsEYBFENnAA3IakgnFODBZQpw744iMtsMhwDOANgKkDKAqhfNuQz9p1XgemDGvEQMvRjGoSOAJLAobJYojK9wOjWjYP76Geg918Oe8WRrDKGIDEkEcVCzXcjfhQVg5J5RoacpIEXDDweTeDflKxYSBkbC4ukWOJwii8SWf1KjGLTC6SpSWwqU6DRwu7tYSKxo7dIYBh911radQU0VjcS8C44BaO46BazTi1t7/QrouzqOTLqklP83U2t7v/NaUN57rAFVEm9Ob9Gcf3xcQOJhJImpyYrNtL2daz0B+HysnWOxFazFK7bzP8WO+D+sLvrfAAAAAElFTkSuQmCC';
let btYellow = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAACW0lEQVR42mNkwAQSQJwgwcfkrCjCogASuP/mz4MXn/7tBTIXAPELZMWMaOyycBOuuqJQAy5DC0cGRl5ZsMT/z48Zzp/Yz9C3+sK3lWe+NQGFukDCyAYwcrIyzl+QIRcfFJvNwChpxsDIiOqs/0Dl/5+fYli3eCpDwoxHC7///p8IEoYpK1+ZK9URlFDIwMgjieouFFOA6MtzhnUL+hnCJz+rAIp0gpRKhFtw3V3UHMjFJKrHALaaEclTDDDHQmmgU/69vsQQV7v+28oT35RBSipOtkm3GzoEMzAwMzMwMEHMwHDFf4g3GP4B8d+/DOcPrGUwr3paySghwLT7wVwNFyZRA7BmOGZEcwEM/4UY8u/1BQaF5Bt7GK3U2W/v61RQYeKTA7oAqhlGI4N/CM0g+t+nRwxOFQ/uMFppsN/e3yWhwsAlwsDAAtLMyMDIjOQKmAuAGv+DDPgL5PwB0t/eMDiWvbjDKCEI9MJSaRdGVqBuNlaw7YwsOAz4A3XFr98M/3//YVCIfroHEojTJdoNNNiAGoFcoBkMOAwA2/wbZNB/hgs3fjGYZ76oBEdjhDPX3YUNIlyMbEDrWRmhXkEz4C/MgP8M/3/9ZYhvePNtxV5INIIT0qoO0Y4Ad1EGBg4BiBeQAxIacGAv/PjAsGHna4awitfwhARJyuyM8xe2i8YH+uoyMHLJQw2ASv/7DzHg20OG9ZsvM8RXvl74/SdqUoZnpggfrrriTDkuA2M1BkY2AYgPfn1guHD2FkPv9EffVmzBnpkws7MYs7OSAosCKFXevQ/Mzq/+Ys3OAAw/4oQno+m2AAAAAElFTkSuQmCC';
let btSave = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAACgklEQVR42o3TS0hUURjA8f+dl+NjnEbG9yPMUZOExlVFwYgVQQvLR4hUlFC7VhotisBFT7MoFFpIWhKEkvZYtGrhhD009BbVomIoNQODaNTGcR46fXeui1YyBz7u4d57fufxfUcB7JjMHeQUVklfcRoh3WTEJGE0GjEYFGKrMVZWV/EHAszNTF+Q/56w1hTMll6aulsw5cRftNakUVvmINNhx56ehkmQD3N/CMng0al5rnR0Rph42iy/DulARvEktbeqpAcmA+f3ZVC/2YnDbiPZaiG4HKJ6cJzKNBPFZgtdYxFQ70QYHz4qIwY0QKWhy41F1i5xea+TxopMbKkpRFei+Bf+Utf/ApfNTG66jd6vycgHmOiL8mrwuIJzk8rh226SdODm7iwOVWTF976wGOC3f4Hht18gFGQmambAnyX9VYhEof/kO4XMEpUTPW6sJjSkpsBCaYY1fmjL4bBsIczSUpBAIMjsMvhiGQLICkIC9GhAtkvlVJ8OaKFtxWwAo4RB0Y9asiCizCoRlsHLUT26WwTIFaDtvrsy38brhnIZp7BeWxFsx9BnPs4uwvUjAuSVqpx94PYUb2BkfwmJtOpnPrzf/HCpWYCCMpX2Abdno52RPcWJAc+/450SoL1JgEIBLj50e4oE8BQlBnin8U7Pw7lGDShXuTosQDojOwsSA17+wDuzAGfqBSgS4NojHdienxjwZlYHTtfFgUk6H1dtyU5hdFueVPP6WYhKFnaN/eTTryVoO6gqWKx3BTiGywXJUgOpZj1SzHpdaE3L+ZLcgcBaBKUWfD4BDtzTpnNgSbpBYclWuXpKvHjiRaRdtbXVxP4rJu0ZXYkx43tPONT6D2yQ8LNVoCvdAAAAAElFTkSuQmCC';
let heute="<%  
var now = dateToStr(new Date());
Response.Write(now.substr(6,4)+"-"+now.substr(3,2)+"-"+now.substr(0,2)) %>";
</script>

</HEAD>
<BODY>
<% WriteHeader(); %>
	<div id="container">
<h1>Денежный поток</h1>
<form name="criteria" action="cf.asp" method="POST">
<fieldset>
с&nbsp;<input class="date" type=Text id="since"  value="<%=dateToStr(Session.Contents('since')) %>"> 
по&nbsp;<input class="date" type=Text id="till"  value="<%=dateToStr(Session.Contents('till')) %>">
<input name="go" type="submit" value="выполнить" class="button1" />
</fieldset>
</form>
<div id="info"></div>
<div>Кпопки означают: <image class="bqp"/>рассчитать план <image class="bqf"/>взять факт <image class="bs"/>сохранить </div>
<div class="zui-wrapper">
<div id="inner" class="zui-scroller">
<table class="zui-table" id="thetable">
<thead>
<tr>
<th class="zui-sticky-col">Показатель</th>
<th>План на период</th>
<th>Всего</th>
<%
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
} else {
  till=new Date((Session.Contents('till')));
}
var dates = new Array();
var rows = new Array();
var vals = {};

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
     rows.push({id: 1*rs('id').value, 
name: ""+rs('name').value, 
qp: rs('qp').value, 
qf: rs('qf').value, 
qr: rs('qr').value,
ismoney: rs('ismoney').value,
incom: rs('incom').value
});
     rs.MoveNext();
  };
  rs=rs.NextRecordset;
  while (!rs.eof) {
     vals[""+rs('id').value+"."+rs('date').value] = 1.0*rs('value').value;
     rs.MoveNext();
  };

for (var i=0;i<dates.length;i++) {
%><th data-dt="<%=(dates[i].dt)%>"><%=(dates[i].dt)%><br/>
<image id="cp<%=(dates[i].dt)%>" class="cp" /><image id="cf<%=(dates[i].dt)%>" class="cf" /><image id="cs<%=(dates[i].dt)%>" class="cs" /></th>
<%
}
}catch(e) {
   sayerror("",e);
}

%>
</tr>
</thead>
<tbody>
<%
for (var i=0;i<rows.length;i++) {
%>
<tr id="r<%=rows[i].id%>"<% if (!rows[i].ismoney) {%> class="qty"<%} %> <% if (!rows[i].incom) {%> class="exp"<%} else {%> class="inc"<%} %> data-money="<%=rows[i].ismoney%>" data-incom="<%=rows[i].incom%>">
<th class="zui-sticky-col" ><%=(rows[i].name)%></th>
<td id="t<%=""+rows[i].id%>" class="dig"></td><td id="x<%=""+rows[i].id%>" class="dig"></td><%
  for (var c=0;c<dates.length;c++) {
     var key = ""+rows[i].id+"."+dates[c].dt;
     var v = vals[key];
%><td><input id="i<%=key%>" value="<%=v%>"/>
<% if (rows[i].qp) {%><image id="p<%=key%>" class="bqp"/><%} %>
<% if (rows[i].qf) {%><image id="f<%=key%>" class="bqf"/><%} %><image id="s<%=key%>" class="bs" /></td>
<%  } %>
</tr><%
}
%>
<tr id="r-1" class="inct">
<th class="zui-sticky-col" >Всего доходов</th><td id="t-1" class="dig"></td><td id="x-1" class="dig">111</td>
<%
  for (var c=0;c<dates.length;c++) {
%><td><%=c%></td><%
  }
%>
</tr>
<tr id="r-2" class="expt">
<th class="zui-sticky-col" >Всего расходов</th><td id="t-2" class="dig"></td><td id="x-2" class="dig">222</td>
<%
  for (var c=0;c<dates.length;c++) {
%><td>c</td><%
  }
%>
</tr>
<tr id="r-3" class="total">
<th class="zui-sticky-col" >Чистый денежный поток</th><td id="t-3" class="dig"></td><td id="x-3" class="dig">333</td>
<%
  for (var c=0;c<dates.length;c++) {
%><td></td><%
  }
%>
</tr>
</tbody>
<tfoot>
</tfoot>
</table>
</div>
		</div>
	</div> <!--end container-->
</BODY>

<script>
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
let inp = document.getElementById("i"+this.id.substr(1));
let a = this.id.substr(1).split(".");
getTable(null, null, "cfget.asp?id="+a[0]+"&dt="+a[1].replace(/-/g,"")+"&plan=1", toInput, document.getElementById("info"), inp.id, "GET");
}
function setfact() {
let inp = document.getElementById("i"+this.id.substr(1));
let a = this.id.substr(1).split(".");
getTable(null, null, "cfget.asp?id="+a[0]+"&dt="+a[1].replace(/-/g,"")+"&plan=0", toInput, document.getElementById("info"), inp.id, "GET");
}
function toInput(txt,tel) {
  let inp = document.getElementById(tel);
  if (inp) inp.value=txt;
}
function recalc(txt,tel) {
  let inp = document.getElementById(tel);
  if (inp) {
    let a = inp.id.substr(1).split(".");
    calc(1*a[0]);
    let t = document.getElementById("thetable");
    for (var i=1; i<t.rows[0].cells.length; i++) {
      calccol(i)
    }
  }
}

function save() {
let inp = document.getElementById("i"+this.id.substr(1));
let a = this.id.substr(1).split(".");
getTable(null, null, "cfset.asp?id="+a[0]+"&dt="+a[1].replace(/-/g,"")+"&val="+inp.value, recalc, document.getElementById("info"), inp.id, "GET");
}
function calc(row) {
  var sum=0;
  var plan = 0;
  var now=new Date();
  let t = document.getElementById("thetable");
  let hrow = t.rows[0];
//console.log("["+heute+"]","["+hrow.cells[3].innerHTML+"]",hrow.cells[3].innerHTML<heute);
  for (var i=1; i<t.rows.length; i++) {
    var therow = t.rows[i];
    if ((therow.id)&&(therow.id.substr(1)==row)) {
      for (var c=3; c<therow.cells.length; c++) {
        let inp = document.getElementById("i"+row+"."+hrow.cells[c].getAttribute("data-dt"));
        if ((inp)&&(inp.value)) {
          if (hrow.cells[c].getAttribute("data-dt")<=heute)
            sum+=1.0*inp.value;
          plan+=1.0*inp.value;
        };
      };
      break;
    }
  }
  let total = document.getElementById("x"+row);
  total.innerHTML = ""+Math.round(sum);
  let plancell = document.getElementById("t"+row);
  plancell.innerHTML = ""+Math.round(plan);
}
const totalrows = 3;

function calccol(col) {
  var incom =0;
  var cost = 0;
  var total = 0;
  let t = document.getElementById("thetable");
  let hrow = t.rows[0];
  for (var i=1; i<t.rows.length-totalrows; i++) {
    var therow = t.rows[i];
    if (therow.id) {
      let ismoney = therow.getAttribute("data-money");
      if (ismoney=="True") {
        let isincom=therow.getAttribute("data-incom");
        let a = therow.id.substr(1).split(".");
        var row = a[0];
        var val=0;
        if (col<3) {
          val = therow.cells[col].innerHTML;
          if (val.length==0)
            val=0;
        } else {
          let inp = document.getElementById("i"+row+"."+hrow.cells[col].getAttribute("data-dt"));
          val = 1.0*inp.value;
        }
          if (isincom=="True") {
            incom+=1.0*val;
            total+=1.0*val;
          } else {
            cost+=1.0*val;
            total-=1.0*val;
          };
      };
    }
  }
  let rowincom = document.getElementById("r-1");
  rowincom.cells[col].innerHTML = ""+incom;
  let rowcost = document.getElementById("r-2");
  rowcost.cells[col].innerHTML = ""+cost;
  let rowtotal = document.getElementById("r-3");
  rowtotal.cells[col].innerHTML = ""+total;
}

function toCol(txt,tel) {
  let ar=txt.split("|");
  let t = document.getElementById("thetable");
  let hrow = t.rows[0];
  var col = -1;
  for (var c=3; c<hrow.cells.length; c++) {
    if (hrow.cells[c].getAttribute("data-dt")==tel) {
      col=c;
      break;
    }
  }
  if (col<0) return;
  var row = 1;
  for (var i=0; i<ar.length; i++) {
    var va = ar[i].split("=");
    if (va.length==2) {
      for (var r=row; r<t.rows.length; r++) {
        if (t.rows[r].id.substr(1)==va[0]) {
          row = r;
          let inp = document.getElementById("i"+va[0]+"."+tel);
          inp.value = va[1];
          calc(r);
          break;
        }
      }
      for (var c=1; c<t.rows[0].cells.length; c++) {
        calccol(c)
      }
    }
  }
}
function setplancol() {
  getTable(null, null, "cfgetcol.asp?dt="+this.id.substr(2).replace(/-/g,"")+"&plan=1", toCol, document.getElementById("info"), this.id.substr(2), "GET");
}
function setfactcol() {
  getTable(null, null, "cfgetcol.asp?dt="+this.id.substr(2).replace(/-/g,"")+"&plan=0", toCol, document.getElementById("info"), this.id.substr(2), "GET");
}
function savecol() {
  let colid=this.id.substr(2);
  let t = document.getElementById("thetable");
  let hrow = t.rows[0];
  var col = -1;
  for (var c=3; c<hrow.cells.length; c++) {
    if (hrow.cells[c].getAttribute("data-dt")==colid) {
      col=c;
      break;
    }
  }
  if (col<0) return;
  for (var r=1; r<t.rows.length; r++) {
    let id = t.rows[r].id.substr(1);
    let inp = document.getElementById("i"+id+"."+colid);
    if (inp)
      getTable(null, null, "cfset.asp?id="+id+"&dt="+colid+"&val="+inp.value, recalc, document.getElementById("info"), inp.id, "GET");
 }
}

var buttons = document.getElementsByClassName("bqp");
for (var b = 0; b < buttons.length; b++) {
  buttons[b].src = btBlue;
  buttons[b].onclick=setplan;
}
buttons = document.getElementsByClassName("bqf");
for (var b = 0; b < buttons.length; b++) {
  buttons[b].src = btYellow;
  buttons[b].onclick=setfact;
}
buttons = document.getElementsByClassName("bs");
for (var b = 0; b < buttons.length; b++) {
  buttons[b].src = btSave;
  buttons[b].onclick=save;
}
buttons = document.getElementsByClassName("cp");
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

let t = document.getElementById("thetable");
for (var i=1; i<t.rows.length; i++) {
    calc(t.rows[i].id.substr(1))
}
for (var i=1; i<t.rows[0].cells.length; i++) {
    calccol(i)
}
</script>
</HTML>
