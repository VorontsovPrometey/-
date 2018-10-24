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
var keeperType='';
var keeper='';
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
if ((s.indexOf('POST')>=0)&&(''+Request.Form("keeperType")!='undefined')) {
  keeperType=''+Request.Form("keeperType");
}
if ((s.indexOf('POST')>=0)&&(''+Request.Form("keeper")!='undefined')) {
  keeper=''+Request.Form("keeper");
}
var psince='null'
var ptill='null'
var pgoods='null'
var ptype='null'
var pkeeper='null'
if (goods!='') {pgoods="'"+goods+"'"};
if (since!='') {psince="'"+dateToSQL(since)+"'"};
if (till!='') {ptill="'"+dateToSQL(till)+"'"};
if (keeperType!='') {ptype="'"+keeperType+"'"};
if (keeper!='') {pkeeper="'"+keeper+"'"};
%>
<script type="text/javascript">
 function ai(x,y,yRound,label,legend,val){this.x=x; this.y=y; this.indexLabelFormatter= function (e) { return  yRound; }; 
										  this.label=label; this.indexLabel = ''+y; this.legend=legend; this.val=val;}
var items0 = new Array();
var items1 = new Array();
var items2 = new Array();
var items3 = new Array();
var items4 = new Array();
var items5 = new Array();
</script>
</head>
<body>
<% 
Number.prototype.formatMoney = function(c, d, t){
var n = this, 
    c = isNaN(c = Math.abs(c)) ? 2 : c, 
    d = d == undefined ? "." : d, 
    t = t == undefined ? "," : t, 
    s = n < 0 ? "-" : "", 
    i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "", 
    j = (j = i.length) > 3 ? j % 3 : 0;
   return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
 };
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
  var avgpriceNDS='';

// выполняем и запоминаем
  var conn=null;
  var sql="exec repElevatorsRests "+psince+","+ptill+","+pgoods+","+pkeeper+","+ptype;
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
	  avgpriceNDS=1*rs('avgpriceNDS').value;
      snk42=1*rs('snk42').value;
      skk42=1*rs('skk42').value;
      price42=1*rs('price42').value;
    };
%>
<form name="criteria" class="form2" action="elev.asp" method="POST">
<fieldset class="fieldset">
с&nbsp;<input class="date" type=Text name="since" size=5 maxlength=10 value="<%=dateToStr(since) %>">
по&nbsp;<input class="date" type=Text name="till" size=5 maxlength=10 value="<%=dateToStr(till) %>"> <br>
культура&nbsp;<select class="select" name="goods" > <br>
<%
    rs=rs.NextRecordset;
    while (!rs.eof) 
    {
%><option value="<%=rs(0).value%>" <% if (rs(0).value==goods){%>selected<%}%> ><%=rs(1).value%></option>
<%
      rs.MoveNext();
    };
%>
</select><br>
хранитель&nbsp;<select class="select" name="keeper" > <br>
<%
    rs=rs.NextRecordset;
    while (!rs.eof) 
    {
%><option value="<%=rs(0).value%>" <% if (rs(0).value==keeper){%>selected<%}%> ><%=rs(2).value%></option>
<%
      rs.MoveNext();
    };
%>
</select><br>
&nbsp;<input name="go" type="submit" value="пересчитать" class="button1" />
</fieldset>
</form>
</div>
<script type="text/javascript">
<%
    rs=rs.NextRecordset;    
    var i=0;
	var j=25;
	var pos = 0;
	var neg = 0;
	var maxPrice = 3000;
	var minPrice = 0;
	var maxRest = 200;
	var minRest = 0;
    while (!rs.eof) 
    {
      var d = rs('amount2').value-rs('amount1').value;
      var ss = rs('avgprice').value!=0?Math.round(1.0*rs('avgprice').value):0;
	  var priceNDS = rs('avgpriceNDS').value!=0?Math.round(1.0*rs('avgpriceNDS').value):0;
      var ename = rs('elevatorname').value;
	  %>items0[<%=i%>]=new ai(<%=j+25%>,<%=0%>,<%=0%>,'<%=ename%>');
<%
      %>items1[<%=i%>]=new ai(<%=j%>,<%=(1.0*rs('amount1').value).formatMoney(3, '.', '')%>,<%=(1.0*rs('amount1').value).formatMoney(0, '.', '')%>,'<%=ename%>','Остатки на <%=since%>','т');
<%
      %>items2[<%=i%>]=new ai(<%=j%>,<%=(1.0*rs('amount2').value).formatMoney(3, '.', '')%>,<%=(1.0*rs('amount2').value).formatMoney(0, '.', '')%>,'<%=ename%>','Остатки на <%=till%>','т');
<%
      %>items3[<%=i%>]=new ai(<%=j%>,<%=(1.0*rs('inp').value).formatMoney(3, '.', '')%>,<%=(1.0*rs('inp').value).formatMoney(0, '.', '')%>,'<%=ename%>','Поступило c <%=since%> по <%=till%>','т');
<%
      %>items4[<%=i%>]=new ai(<%=j%>,<%=ss%>,<%=ss%>,'<%=ename%>','Цена без НДС','грн');
<%      
	  %>items5[<%=i%>]=new ai(<%=j%>,<%=priceNDS%>,<%=priceNDS%>,'<%=ename%>','Цена с НДС','грн');
<%	  
      i++;
	  pos = pos + (rs('amount2').value > 0 ? rs('amount2').value : 0);
	  neg = neg + (rs('amount2').value < 0 ? rs('amount2').value : 0);
	  maxPrice = Math.max(maxPrice, priceNDS);
	  maxRest = Math.max(maxRest, 1.0*rs('amount1').value, 1.0*rs('amount2').value, 1.0*rs('inp').value);
	  minRest = Math.min(minRest, 1.0*rs('amount1').value, 1.0*rs('amount2').value, 1.0*rs('inp').value);
	  j+=50;
      rs.MoveNext();
    };
	maxPrice = Math.round(1.2*maxPrice);
	minPrice = minRest >= 0 ? 0 : -maxPrice;
	maxRest = Math.round(1.2*Math.max(maxRest, Math.abs(minRest)));
	minRest = minRest >= 0 ? 0 : -maxRest;
  } catch(e) {
    Response.Write(e.message+'; Ошибка выполнения запроса: '+sql);
  }
