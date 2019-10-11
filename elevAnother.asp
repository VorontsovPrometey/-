<%@  language="JScript" codepage="1251" %>
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
    <meta http-equiv="Pragma" content="no-cache">
    <script type="text/javascript" src="chart.js"></script>
    <script type="text/javascript" src="chartjs-plugin-datalabels.min.js"></script>
    <script type="text/javascript" src="chartjs-plugin-barchart-background.js"></script>
</head>
<%
    WriteStyle();
    // дата
    var s = '' + Request.ServerVariables('Request_Method');
    var goods = '';
    var since = new Date();
    var till = new Date();
    var keeperType = '0';

    if ((s.indexOf('POST') >= 0) && ('' + Request.Form("till") != 'undefined')) {
        till = parseDate("" + Request.Form("till"));
    } else {
        till = '';
    }

    if ((s.indexOf('POST') >= 0) && ('' + Request.Form("since") != 'undefined')) {
        since = parseDate("" + Request.Form("since"));
    } else {
        since = '';
    }
    if ((s.indexOf('POST') >= 0) && ('' + Request.Form("goods") != 'undefined')) {
        goods = '' + Request.Form("goods");
    }
    if ((s.indexOf('POST') >= 0) && ('' + Request.Form("keeperType") != 'undefined')) {
        keeperType = '' + Request.Form("keeperType");
    }

    var psince = 'null'
    if (since != '') { psince = "'" + dateToSQL(since) + "'" };

    var ptill = 'null'
    if (till != '') { ptill = "'" + dateToSQL(till) + "'" };

    var pgoods = 'null'
    if (goods != '') { pgoods = "'" + goods + "'" };

    var pkeeperType = 'null'
    if (keeperType != '') { pkeeperType = "'" + keeperType + "'" };


    Number.prototype.formatMoney = function (c, d, t) {
        var n = this,
            c = isNaN(c = Math.abs(c)) ? 2 : c,
            d = d == undefined ? "." : d,
            t = t == undefined ? "," : t,
            s = n < 0 ? "-" : "",
            i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "",
            j = (j = i.length) > 3 ? j % 3 : 0;
        return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
    };
    var goodsname = '';
    var goods = '';
    var amount1 = '';
    var amount2 = '';

    // выполняем и запоминаем
    var conn = null;
    var sql = "exec repStoreKeeperAnother " + psince + "," + ptill + "," + pkeeperType + "," + pgoods;
    try {
        conn = getConnection(false);
        conn.CommandTimeout = 160;
        var rs = conn.Execute(sql);
        if (!rs.eof) {
            goodsname = rs('goodsname').value;
            goods = rs('goods').value;
            since = rs('since').value;
            till = rs('till').value;
            amount1 = 1 * rs('amount1').value;
            amount2 = 1 * rs('amount2').value;
            keeperType = rs('keeperType').value;
            inp = 1 * rs('inp').value;
        };
%>
<body>
    <form name="criteria" class="form2" action="elevAnother.asp" method="POST">
        <fieldset class="fieldset">
            с&nbsp;<input class="date" type="Text" name="since" size="5" maxlength="10" value="<%=dateToStr(since) %>">
            по&nbsp;<input class="date" type="Text" name="till" size="5" maxlength="10" value="<%=dateToStr(till) %>">
            <br>
            культура&nbsp;<select class="select" name="goods" id='crop'>
                <br>
                <%
      rs = rs.NextRecordset;
      while (!rs.eof) {
                %><option value="<%=rs(0).value%>" <% if (rs(0).value==goods){%>selected<%}%>><%=rs(1).value%></option>
                <%
          rs.MoveNext();
      };
                %>
            </select><br>
            хранители&nbsp;<select class="select" name="keeperType" id="idKeeper">
                <br>
                <%
      rs = rs.NextRecordset;
      while (!rs.eof) {
                %><option value="<%=rs(0).value%>" <% if (rs(0).value==keeperType){%>selected<%}%>><%=rs(1).value%></option>
                <%
          rs.MoveNext();
      };
                %>
            </select><br>
            
            &nbsp;<input name="go" type="submit" value="пересчитать" class="button1" />
        </fieldset>
    </form>
    <script type="text/javascript">
            var barsCount = 3;
            var chartData = new Array();
            for (var ind = 0; ind <= barsCount; ind++) { chartData[ind] = new Array(); }
<%
                rs=rs.NextRecordset;
            var i = 0;
            while (!rs.eof) {

	  %> chartData[0][<%=i %>]='<%=rs('elevatorname').value%>';
<%
	  %> chartData[1][<%=i %>]=<%=(1.0 * rs('amount1').value).formatMoney(3, '.', '') %>;
<%
	  %> chartData[2][<%=i %>]=<%=(1.0 * rs('amount2').value).formatMoney(3, '.', '') %>;
<%
	  %> chartData[3][<%=i %>]=<%=(1.0 * rs('inp').value).formatMoney(3, '.', '') %>;
<%
                    i++;
                rs.MoveNext();
            };
        } catch (e) {
            Response.Write(e.message + '; Ошибка выполнения запроса: ' + sql);
        }
%>
    </script>
    <div id="chartContainer" style="width: 100%;" align="center">
        <canvas id="bar-chart-grouped" style="width: 100%;"></canvas>
    </div>
</body>
<script type="text/javascript">

var ctx = document.getElementById('bar-chart-grouped').getContext('2d');
    document.getElementById('bar-chart-grouped').style.height = (chartData[0].length * 110 + 200) + 'px';

    var maxRestn = Math.round((Math.max(Math.max(...chartData[1], ...chartData[2], ...chartData[3])) * 115) / 100);

    new Chart(ctx, {
        type: 'horizontalBar',
        data: {
            labels: chartData[0],
            datasets: [
                {
                    label: "Остатки на <%=since%>: <%=amount1%> т   ",
                    xAxisID: 'A',
                    backgroundColor: "#c24642",
                    datalabels: { align: 'end', anchor: 'end' },
                    data: chartData[1]
                },
                {
                    label: "Остатки на <%=till%>: <%=amount2%> т   ",
                    xAxisID: 'A',
                    backgroundColor: "#7f6084",
                    datalabels: { align: 'end', anchor: 'end' },
                    data: chartData[2]
                },
                {
                    label: "Поступило за период с <%=since%> по <%=till%>: <%=inp%> т   ",
                    xAxisID: 'A',
                    backgroundColor: "#64a333",
                    datalabels: { align: 'end', anchor: 'end' },
                    data: chartData[3]
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
                text: "<%=goodsname%>" 
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
                    ticks: { max: maxRestn }
                }
                ]
            },
            plugins: {
                datalabels: {
                    color: 'black',
                    display: function (context) {
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
                    label: function (tooltipItem, data) {
                        var label = data.datasets[tooltipItem.datasetIndex].label.split(":")[0] + ': ' + tooltipItem.xLabel;
                        return label;
                    }
                }
            }
        }
    });

</script>
</html>
