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
var till=new Date();
var goodsType='1';
var count='';

if ((s.indexOf('POST')>=0)&&(''+Request.Form("till")!='undefined')) {
  till=parseDate(""+Request.Form("till"));
} else {
  till='';
}

if ((s.indexOf('POST')>=0)&&(''+Request.Form("goodsType")!='undefined')) {
  goodsType=''+Request.Form("goodsType");
}

if ((s.indexOf('POST')>=0)&&(''+Request.Form("Count")!='undefined')) {
  count=''+Request.Form("Count");
}

var ptill='null'
var pgoodsType='null'
    
if (till!='') {ptill="'"+dateToSQL(till)+"'"};
if (goodsType!='') {pgoodsType="'"+goodsType+"'"};
    
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

// выполняем и запоминаем
  var conn=null;
  var sql="exec repElevatorsRestsFer "+ptill+","+ pgoodsType;
  try {
    conn=getConnection(false);
    conn.CommandTimeout=160;
    var rs=conn.Execute(sql);
    if (!rs.eof) 
    {
        till = rs('till').value;
        goodsType = 1 * rs('goodsType').value;
        count=1 * rs('Count').value;
    };
%>
<body>
<form name="criteria" class="form2" action="elevFerRests.asp" method="POST">
<fieldset class="fieldset">
на &nbsp;<input class="date" type=Text name="till" size=5 maxlength=10 value="<%=dateToStr(till) %>"> <br>
тип товара&nbsp;<select class="select" name="goodsType" id='crop'> <br>
<%
    rs=rs.NextRecordset;
    while (!rs.eof) 
    {
%><option value="<%=rs(0).value%>" <% if (rs(0).value==goodsType){%>selected<%}%> ><%=rs(1).value%></option>
<%
      rs.MoveNext();
    };
%>
</select><br>
&nbsp;<input name="go" type="submit" value="пересчитать" class="button1" />
</fieldset>
</form>

<script type="text/javascript">
var barsCount = 50;
var chartData = new Array();
for (var ind = 0; ind <= barsCount; ind++) {	chartData[ind] = new Array();}
<%
    rs=rs.NextRecordset;    
    var i=0;
	while (!rs.eof) 
    {
	  %>chartData[0][<%=i%>]='<%=rs('elevatorname').value%>';
<%
      %>chartData[1][<%=i%>]='<%=rs('goodsname').value%>';
<%
    %> chartData[2][<%=i %>]=<%=(1.0 * rs('skk').value).formatMoney(3, '.', '')%>;

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
document.getElementById('bar-chart-grouped').style.height = (chartData[0].length * 110 + 200) + 'px';

var maxRestn = Math.round((Math.max(Math.max(...chartData[1], ...chartData[2], ...chartData[3]), Math.abs(Math.min(...chartData[1], ...chartData[2], ...chartData[3]))) * 115) / 100);



new Chart(ctx, {
    type: 'horizontalBar',
    data: {
      labels: chartData[0],
      datasets: [
        {
          label: "defefe",
		  xAxisID: 'A',
          backgroundColor: "#c24642",
		  datalabels: {	align: 'end',	anchor: 'end'},
          data: chartData[1]
        },
        {
          label: "yyyy",
		  xAxisID: 'A',
          backgroundColor: "#7f6084",
		  datalabels: {	align: 'end',	anchor: 'end'},
          data: chartData[2]
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
            text: "vvvvvvvvv"
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
					ticks: {  max: maxRestn,  min: -maxRestn	}
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
			titleFontSize: 18,
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
