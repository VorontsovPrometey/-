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
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js"></script>
</head>
<%
WriteStyle(); 
// дата
var s=''+Request.ServerVariables('Request_Method');
var goods=''
var till=new Date();
var keeperType='';
var keeper='';
var grouping='';
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
if ((s.indexOf('POST')>=0)&&(''+Request.Form("grouping")!='undefined')) {
  grouping=''+Request.Form("grouping");
}
var psince='null'
var ptill='null'
var pgoods='null'
var ptype='null'
var pkeeper='null'
var pgrouping='null'
if (goods!='') {pgoods="'"+goods+"'"};
if (since!='') {psince="'"+dateToSQL(since)+"'"};
if (till!='') {ptill="'"+dateToSQL(till)+"'"};
if (keeperType!='') {ptype="'"+keeperType+"'"};
if (keeper!='') {pkeeper="'"+keeper+"'"};
if (grouping!='') {pgrouping="'"+grouping+"'"};

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
  var avgprice='';
  var avgpriceNDS='';

// выполняем и запоминаем
  var conn=null;
  var sql="exec repElevatorsRests "+psince+","+ptill+","+pgoods+","+pkeeper+","+ptype+",-43,"+pgrouping;
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
	  outp=1*rs('outp').value;
      sks=Math.round(amountplus!=0?1*rs('sks').value/amountplus:0);
      avgprice=1*rs('avgprice').value;
	  avgpriceNDS=1*rs('avgpriceNDS').value;
    };
%>
<body>
<form name="criteria" class="form2" action="elev.asp" method="POST">
<fieldset class="fieldset">
с&nbsp;<input class="date" type=Text name="since" size=5 maxlength=10 value="<%=dateToStr(since) %>">
по&nbsp;<input class="date" type=Text name="till" size=5 maxlength=10 value="<%=dateToStr(till) %>"> <br>
культура&nbsp;<select class="select" name="goods" id='crop'> <br>
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
группировка&nbsp;<select class="select" name="grouping" > <br>
<%
    rs=rs.NextRecordset;
    while (!rs.eof) 
    {
%><option value="<%=rs(0).value%>" <% if (rs(0).value==grouping){%>selected<%}%> ><%=rs(1).value%></option>
<%
      rs.MoveNext();
    };
%>
</select><br>
&nbsp;<input name="go" type="submit" value="пересчитать" class="button1" />
</fieldset>  
</form>
<div style='margin-left: 30%;'>
  <input type='radio' id='vse' name="c" onchange="exe()" checked=""><label for="vse" style='font-size: 25px; margin-right: 40px;'>Все</label>
  <input type='radio' id='zerno' name="c" onchange="exe()"><label for="zerno" style='font-size: 25px; margin-right: 40px;'>Зерно</label>
  <input type='radio' id='fertilizer' name="c" onchange="exe()"><label for="fertilizer" style='font-size: 25px; margin-right: 40px;'>Удобрения</label>
  <input type='radio' id='dizel' name="c" onchange="exe()"><label for="dizel" style='font-size: 25px; margin-right: 40px;'>Дизтопливо</label>
