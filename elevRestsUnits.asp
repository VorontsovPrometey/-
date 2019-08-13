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
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js"></script>
</head>
<%
    WriteStyle();
    // дата
    var s = '' + Request.ServerVariables('Request_Method');
    var goods = ''
    var till = new Date();
    var keeperType = '';
    var keeper = '';
    var grouping = '';
    if ((s.indexOf('POST') >= 0) && ('' + Request.Form("till") != 'undefined')) {
        till = parseDate("" + Request.Form("till"));
    } else {
        till = '';
    }
    var since = new Date();
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
    if ((s.indexOf('POST') >= 0) && ('' + Request.Form("keeper") != 'undefined')) {
        keeper = '' + Request.Form("keeper");
    }
    if ((s.indexOf('POST') >= 0) && ('' + Request.Form("grouping") != 'undefined')) {
        grouping = '' + Request.Form("grouping");
    }
    var psince = 'null'
    var ptill = 'null'
    var pgoods = 'null'
    var ptype = 'null'
    var pkeeper = 'null'
    var pgrouping = 'null'
    if (goods != '') { pgoods = "'" + goods + "'" };
    if (since != '') { psince = "'" + dateToSQL(since) + "'" };
    if (till != '') { ptill = "'" + dateToSQL(till) + "'" };
    if (keeperType != '') { ptype = "'" + keeperType + "'" };
    if (keeper != '') { pkeeper = "'" + keeper + "'" };
    if (grouping != '') { pgrouping = "'" + grouping + "'" };

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
    var amountplus = '';
    var sks = '';
    var avgprice = '';
    var avgpriceNDS = '';

    // выполняем и запоминаем
    var conn = null;
    var sql = "exec repElevatorsRestsUnits " + psince + "," + ptill + "," + pgoods + "," + pkeeper + "," + ptype + ",-43," + pgrouping;
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
            amountplus = 1 * rs('amountplus').value;
            inp = 1 * rs('inp').value;
            outp = 1 * rs('outp').value;
            sks = Math.round(amountplus != 0 ? 1 * rs('sks').value / amountplus : 0);
            avgprice = 1 * rs('avgprice').value;
            avgpriceNDS = 1 * rs('avgpriceNDS').value;
        };
%>
<body>
    <form name="criteria" class="form2" action="elevRestsUnits.asp" method="POST">
        <fieldset class="fieldset">
            с&nbsp;<input class="date" type="Text" name="since" size="5" maxlength="10" value="<%=dateToStr(since) %>">
            по&nbsp;<input class="date" type="Text" name="till" size="5" maxlength="10" value="<%=dateToStr(till) %>">
            <br>
            культура&nbsp;<select class="select" name="goods" id='crop' onblur="myBlur(this.id)" ondblclick="myBlur(this.id)" onwheel="wheelChangecrop()" onclick="myClick(this.id)">
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
            хранитель&nbsp;<select class="select" name="keeper" id="idKeeper" onblur="myBlur(this.id)" ondblclick="myBlur(this.id)" onwheel="wheelChangeidKeeper()" onclick="myClick(this.id)">
                <br>
                <%
      rs = rs.NextRecordset;
      while (!rs.eof) {
                %><option value="<%=rs(0).value%>" <% if (rs(0).value==keeper){%>selected<%}%>><%=rs(2).value%></option>
                <%
          rs.MoveNext();
      };
                %>
            </select><br>
            группировка&nbsp;<select class="select" name="grouping" id="idGrouping" onblur="myBlur(this.id)" ondblclick="myBlur(this.id)" onwheel="wheelChangeidGrouping()" onclick="myClick(this.id)">
                <br>
                <%
      rs = rs.NextRecordset;
      while (!rs.eof) {
                %><option value="<%=rs(0).value%>" <% if (rs(0).value==grouping){%>selected<%}%>><%=rs(1).value%></option>
                <%
          rs.MoveNext();
      };
                %>
            </select><br>
            &nbsp;<input name="go" type="submit" value="пересчитать" class="button1" />
        </fieldset>
    </form>
    <script type="text/javascript"> //Начало графиков//////////////////////////////////////////////////////////////////////////////////////
            var barsCount = 8;
            var chartData = new Array();
            for (var ind = 0; ind <= barsCount; ind++) { chartData[ind] = new Array(); }
