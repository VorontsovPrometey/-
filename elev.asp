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
var labels = new Array();
var startRests = new Array();
var endRests = new Array();
var input = new Array();
var price = new Array();
var ndsPrice = new Array();
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
	  %>startRests[<%=i%>]=<%=(1.0*rs('amount1').value).formatMoney(3, '.', '')%>;
<%
	  %>endRests[<%=i%>]=<%=(1.0*rs('amount2').value).formatMoney(3, '.', '')%>;
<%
	  %>input[<%=i%>]=<%=(1.0*rs('inp').value).formatMoney(3, '.', '')%>;
<%
	  %>price[<%=i%>]=<%=ss%>;
<%
	  %>ndsPrice[<%=i%>]=<%=priceNDS%>;
<%
	  %>labels[<%=i%>]='<%=ename%>';
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
<div id="chartContainer" style="width: 100%;" align="center" >                                                                                                                                                
<canvas id="bar-chart-grouped" style="width: 100%;"></canvas>
</div>                                                                                                                                       
</body>
<script type="text/javascript">
var ctx = document.getElementById('bar-chart-grouped').getContext('2d');
document.getElementById('bar-chart-grouped').style.height = labels.length * 120 + 'px';

new Chart(ctx, {
    type: 'horizontalBar',
    data: {
      labels: labels,
      datasets: [
        {
          label: "Остатки на <%=since%>: <%=amount1%> т   ",
		  xAxisID: 'A',
		  position: 'bottom',
		  fontSize: 26,
          backgroundColor: "#c24642",
		  datalabels: {	align: 'end',	anchor: 'end'},
          data: startRests
        },
        {
          label: "Остатки на <%=till%>: <%=amount2%> т   ",
		  xAxisID: 'A',
          backgroundColor: "#7f6084",
		  datalabels: {	align: 'end',	anchor: 'end'},
          data: endRests
        },
        {
          label: "Поступило за период с <%=since%> по <%=till%>: <%=inp%> т   ",
		  xAxisID: 'A',
          backgroundColor: "#64a333",
		  datalabels: {	align: 'end',	anchor: 'end'},
          data: input
        },
        {
          label: "Цена без НДС: <%=avgprice%> грн   ",
		  xAxisID: 'B',
          backgroundColor: "#add8e6",
		  datalabels: {	align: 'end',	anchor: 'end'},
          data: price
        },
        {
          label: "Цена c НДС: <%=avgpriceNDS%> грн   ",
		  xAxisID: 'B',
          backgroundColor: "#7998a1",
		  datalabels: {	align: 'end',	anchor: 'end'},
          data: ndsPrice
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
				text: "<%=goodsname%> " + "(Общий остаток: <%=pos%>," + " Общий долг: <%=neg%>)"
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
					ticks: {  max: <%=maxRest%>,  min: <%=minRest%>	}
				  }, {
					id: 'B',
					type: 'linear',
					position: 'bottom',
					ticks: {  max: <%=maxPrice%>,  min: <%=minPrice%>	}
				  }]
				},
			plugins: {
					datalabels: {
						color: 'black',
						display: function(context) {
							return context.dataset.data[context.dataIndex];
						},
						font: {
							size: 16,
							weight: 'bold'
						},
						formatter: Math.round
					},
					chartJsPluginBarchartBackground: {
							color: '#fcf09d',
							mode: 'odd'
					}
				},
        tooltips: {
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