</div>
<script type="text/javascript">
var barsCount = 6;
var chartData = new Array();
for (var ind = 0; ind <= barsCount; ind++) {	chartData[ind] = new Array();}
<%
    rs=rs.NextRecordset;    
    var i=0;
	while (!rs.eof) 
    {
      var ss = rs('avgprice').value!=0?Math.round(1.0*rs('avgprice').value):0;
	  var priceNDS = rs('avgpriceNDS').value!=0?Math.round(1.0*rs('avgpriceNDS').value):0;
	  %>chartData[0][<%=i%>]='<%=rs('elevatorname').value%>';
<%
	  %>chartData[1][<%=i%>]=<%=(1.0*rs('amount1').value).formatMoney(3, '.', '')%>;
<%
	  %>chartData[2][<%=i%>]=<%=(1.0*rs('amount2').value).formatMoney(3, '.', '')%>;
<%
	  %>chartData[3][<%=i%>]=<%=(1.0*rs('inp').value).formatMoney(3, '.', '')%>;
<%
	  %>chartData[4][<%=i%>]=<%=(1.0*rs('outp').value).formatMoney(3, '.', '')%>;
<%
	  %>chartData[5][<%=i%>]=<%=ss%>;
<%
	  %>chartData[6][<%=i%>]=<%=priceNDS%>;
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
<script>
    function exe(){
      if($("#zerno").prop("checked")) {
        //crop
        $('#crop option[value="{957D4230-1633-431B-B216-6F2FE7BEE262}"]').show();
        $('#crop option[value="{4F419C20-BF07-44C1-917A-6ACF737EBB21}"]').show();
        $('#crop option[value="{05207002-83C5-4F0A-BB27-14CCE15AA75C}"]').show();
        $('#crop option[value="{AAFCDB26-F98A-4635-A29D-5F611BFAD055}"]').show();
        $('#crop option[value="{557EEFFD-0EE1-44ED-AD4A-78F12DA44EAC}"]').show();
        $('#crop option[value="{1BC93D91-BCA0-460B-9874-719DE5554B6D}"]').show();
        $('#crop option[value="{79F5AA2E-49F2-4372-89FB-B770E39D70E7}"]').show();
        $('#crop option[value="{98A58A73-A5D4-44E4-B3AB-3BFEE8FDDFFD}"]').show();
        $('#crop option[value="{6657D554-F8F4-4173-A91B-DCA81C7EE5FE}"]').show();
        $('#crop option[value="{7340BDF2-0257-4E2E-AC9B-C2D30B647C56}"]').show();
        $('#crop option[value="{28A0663C-25AE-4946-8146-7A30AE03F6DE}"]').show();
        $('#crop option[value="{D1AE2497-92AF-4CB9-9ABC-C379DC80BF10}"]').show();
        $('#crop option[value="{C170702F-6C98-4F69-BA0A-1A1A769513B9}"]').show();
        $('#crop option[value="{3A606884-25A1-444A-A7C8-3D9D777DC264}"]').show();
        $('#crop option[value="{01DEE8D9-826A-4CD8-B63B-5A2BF21BEC53}"]').show();
        $('#crop option[value="{9B52A786-FD73-4FF4-84B6-87BBDF09C13D}"]').show();
        //fertilizer
        $('#crop option[value="{A4CCC7FD-2451-4309-A700-15D5CB4807C6}"]').hide();
        $('#crop option[value="{F543EB92-1D0C-48DA-8B6B-79988920FB1C}"]').hide();
        $('#crop option[value="{6FD52381-D7BD-4619-A31B-80B764E12322}"]').hide();
        $('#crop option[value="{E35800DA-E921-4E72-B86D-A362DE128360}"]').hide();
        $('#crop option[value="{302A305D-F640-4989-901A-A76FA9FD54FD}"]').hide();
        $('#crop option[value="{6B3764D8-E457-4A1E-868C-B398A84CE5D2}"]').hide();
        $('#crop option[value="{7669A139-1ED3-4623-B43D-E6944E4753FA}"]').hide();
        //dizel
        $('#crop option[value="{0A9C4C52-AA5F-4994-98D3-65ED0457F9F8}"]').hide();
      }
      else if($("#fertilizer").prop("checked")) {
        //crop
        $('#crop option[value="{957D4230-1633-431B-B216-6F2FE7BEE262}"]').hide();
        $('#crop option[value="{4F419C20-BF07-44C1-917A-6ACF737EBB21}"]').hide();
        $('#crop option[value="{05207002-83C5-4F0A-BB27-14CCE15AA75C}"]').hide();
        $('#crop option[value="{AAFCDB26-F98A-4635-A29D-5F611BFAD055}"]').hide();
        $('#crop option[value="{557EEFFD-0EE1-44ED-AD4A-78F12DA44EAC}"]').hide();
        $('#crop option[value="{1BC93D91-BCA0-460B-9874-719DE5554B6D}"]').hide();
        $('#crop option[value="{79F5AA2E-49F2-4372-89FB-B770E39D70E7}"]').hide();
        $('#crop option[value="{98A58A73-A5D4-44E4-B3AB-3BFEE8FDDFFD}"]').hide();
        $('#crop option[value="{6657D554-F8F4-4173-A91B-DCA81C7EE5FE}"]').hide();
        $('#crop option[value="{7340BDF2-0257-4E2E-AC9B-C2D30B647C56}"]').hide();
        $('#crop option[value="{28A0663C-25AE-4946-8146-7A30AE03F6DE}"]').hide();
        $('#crop option[value="{D1AE2497-92AF-4CB9-9ABC-C379DC80BF10}"]').hide();
        $('#crop option[value="{C170702F-6C98-4F69-BA0A-1A1A769513B9}"]').hide();
        $('#crop option[value="{3A606884-25A1-444A-A7C8-3D9D777DC264}"]').hide();
        $('#crop option[value="{01DEE8D9-826A-4CD8-B63B-5A2BF21BEC53}"]').hide();
        $('#crop option[value="{9B52A786-FD73-4FF4-84B6-87BBDF09C13D}"]').hide();
        //fertilizer
        $('#crop option[value="{A4CCC7FD-2451-4309-A700-15D5CB4807C6}"]').show();
        $('#crop option[value="{F543EB92-1D0C-48DA-8B6B-79988920FB1C}"]').show();
        $('#crop option[value="{6FD52381-D7BD-4619-A31B-80B764E12322}"]').show();
        $('#crop option[value="{E35800DA-E921-4E72-B86D-A362DE128360}"]').show();
        $('#crop option[value="{302A305D-F640-4989-901A-A76FA9FD54FD}"]').show();
        $('#crop option[value="{6B3764D8-E457-4A1E-868C-B398A84CE5D2}"]').show();
        $('#crop option[value="{7669A139-1ED3-4623-B43D-E6944E4753FA}"]').show();
        //dizel
        $('#crop option[value="{0A9C4C52-AA5F-4994-98D3-65ED0457F9F8}"]').hide();
      }
      else if($("#dizel").prop("checked")) {
        //crop
        $('#crop option[value="{957D4230-1633-431B-B216-6F2FE7BEE262}"]').hide();
        $('#crop option[value="{4F419C20-BF07-44C1-917A-6ACF737EBB21}"]').hide();
        $('#crop option[value="{05207002-83C5-4F0A-BB27-14CCE15AA75C}"]').hide();
        $('#crop option[value="{AAFCDB26-F98A-4635-A29D-5F611BFAD055}"]').hide();
        $('#crop option[value="{557EEFFD-0EE1-44ED-AD4A-78F12DA44EAC}"]').hide();
        $('#crop option[value="{1BC93D91-BCA0-460B-9874-719DE5554B6D}"]').hide();
        $('#crop option[value="{79F5AA2E-49F2-4372-89FB-B770E39D70E7}"]').hide();
        $('#crop option[value="{98A58A73-A5D4-44E4-B3AB-3BFEE8FDDFFD}"]').hide();
        $('#crop option[value="{6657D554-F8F4-4173-A91B-DCA81C7EE5FE}"]').hide();
        $('#crop option[value="{7340BDF2-0257-4E2E-AC9B-C2D30B647C56}"]').hide();
        $('#crop option[value="{28A0663C-25AE-4946-8146-7A30AE03F6DE}"]').hide();
        $('#crop option[value="{D1AE2497-92AF-4CB9-9ABC-C379DC80BF10}"]').hide();
        $('#crop option[value="{C170702F-6C98-4F69-BA0A-1A1A769513B9}"]').hide();
        $('#crop option[value="{3A606884-25A1-444A-A7C8-3D9D777DC264}"]').hide();
        $('#crop option[value="{01DEE8D9-826A-4CD8-B63B-5A2BF21BEC53}"]').hide();
        $('#crop option[value="{9B52A786-FD73-4FF4-84B6-87BBDF09C13D}"]').hide();
        //fertilizer
        $('#crop option[value="{A4CCC7FD-2451-4309-A700-15D5CB4807C6}"]').hide();
        $('#crop option[value="{F543EB92-1D0C-48DA-8B6B-79988920FB1C}"]').hide();
        $('#crop option[value="{6FD52381-D7BD-4619-A31B-80B764E12322}"]').hide();
        $('#crop option[value="{E35800DA-E921-4E72-B86D-A362DE128360}"]').hide();
        $('#crop option[value="{302A305D-F640-4989-901A-A76FA9FD54FD}"]').hide();
        $('#crop option[value="{6B3764D8-E457-4A1E-868C-B398A84CE5D2}"]').hide();
        $('#crop option[value="{7669A139-1ED3-4623-B43D-E6944E4753FA}"]').hide();
        //dizel
        $('#crop option[value="{0A9C4C52-AA5F-4994-98D3-65ED0457F9F8}"]').show();
      }
      else if($("#vse").prop("checked")) {
        //crop
        $('#crop option[value="{957D4230-1633-431B-B216-6F2FE7BEE262}"]').show();
        $('#crop option[value="{4F419C20-BF07-44C1-917A-6ACF737EBB21}"]').show();
        $('#crop option[value="{05207002-83C5-4F0A-BB27-14CCE15AA75C}"]').show();
        $('#crop option[value="{AAFCDB26-F98A-4635-A29D-5F611BFAD055}"]').show();
        $('#crop option[value="{557EEFFD-0EE1-44ED-AD4A-78F12DA44EAC}"]').show();
        $('#crop option[value="{1BC93D91-BCA0-460B-9874-719DE5554B6D}"]').show();
        $('#crop option[value="{79F5AA2E-49F2-4372-89FB-B770E39D70E7}"]').show();
        $('#crop option[value="{98A58A73-A5D4-44E4-B3AB-3BFEE8FDDFFD}"]').show();
        $('#crop option[value="{6657D554-F8F4-4173-A91B-DCA81C7EE5FE}"]').show();
        $('#crop option[value="{7340BDF2-0257-4E2E-AC9B-C2D30B647C56}"]').show();
        $('#crop option[value="{28A0663C-25AE-4946-8146-7A30AE03F6DE}"]').show();
        $('#crop option[value="{D1AE2497-92AF-4CB9-9ABC-C379DC80BF10}"]').show();
        $('#crop option[value="{C170702F-6C98-4F69-BA0A-1A1A769513B9}"]').show();
        $('#crop option[value="{3A606884-25A1-444A-A7C8-3D9D777DC264}"]').show();
        $('#crop option[value="{01DEE8D9-826A-4CD8-B63B-5A2BF21BEC53}"]').show();
        $('#crop option[value="{9B52A786-FD73-4FF4-84B6-87BBDF09C13D}"]').show();
        //fertilizer
        $('#crop option[value="{A4CCC7FD-2451-4309-A700-15D5CB4807C6}"]').show();
        $('#crop option[value="{F543EB92-1D0C-48DA-8B6B-79988920FB1C}"]').show();
        $('#crop option[value="{6FD52381-D7BD-4619-A31B-80B764E12322}"]').show();
        $('#crop option[value="{E35800DA-E921-4E72-B86D-A362DE128360}"]').show();
        $('#crop option[value="{302A305D-F640-4989-901A-A76FA9FD54FD}"]').show();
        $('#crop option[value="{6B3764D8-E457-4A1E-868C-B398A84CE5D2}"]').show();
        $('#crop option[value="{7669A139-1ED3-4623-B43D-E6944E4753FA}"]').show();
        //dizel
        $('#crop option[value="{0A9C4C52-AA5F-4994-98D3-65ED0457F9F8}"]').show();
      }
    }
  </script>                                                                                                                                      
</body>
<script type="text/javascript">
var ctx = document.getElementById('bar-chart-grouped').getContext('2d');
document.getElementById('bar-chart-grouped').style.height = (chartData[0].length * 110 + 200) + 'px';

var maxRestn = Math.round((Math.max(Math.max(...chartData[1], ...chartData[2], ...chartData[3]), Math.abs(Math.min(...chartData[1], ...chartData[2], ...chartData[3]))) * 115) / 100);
var maxPricen =Math.round((Math.max(Math.max(...chartData[5], ...chartData[6]), Math.abs(Math.min(...chartData[5], ...chartData[6]))) * 115) / 100);

var totalrest = 0;
var debt = 0;

for (var i = 0; i < chartData[2].length; i++)	{
	if	(chartData[2][i] > 0)	totalrest += chartData[2][i];
	if	(chartData[2][i] < 0)	debt += chartData[2][i];
}

totalrest = Math.round(totalrest * 1000) / 1000;
debt = Math.round(debt * 1000) / 1000;

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
          label: "Реализовано(отгружено) за период с <%=since%> по <%=till%>: <%=outp%> т   ",
		  xAxisID: 'A',
          backgroundColor: "#e8ea00",
		  datalabels: {	align: 'end',	anchor: 'end'},
          data: chartData[4]
        },
        {
          label: "Цена без НДС: <%=avgprice%> грн   ",
		  xAxisID: 'B',
          backgroundColor: "#add8e6",
		  datalabels: {	align: 'end',	anchor: 'end'},
          data: chartData[5]
        },
        {
          label: "Цена c НДС: <%=avgpriceNDS%> грн   ",
		  xAxisID: 'B',
          backgroundColor: "#7998a1",
		  datalabels: {	align: 'end',	anchor: 'end'},
          data: chartData[6]
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
				text: "<%=goodsname%> " + "(Общий остаток: " + totalrest + "  Общий долг: " + debt + ")"
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
				  }, {
					id: 'B',
					type: 'linear',
					position: 'bottom',
					ticks: {  max: maxPricen,  min: -maxPricen	}
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
