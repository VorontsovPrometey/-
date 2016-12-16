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

</script>
</head>
<body>
<% 
  var goodsname='';
  var goods='';
  var summa='';
// выполняем и запоминаем
  var conn=null;
  var sql="exec repElevatorsServiceProfit "+psince+","+ptill+","+pgoods+"";
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
      summa=1*rs('summa').value;
    };
%>
<form name="criteria" action="elevServiceProfit.asp" method="POST">
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
      var ename = rs('elevatorname').value;
      %>items1[<%=i%>]=new ai(<%=i%>,<%=Math.round(rs('summa').value)%>,'<%=ename%>');
<%
      i++;
      rs.MoveNext();
    };

  } catch(e) {
    Response.Write(e.message+'; Ошибка выполнения запроса: '+sql);
  }
%>
</script>
<div id="chartContainer" style=" width: 100%; font-size:12">
</div>                                                                                                                                                
</body>
<script type="text/javascript">
    var chart = new CanvasJS.Chart("chartContainer",
    {
      backgroundColor: "#fbfbe5",
	  height: items1.length * 40 + 140,
	  zoomEnabled: true,
	  fontColor: "black",
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
        title: "Џрибыль от услуг элеватора, грн ",
	titleFontSize: 24,
        labelFontSize: 14
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
        type: "bar",  
		indexLabelFontSize: 16,
		indexLabelFontColor: "black",
        //axisYType: "secondary",
        showInLegend: true,
		color: "#c24642",
        legendText: "орибыль от услуг элеватора с <%=since%> по <%=till%>: <%=summa%> грн",
        dataPoints: items1      
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