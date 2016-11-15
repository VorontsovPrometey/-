<%@ LANGUAGE="JScript" CODEPAGE="1251" %>
<% 
trySession();
Response.CacheControl = "no-cache"
Response.AddHeader("Pragma", "no-cache") 
Response.Expires = -1 
Session.Timeout = 480
%>
<!--  #include file="connstr.inc" -->
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<script type="text/javascript" src="canvasjs.min.js"></script>
<%
WriteStyle(); 
// дата
var s=''+Request.ServerVariables('Request_Method');
var goods=''
var till=new Date();
if ((s.indexOf('POST')>=0)&&(''+Request.Form("till")!='undefined')) {
  till=parseDate(""+Request.Form("till"));
} else {
  till='';
}
var since=new Date();
if ((s.indexOf('POST')>=0)&&(''+Request.Form("since")!='undefined')) {
  since=parseDate(""+Request.Form("since"));
} else {
  since='';
}
if ((s.indexOf('POST')>=0)&&(''+Request.Form("goods")!='undefined')) {
  goods=''+Request.Form("goods");
}
var psince='null'
var ptill='null'
var pgoods='null'
if (goods!='') {pgoods="'"+goods+"'"};
if (since!='') {psince="'"+dateToSQL(since)+"'"};
if (till!='') {ptill="'"+dateToSQL(till)+"'"};
%>
<script type="text/javascript">
function ai(x,y,label){this.x=x; this.y=y; this.label=label; this.indexLabel = ''+y;}
var items1 = new Array();
var items2 = new Array();
var items3 = new Array();
var items4 = new Array();
var items5 = new Array();
</script>
</head>
<body>
<% 
  var goodsname='';
  var goods='';
  var amount1='';
  var amount2='';
  var amountplus='';
  var sks='';
  var snk42='';
  var skk42='';
  var price42='';
  var avgprice='';
// выполняем и запоминаем
  var conn=null;
  var sql="exec repElevatorsRests "+psince+","+ptill+","+pgoods;
  try {
    conn=getConnection(false);
    conn.CommandTimeout=160;
    var rs=conn.Execute(sql);
    if (!rs.eof) 
    {
      goodsname=rs('goodsname').value;
      goods=rs('goods').value;
      since=rs('since').value;
      till=rs('till').value;
      amount1=1*rs('amount1').value;
      amount2=1*rs('amount2').value;
      amountplus=1*rs('amountplus').value;
      inp=1*rs('inp').value;
      sks=Math.round(amountplus!=0?1*rs('sks').value/amountplus:0);
      avgprice=1*rs('avgprice').value;
      snk42=1*rs('snk42').value;
      skk42=1*rs('skk42').value;
      price42=1*rs('price42').value;
    };
%>
<form name="criteria" action="elev.asp" method="POST">
<fieldset>
с&nbsp;<input class="date" type=Text name="since" size=5 maxlength=10 value="<%=dateToStr(since) %>"> 
по&nbsp;<input class="date" type=Text name="till" size=5 maxlength=10 value="<%=dateToStr(till) %>">
культура&nbsp;<select name="goods">
<%
    rs=rs.NextRecordset;
    while (!rs.eof) 
    {
%><option value="<%=rs(0).value%>" <% if (rs(0).value==goods){%>selected<%}%> ><%=rs(1).value%></option>
<%
      rs.MoveNext();
    };
%>
<input name="go" type="submit" value="пересчитать" class="button1" />
</fieldset>
</form>
</div>
<script type="text/javascript">
<%
    rs=rs.NextRecordset;    
    var i=0;
    while (!rs.eof) 
    {
      var d = rs('amount2').value-rs('amount1').value;
      var ss = rs('amount2').value!=0?Math.round(1.0*rs('sks').value/rs('amount2').value):0;
      var ename = rs('elevatorname').value;
      %>items1[<%=i%>]=new ai(<%=i%>,<%=rs('amount1').value%>,'<%=ename%>');
<%
      %>items2[<%=i%>]=new ai(<%=i%>,<%=rs('amount2').value%>,'<%=ename%>');
<%
      %>items3[<%=i%>]=new ai(<%=i%>,<%=d%>,'<%=ename%>');
<%
      %>items4[<%=i%>]=new ai(<%=i%>,<%=rs('inp').value%>,'<%=ename%>');
<%
      %>items5[<%=i%>]=new ai(<%=i%>,<%=ss%>,'<%=ename%>');
<%
      i++;
      rs.MoveNext();
    };
    d=skk42-snk42;
    %>items1[<%=i%>]=new ai(<%=i%>,<%=snk42%>,'В пути');<%
    %>items2[<%=i%>]=new ai(<%=i%>,<%=skk42%>,'В пути');<%
    %>items3[<%=i%>]=new ai(<%=i%>,<%=d%>,'В пути');<%
    %>items5[<%=i%>]=new ai(<%=i%>,<%=price42%>,'В пути');<%
  } catch(e) {
    Response.Write(e.message+'; Ошибка выполнения запроса: '+sql);
  }
%>
</script>
<div id="chartContainer" style="height: 1200px; width: 100%; font-size:12">
</div>                                                                                                                                                
</body>
<script type="text/javascript">
    var chart = new CanvasJS.Chart("chartContainer",
    {
      backgroundColor: "#fbfbe5",
      title:{
        text: "<%=goodsname%>",
	fontSize: 30
      },
      axisY2: {
        title:"Остатки на элеваторах,т ",
	titleFontSize: 24,
      },
      animationEnabled: true,
      axisY: {
        title: "Остатки на элеваторах,т ",
	titleFontSize: 24,
        labelFontSize: 14
      },
      axisX :{
        labelFontSize: 14,
      },
      legend: {
        verticalAlign: "bottom"
      },
      data: [
      {        
        type: "bar",  
	indexLabelFontSize: 16,
        showInLegend: true, 
        legendText: "Остатки на <%=since%>: <%=amount1%> т",
        dataPoints: items1      },
      {        
        type: "bar",  
	indexLabelFontSize: 16,
        //axisYType: "secondary",
        showInLegend: true,
        legendText: "Остатки на <%=till%>: <%=amount2%> т",
        dataPoints: items2      },
      {        
        type: "bar",  
	indexLabelFontSize: 16,
        //axisYType: "secondary",
        showInLegend: true,
        legendText: "Разница: <%=amount2-amount1%> т",
        dataPoints: items3      },

      {        
        type: "bar",  
	indexLabelFontSize: 16,
        //axisYType: "secondary",
        showInLegend: true,
        legendText: "Поступило: <%=inp%> т",
        dataPoints: items4      },

      {        
        type: "bar",  
	indexLabelFontSize: 16,
        showInLegend: true,
        legendText: "Цена: <%=avgprice%> грн",
        dataPoints: items5      
       }

      ],
      legend: {
        cursor:"pointer",
	fontSize: 20,
        itemclick : function(e){
          if (typeof(e.dataSeries.visible) === "undefined" || e.dataSeries.visible) {
            e.dataSeries.visible = false;
          }
          else{
            e.dataSeries.visible = true;
          }
          chart.render();
        }
      }
    });

chart.render();
</script>

</html>