<%
                rs=rs.NextRecordset;
            var i = 0;
            var sumMeshki = 0;
            var sumBags = 0;
            while (!rs.eof) {
                var ss = rs('avgprice').value != 0 ? Math.round(1.0 * rs('avgprice').value) : 0;
                var priceNDS = rs('avgpriceNDS').value != 0 ? Math.round(1.0 * rs('avgpriceNDS').value) : 0;

                var sumMeshkiCurrent = rs('units1').value != 0 ? (1.0 * rs('units1').value / rs('avgprice').value) : 0;
                var sumBagsCurrent = rs('units2').value != 0 ? (1.0 * rs('units2').value / rs('avgprice').value) : 0;
                sumMeshki += Math.round(sumMeshkiCurrent * 1000) / 1000;
                sumBags += Math.round(sumBagsCurrent * 1000) / 1000;
	  %> chartData[0][<%=i %>]='<%=rs('elevatorname').value%>';
<%
	  %> chartData[1][<%=i %>]=<%=(1.0 * rs('amount1').value).formatMoney(3, '.', '') %>;
<%
	  %> chartData[2][<%=i %>]=<%=(1.0 * rs('amount2').value).formatMoney(3, '.', '') %>;
<%
	  %> chartData[3][<%=i %>]=<%=(1.0 * rs('inp').value).formatMoney(3, '.', '') %>;
<%
	  %> chartData[4][<%=i %>]=<%=(1.0 * rs('outp').value).formatMoney(3, '.', '') %>;
<%
	  %> chartData[5][<%=i %>]=<%=ss %>;
<%
	  %> chartData[6][<%=i %>]=<%=priceNDS %>;
<%
	  %> chartData[7][<%=i %>]=<%=sumMeshkiCurrent.formatMoney(3, '.', '') %>;
<%
	  %> chartData[8][<%=i %>]=<%=sumBagsCurrent.formatMoney(3, '.', '') %>;
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
//  Added 050719 begin. //////////////////////////////////////
    var arrcrop = new Array();
    var arridKeeper = new Array();
    var arridGrouping = new Array();

    $(document).ready(function () {
        $('select#crop option').each(function (index, element) {
            arrcrop.push($(this).val());
        });

        $('select#idKeeper option').each(function (index, element) {
            arridKeeper.push($(this).val());
        });

        $('select#idGrouping option').each(function (index, element) {
            arridGrouping.push($(this).val());
        });
    });

    function myClick(idElem) {
        if (idElem === 'crop')
            $('#' + idElem).prop('size', arrcrop.length);
        else if (idElem === 'idKeeper')
            $('#' + idElem).prop('size', arridKeeper.length);
        else
            $('#' + idElem).prop('size', arridGrouping.length);
        $('#' + idElem).css('overflow-y', 'hidden');
    };

    function myBlur(idElem) {
        $('#' + idElem).prop('size', 1);
    };

    function wheelChangeidKeeper(e) {
        e = e || window.event;
        var delta = e.deltaY;
        var currentIndex = arridKeeper.indexOf($('#idKeeper').val());
        if (delta < 0 && currentIndex > 0)
            $('#idKeeper').val(arridKeeper[currentIndex - 1]);
        else if (delta > 0 && currentIndex < arridKeeper.length - 1)
            $('#idKeeper').val(arridKeeper[currentIndex + 1]);
        e.preventDefault ? e.preventDefault() : (e.returnValue = false);
    };

    function wheelChangecrop(e) {
        e = e || window.event;
        var delta = e.deltaY;
        var currentIndex = arrcrop.indexOf($('#crop').val());
        if (delta < 0 && currentIndex > 0)
            $('#crop').val(arrcrop[currentIndex - 1]);
        else if (delta > 0 && currentIndex < arrcrop.length - 1)
            $('#crop').val(arrcrop[currentIndex + 1]);
        e.preventDefault ? e.preventDefault() : (e.returnValue = false);
    };

    function wheelChangeidGrouping(e) {
        e = e || window.event;
        var delta = e.deltaY;
        var currentIndex = arridGrouping.indexOf($('#idGrouping').val());
        if (delta < 0 && currentIndex > 0)
            $('#idGrouping').val(arridGrouping[currentIndex - 1]);
        else if (delta > 0 && currentIndex < arridGrouping.length - 1)
            $('#idGrouping').val(arridGrouping[currentIndex + 1]);
        e.preventDefault ? e.preventDefault() : (e.returnValue = false);
    };
    //  Added 050719 end. //////////////////////////////////////

    var ctx = document.getElementById('bar-chart-grouped').getContext('2d');
    document.getElementById('bar-chart-grouped').style.height = (chartData[0].length * 110 + 200) + 'px';

    var maxRestn = Math.round((Math.max(Math.max(...chartData[1], ...chartData[2], ...chartData[3], ...chartData[7], ...chartData[8]), Math.abs(Math.min(...chartData[1], ...chartData[2], ...chartData[3], ...chartData[7], ...chartData[8]))) *115) / 100);    //было *115
    var maxPricen = Math.round((Math.max(Math.max(...chartData[5], ...chartData[6]), Math.abs(Math.min(...chartData[5], ...chartData[6]))) * 115) / 100);

    var totalrest = 0;
    var debt = 0;

    for (var i = 0; i < chartData[2].length; i++) {
        if (chartData[2][i] > 0) totalrest += chartData[2][i];
        if (chartData[2][i] < 0) debt += chartData[2][i];
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
                    label: " - в.т.ч. Мешки: <%=sumMeshki%> т",
                    xAxisID: 'A',
                    backgroundColor: "#1d223d",
                    datalabels: { align: 'end', anchor: 'end' },
                    data: chartData[7]
                },
                {
                    label: " - в.т.ч. Беги: <%=sumBags%> т",
                    xAxisID: 'A',
                    backgroundColor: "#572ad4",
                    datalabels: { align: 'end', anchor: 'end' },
                    data: chartData[8]
                },
                {
                    label: "Поступило за период с <%=since%> по <%=till%>: <%=inp%> т   ",
                    xAxisID: 'A',
                    backgroundColor: "#64a333",
                    datalabels: { align: 'end', anchor: 'end' },
                    data: chartData[3]
                },
                {
                    label: "Реализовано(отгружено) за период с <%=since%> по <%=till%>: <%=outp%> т   ",
                    xAxisID: 'A',
                    backgroundColor: "#e8ea00",
                    datalabels: { align: 'end', anchor: 'end' },
                    data: chartData[4]
                },
                {
                    label: "Цена без НДС: <%=avgprice%> грн   ",
                    xAxisID: 'B',
                    backgroundColor: "#add8e6",
                    datalabels: { align: 'end', anchor: 'end' },
                    data: chartData[5]
                },
                {
                    label: "Цена c НДС: <%=avgpriceNDS%> грн   ",
                    xAxisID: 'B',
                    backgroundColor: "#7998a1",
                    datalabels: { align: 'end', anchor: 'end' },
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
                    ticks: { max: maxRestn, min: -maxRestn }
                }, {
                    id: 'B',
                    type: 'linear',
                    position: 'bottom',
                    ticks: { max: maxPricen, min: -maxPricen }
                }]
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