%>
</script>
<div id="chartContainer" style="width: 80%; font-size:15;" align="center" ></div>                                                                                                                                                
</body>
<script type="text/javascript">
window.onload = function () {

    var chart = new CanvasJS.Chart("chartContainer",
    {
      backgroundColor: "#fbfbe5",
	  height: items2.length + 1 > 3 ? (items2.length + 1) * 110 : (items2.length + 1) * 250,
	  fontColor: "black",
      title:{
        text: "<%=goodsname%> " + "(Общий остаток: <%=pos%>," + " Общий долг: <%=neg%>)",
		fontSize: 26
      },
      animationEnabled: true,
      axisY: {
        title: "Остатки на элеваторах,т ",
		titleFontSize: 24,
        labelFontSize: 14,
		maximum: <%=maxRest%>,
		minimum: <%=minRest%>
      },
      axisY2: {
        //title:"Остатки на элеваторах,т ",
		titleFontSize: 24,
        labelFontSize: 14,
		axisYType: "secondary",
		maximum: <%=maxPrice%>,
		minimum: <%=minPrice%>
      },
      axisX :{
	  	interval: 50,
		interlacedColor: "rgba(253,229,85,.5)",
        labelFontSize: 14
      },
      legend: {
        verticalAlign: "bottom",
		fontColor: "black"
      },
	  toolTip: {
		shared: true,
		fontSize: 18,
		fontStyle: "normal",
		content: toolTipFormatter

	  },
      data: [
      {        
        type: "bar",  
		indexLabelFontSize: 10,
		indexLabelFontColor: "rgba(0,0,0,.0)",
		showInLegend: false, 
		visible: true,
        dataPoints: items0      },
      {        
        type: "bar",  
		indexLabelFontSize: 15,
		indexLabelFontColor: "black",
		axisYIndex: 0,
		showInLegend: true, 
        legendText: "Остатки на <%=since%>: <%=amount1%> т",
        dataPoints: items1      },
      {        
        type: "bar",  
		indexLabelFontSize: 15,
		indexLabelFontColor: "black",
		axisYIndex: 0,
        //axisYType: "secondary",
        showInLegend: true,
        legendText: "Остатки на <%=till%>: <%=amount2%> т",
        dataPoints: items2      },
//      {        
//        type: "bar",  
//	indexLabelFontSize: 16,
//        //axisYType: "secondary",
//        showInLegend: true,
//        legendText: "Разница между красным и синим: <%=Math.round((amount2-amount1)*1000.0)/1000.0%> т",
//        dataPoints: items3      },

      {        
        type: "bar",  
		indexLabelFontSize: 15,
		indexLabelFontColor: "black",
		axisYIndex: 0,
        //axisYType: "secondary",
        showInLegend: true,
		color: "#64A333",
        legendText: "Поступило за период с <%=since%> по <%=till%>: <%=inp%> т",
        dataPoints: items3      },

      {        
        type: "bar",  
	indexLabelFontSize: 15,
		indexLabelFontColor: "black",
		axisYIndex: 1,
		axisYType: "secondary",
        showInLegend: true,
		color: "#add8e6",
        legendText: "Цена без НДС: <%=avgprice%> грн",
        dataPoints: items4      },

      {        
        type: "bar",  
	indexLabelFontSize: 15,
		indexLabelFontColor: "black",
		axisYIndex: 1,
		axisYType: "secondary",
        showInLegend: true,
		backgroundColor: "#FF0000",
		color: "#7998a1",
        legendText: "Цена c НДС: <%=avgpriceNDS%> грн",
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

function toolTipFormatter(e) {
	if(e.entries.length > 1)
	{
		var str="<strong>" + e.entries[0].dataPoint.label + "</strong> <br/>";
		var str1="";
		for (var i = 0; i < e.entries.length; i++){
			str1 = str1.concat("<span style= \"color:"+e.entries[i].dataSeries.color + "\">" + e.entries[i].dataPoint.legend + ":</span>  <b>" + e.entries[i].dataPoint.y + " " + e.entries[i].dataPoint.val + "</b><br/>") ;
		}
		
			return str.concat(str1);
	}
	
	return "";
}

}
</script>

</html>