<%@ LANGUAGE="JScript" CODEPAGE="1251" %>
<% 
trySession();
Response.CacheControl = "no-cache"
Response.AddHeader("Pragma", "no-cache") 
Response.Expires = -1 
Session.Timeout = 600
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
var items0 = new Array();
var items1 = new Array();
var items2 = new Array();
var items3 = new Array();
var items4 = new Array();
var items5 = new Array();
var items6 = new Array();
</script>
</head>
<body>
<% 
  var goodsname='';
  var goods='';
  var amount1='';
  var amount2='';
  var deltaStart='';
  var deltaEnd='';
  var amountplus='';
  var sks='';
  var snk42='';
  var skk42='';
  var price42='';
  var avgprice='';
// выполн¤ем и запоминаем
  var conn=null;
  var sql="exec repElevatorsRestsNotOurs "+psince+","+ptill+","+pgoods+"";
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
	  sks=rs('sks').value;
      inp=1*rs('inp').value;
      deltaStart=1*rs('deltaStart').value;
      deltaEnd=1*rs('deltaEnd').value;
	  posrest=rs('posrest').value;
    };
%>
<form name="criteria" action="elev41.asp" method="POST">
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
</select>
<input name="go" type="submit" value="пересчитать" class="button1" />
</fieldset>
</form>
<script type="text/javascript">
<%
    rs=rs.NextRecordset;    
    var i=0;
	var j=25;
	var pos = 0;
	var neg = 0;
    while (!rs.eof) 
    {
      var d = rs('amount2').value-rs('amount1').value;
	  var rest = Math.round(rs('amount2').value + rs('deltaEnd').value)
      var ename = rs('elevatorname').value;
	  %>items0[<%=i%>]=new ai(<%=j+25%>,<%=0%>,'<%=ename%>');
<%
      %>items1[<%=i%>]=new ai(<%=j%>,<%=rs('amount1').value%>,'<%=ename%>');
<%
      %>items2[<%=i%>]=new ai(<%=j%>,<%=rs('amount2').value%>,'<%=ename%>');
<%
      %>items3[<%=i%>]=new ai(<%=j%>,<%=d%>,'<%=ename%>');
<%
      %>items4[<%=i%>]=new ai(<%=j%>,<%=rs('inp').value%>,'<%=ename%>');
<%
      %>items5[<%=i%>]=new ai(<%=j%>,<%=Math.round(rs('deltaStart').value)%>,'<%=ename%>');
<%
      %>items6[<%=i%>]=new ai(<%=j%>,<%=Math.round(rs('posrest').value)%>,'<%=ename%>');
<%
      i++;
	  pos = pos + (rs('amount2').value > 0 ? rs('amount2').value : 0);
	  neg = neg + (rs('amount2').value < 0 ? rs('amount2').value : 0);
	  j+=50;
      rs.MoveNext();
    };

  } catch(e) {
    Response.Write(e.message+'; ќшибка выполнени¤ запроса: '+sql);
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
	  height: (items2.length + 1) * 100,
	  fontColor: "black",
      title:{
				text: "<%=goodsname%>" + "(Общий остаток: <%=pos%>," + " Общий долг: <%=neg%>)",
				fontSize: 30
      },
      animationEnabled: true,
      axisY2: {
			labelFontSize: 14
      },
      axisY: {
			title: "Остатки чужого товара с учетом займа,т ",
			titleFontSize: 24,
			labelFontSize: 14
      },
      axisX :{
			interval: 50,
			interlacedColor: "rgba(253,229,85,.5)",
			titleFontSize: 24,
			labelFontSize: 14
      },
		toolTip: {
			shared: true
	  },
      legend: {
        verticalAlign: "bottom",
		horizontalAlign: "center",
		fontColor: "black"
      },
      data: [
	  {        
        type: "bar",  
		indexLabelFontSize: 18,
		height: 1,
		indexLabelFontColor: "rgba(0,0,0,.0)",
		showInLegend: false, 
		visible: true,
        dataPoints: items0      },
      {        
        type: "bar",  
		indexLabelFontSize: 18,
		indexLabelFontColor: "black",
        showInLegend: true,
        legendText: "Остатки на <%=till%>: <%=amount2%> т",
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