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
<script type="text/javascript" src="chart.js"></script>
<script type="text/javascript" src="chartjs-plugin-datalabels.min.js"></script>
<script type="text/javascript" src="chartjs-plugin-barchart-background.js"></script>
</head>
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
  var sql="exec repPortRestsGraph "+psince+","+ptill+","+pgoods+","+pkeeper;
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
	  bills=1*rs('bills').value;
      sks=Math.round(amountplus!=0?1*rs('sks').value/amountplus:0);
      avgprice=1*rs('avgprice').value;
	  avgpriceNDS=1*rs('avgpriceNDS').value;
    };
%>
<body>
<form name="criteria" class="form2" action="repPortRestsGraph.asp" method="POST">
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
var barsCount = 7;
var chartData = new Array();
for (var ind = 0; ind <= barsCount; ind++) {	chartData[ind] = new Array();}

<%
    rs=rs.NextRecordset;    
    var i=0;
    while (!rs.eof) 
    {
      var d = rs('amount2').value-rs('amount1').value;
      var ss = rs('avgprice').value!=0?Math.round(1.0*rs('avgprice').value):0;
	  var priceNDS = rs('avgpriceNDS').value!=0?Math.round(1.0*rs('avgpriceNDS').value):0;
      var ename = rs('elevatorname').value;
	  %>chartData[0][<%=i%>]='<%=ename%>';
<%
      %>chartData[1][<%=i%>]=<%=(1.0*rs('amount1').value).formatMoney(2, '.', '')%>;
<%
      %>chartData[2][<%=i%>]=<%=(1.0*rs('amount2').value).formatMoney(2, '.', '')%>;
<%
      %>chartData[3][<%=i%>]=<%=(1.0*rs('inp').value).formatMoney(2, '.', '')%>;
<%
      %>chartData[4][<%=i%>]=<%=ss%>;
<%      
	  %>chartData[5][<%=i%>]=<%=priceNDS%>;
<%	  
      %>chartData[6][<%=i%>]=<%=(1.0*rs('bills').value).formatMoney(2, '.', '')%>;
<%      
	  %>chartData[7][<%=i%>]=<%=(1.0*rs('reestr').value).formatMoney(2, '.', '')%>;
<%
      i++;
      rs.MoveNext();
    };
  } catch(e) {
    Response.Write(e.message+'; Ошибка выполнения запроса: '+sql);
  }
%>
</script>
<div id="chartContainer" style="width: 100%;" align="center" >                                                                                                                                                
<canvas id="bar-chart-grouped" style="width: 100%;"></canvas>
</div>                                                                                                                                                
</body>
<script type="text/javascript">
var ctx = document.getElementById('bar-chart-grouped').getContext('2d');
document.getElementById('bar-chart-grouped').style.height = (chartData[0].length * 100 + 200) + 'px';

var maxRestn = Math.round(Math.max(...chartData[1], ...chartData[2], ...chartData[3], ...chartData[6]) * 115) / 100;
var maxPricen =Math.round(Math.max(...chartData[4], ...chartData[5]) * 115) / 100;

var totalrest = 0;
var reestr = 0;

for (var i = 0; i < chartData[2].length; i++)	{
	if	(chartData[2][i] > 0)	totalrest += chartData[2][i];
	reestr += chartData[7][i];
}

totalrest = Math.round(totalrest * 1000) / 1000;
reestr = Math.round(reestr * 1000) / 1000;

new Chart(ctx, {
    type: 'horizontalBar',
    data: {
      labels: chartData[0],
      datasets: [
        {
          label: "Остатки на <%=since%>: <%=amount1%> т   ",
		  xAxisID: 'A',
          backgroundColor: "#c24642",
		  datalabels: {	align: 'end',	anchor: 'end'},
          data: chartData[1]
        },
        {
          label: "Остатки на <%=till%>: <%=amount2%> т   ",
		  xAxisID: 'A',
          backgroundColor: "#7f6084",
		  datalabels: {	align: 'end',	anchor: 'end'},
          data: chartData[2]
        },
        {
          label: "Поступило за период с <%=since%> по <%=till%>: <%=inp%> т   ",
		  xAxisID: 'A',
          backgroundColor: "#64a333",
		  datalabels: {	align: 'end',	anchor: 'end'},
          data: chartData[3]
        },
        {
          label: "Продано за период с <%=since%> по <%=till%>: <%=bills%> т   ",
		  xAxisID: 'A',
          backgroundColor: "#fdff2a",
		  datalabels: {	align: 'end',	anchor: 'end'},
          data: chartData[6]
        },
        {
          label: "Цена без НДС: <%=avgprice%> грн   ",
		  xAxisID: 'B',
          backgroundColor: "#add8e6",
		  datalabels: {	align: 'end',	anchor: 'end'},
          data: chartData[4]
        },
        {
          label: "Цена c НДС: <%=avgpriceNDS%> грн   ",
		  xAxisID: 'B',
          backgroundColor: "#7998a1",
		  datalabels: {	align: 'end',	anchor: 'end'},
          data: chartData[5]
        }
      ]
    },
    options: {
		devicePixelRatio: 1,
		legend: {
			position: 'bottom',            
			labels: {
				fontSize: 20,
                fontColor: '#000'
            }
		},
		title: {
				display: true,
				fontSize: 26,
				fontColor: '#000',
				text: "<%=goodsname%> " + "(Общий остаток: " + totalrest + "  в т.ч. в пути: " + reestr + ")"
		},
        elements: {
          rectangle: {
            borderWidth: 2,
          }
        },
		scales: {
				  xAxes: [{
					id: 'A',
					type: 'linear',
					position: 'top',
					display: false,
					ticks: {  max: maxRestn,  min: 0	}
				  }, {
					id: 'B',
					type: 'linear',
					position: 'bottom',
					ticks: {  max: maxPricen,  min: 0	}
				  }]
				},
			plugins: {
					datalabels: {
						color: 'black',
						display: function(context) {
							return context.dataset.data[context.dataIndex];
						},
						font: {
							size: 18
						},
						formatter: Math.round
					},
					chartJsPluginBarchartBackground: {
							color: '#fcf09d',
							mode: 'odd'
					}
				},
        tooltips: {
			titleFontSize: 20,
			bodyFontSize: 18,
            callbacks: {
                label: function(tooltipItem, data) {
                    var label = data.datasets[tooltipItem.datasetIndex].label.split(":")[0] + ': ' + tooltipItem.xLabel;
                    return label;
                }
            }
        }
    }
});
</script>
</html>