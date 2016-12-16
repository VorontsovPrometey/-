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
function ai(x,y,label){this.x=x; this.y=y; this.label=label; this.indexLabel = y!=0?''+y:'';}
var items1 = new Array();
var items2 = new Array();
var items3 = new Array();
</script>
</head>
<body>
<% 
  var goodsname='';
  var goods='';
  var amount1='';
  var amount2='';
  var amounttotal='';
// выполняем и запоминаем
  var conn=null;

  var sql="exec repElevatorsInput "+psince+","+ptill+","+pgoods;
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
      amounttotal=1*rs('amount').value;
      amount1=1*rs('beznal').value;
      amount2=amounttotal-amount1;
    };
%>
<form name="criteria" action="elevin.asp" method="POST">
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
      var beznal = rs('beznal').value;
      var total = rs('amount').value;
      var nal = total-beznal;
      var ename = rs('elevatorname').value;

      %>items1[<%=i%>]=new ai(<%=i%>, <%=Math.round(beznal)%>,'<%=ename%> (<%=Math.round(beznal/total * 1000) / 10.0%> %/<%=Math.round(nal/total * 1000) / 10.0%> %)');
<%    %>items2[<%=i%>]=new ai(<%=i%>, <%=Math.round(nal)%>,'<%=ename%> (<%=Math.round(beznal/total * 1000) / 10.0%> %/<%=Math.round(nal/total * 1000) / 10.0%> %)');
<%

      i++;
      rs.MoveNext();
    };
  } catch(e) {
    Response.Write(e.message+'; Ошибка выполнения запроса: '+sql);
  }
%>
</script>
<div id="chartContainer" style="width: 100%; font-size:12">
</div>                                                                                                                                                
</body>
<script type="text/javascript">
    var chart = new CanvasJS.Chart("chartContainer",
    {
      backgroundColor: "#fbfbe5",
	  height: items2.length * 40 + 140,
	  zoomEnabled: true,
      title:{
        text: "<%=goodsname%>",
		fontSize: 30
      },
      axisY2: {
        title:"Поступило на элеваторы,т ",
		titleFontSize: 24,
      },
      animationEnabled: true,
      axisY: {
        title: "Поступило на элеваторы <%=amounttotal%>т",
		titleFontSize: 24,
        labelFontSize: 18
      },
      axisX :{
	  	interval: 1,
        labelFontSize: 14,
      },
      legend: {
        verticalAlign: "bottom"
      },
      data: [
      {        
        type: "stackedBar",  
		indexLabelFontSize: 18,
		indexLabelFontColor: "black",
        showInLegend: true,
        legendText: "Безнал <%=amount1%>т (<%=Math.round(amount1/amounttotal * 1000) / 10.0%>%)",
        dataPoints: items1 
      }
	  ,
      {        
        type: "stackedBar",  
		indexLabelFontSize: 18,
        //axisYType: "secondary",
		indexLabelFontColor: "black",
        showInLegend: true,
        legendText: "Наличные <%=amount2%>т (<%=Math.round(amount2/amounttotal * 1000) / 10.0%>%)",
        dataPoints: items2      
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