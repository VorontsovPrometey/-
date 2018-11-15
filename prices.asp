<%@ LANGUAGE="JScript" CODEPAGE="1251" %>
<% 
Response.Expires = -1 
Session.Timeout = 600
Server.ScriptTimeOut = 600 
%>
<!--  #include file="connstr.inc" -->
<%
function add(key,value){this.key=key; this.value=value;}
function addelev(key,value,sequence){this.key=key; this.value=value; this.sequence=sequence;}
function addcell(elevator,culture,price1,price2,price3,price4,price11,price12,ch1,ch2,ch3,ch4,ch11,ch12)
{
  this.elevator=elevator; this.culture=culture;
  this.price1=price1;this.price2=price2;this.price3=price3;this.price4=price4;this.price11=price11;this.price12=price12;
  this.ch1=ch1;this.ch2=ch2;this.ch3=ch3;this.ch4=ch4;this.ch11=ch11;this.ch12=ch12;
}

var culture=new Array();
var elevator=new Array();
var cell=new Array();
var lasts=100;
var conn=null;
var sql="exec graingreen..pricesactualgrid2";
var since;
var qcol=0;
var qelev=0;
var qcell=0;
  try {
    conn=getConnection(false);
    conn.CommandTimeout=600;
    var rs=conn.Execute(sql);
    if (!rs.eof) {since=''+rs(1); lasts=1*rs(2);};
    rs=rs.NextRecordset;
    while (!rs.eof) 
    {
      culture[qcol]=new add(1*rs(0),''+rs(1));
      qcol++;
      rs.MoveNext();
    };
    rs=rs.NextRecordset;
    while (!rs.eof) 
    {
      elevator[qelev]=new addelev(1*rs(0),''+rs(1),1*rs(2));
      qelev++;
      rs.MoveNext();
    };

    rs=rs.NextRecordset;
    while (!rs.eof) 
    {
      cell[qcell]=new addcell(1*rs(1),1*rs(2),rs(3).value,rs(4).value,rs(5).value,rs(6).value,rs(7).value,rs(8).value,
											  rs(9).value,rs(10).value,rs(11).value,rs(12).value,rs(13).value,rs(14).value);
      qcell++;
      rs.MoveNext();
    };


%>
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<%
WriteStyle(); 
%>
<style>
.p1 {background-color:#fffbf0;}
.p2 {background-color:#C0C0C0;}
.p3 {background-color:#a6caf0;}

.lineNik1 {background-color:#ffffd8;}
.lineNik2 {background-color:#ffff89;}
.lineNik3 {background-color:#f6f647;}

.lineKir1 {background-color:#ceffce;}
.lineKir2 {background-color:#94ff94;}
.lineKir3 {background-color:#69e169;}

.lineZap1 {background-color:#ffd9d9;}
.lineZap2 {background-color:#ffaeae;}
.lineZap3 {background-color:#ff8888;}

.c1 {
	text-align : right; 
	color : #ff0000;
	}

.borderbottom1 {
  background-color:#ffc3c3;
}	
	
#prices {width: 100%}
#transit {width: 45%; float: left;}
#recast {width: 45%; float: left;}
#valcon {width: 100%; float: left;}
#manager {width: 45%; float:left;}
#car {width: 45%; float: right;}
</style>
</HEAD>
<BODY>
<% WriteHeader(); %>
<div id="container">
<div id="prices">
<h2>���������� ���� � <%=dateTimeToStr(since)%></h2>
���������: <%=dateTimeToStr(new Date())%>
<table name="tbl" id="tbl" class="grid" width="100%">
<colgroup>
<col class="string" width="10%"/>
<col class="digit" width="5%"/>
<%
  for(var i=0;i<qcol;i++)
  {
    %><col class="digit" width="<%=85/qcol%>%"/>
<%
  }
%>
</colgroup>
<thead>
<tr>
<th>���������</th>
<th>����</th>
<%
  for(var i=0;i<qcol;i++)
  {
    %><th><%=culture[i].value%></th>
<%
  }
%>
</tr>
</thead>
<tbody>
<%
function getv(e,p,c)
{
  var res = {v:'',c:0};
  for(var i=0;i<qcell;i++)
  {
    if (cell[i].elevator==e)
    {
      for(var j=i;j<qcell;j++)
      {
        if (cell[j].elevator!=e) break;
        if (cell[j].culture>c) break;
        if (cell[j].culture==c)
        {
          if (p==1) return {v:cell[j].price1,c:cell[j].ch1};
          else if(p==2) return {v:cell[j].price2,c:cell[j].ch2};
          else if (p==3) return {v:cell[j].price3,c:cell[j].ch3};
          else if (p==4) return {v:cell[j].price4,c:cell[j].ch4};
          else if (p==11) return {v:cell[j].price11,c:cell[j].ch11};
          else if (p==12) return {v:cell[j].price12,c:cell[j].ch12};
          break;
        }
      }
      break;
    } 
    else
      if (cell[i].elevator>e) break;
  }
  return res;
}

  for(var e=0;e<qelev;e++)
  {
  	var priceInd = 0;
    for (var p=1;p<=4;p++)
    {
      var skip = true;
      for(var c=0;c<qcol;c++)
      {
        var v=getv(elevator[e].key,p,culture[c].key);
        if (v.v>0) {skip=false; priceInd=priceInd==0?p:-1; break;}
      }

      if (!skip) {
			if (elevator[e].sequence < 100) 						 {%><tr class="lineNik<%=p%>"><%
			}	else	if (elevator[e].sequence >= 100 && elevator[e].sequence < 200){%><tr class="lineKir<%=p%>"><%
			}	else	if (elevator[e].sequence >= 200)		 {%><tr class="lineZap<%=p%>"><%
			}%>
			<td><%=priceInd==p?elevator[e].value:''%></td>
			<td>���� <%=p%></td><%
			  for(var c=0;c<qcol;c++)
			  {
				var v=getv(elevator[e].key,p,culture[c].key);
				var cl = v.c==1?"c1":"digit";
			%>	<td class="<%=cl%>"><%=v.v%></td><%
			  }
    %>	</tr>
<%    }
    }
  }
%>
</tbody>
</table>
</div>
<div id="transit">
<h2>�������</h2>
<table>
<table name="ttransit" id="ttransit" class="grid" width="100%">
<colgroup>
<col class="string" width="25%"/>
<col class="string" width="20%"/>
<col class="string" width="15%"/>
<col class="digit" width="10%"/>
<col class="digit" width="10%"/>
<col class="digit" width="10%"/>
</colgroup>
<thead>
<tr>
<th>����</th>
<th>�������</th>
<th>��������</th>
<th>���� 1</th>
<th>���� 2</th>
<th>����������</th>
</tr>
</thead>
<tbody>
<%
    rs=rs.NextRecordset;
    while (!rs.eof) 
    {
%><tr>
		<td class="border_bottom"><%=rs("portname").value%></td>
		<td><%=rs("tradername").value%></td>
		<td><%=rs("culturename").value%></td>
		<td class="digit"><%=rs("price1").value%></td>
		<td class="digit"><%=rs("price2").value%></td>
		<td class="digit"><%=rs("amount").value%></td><%
%></tr><%
      rs.MoveNext();
    };
%>
</tbody>
</table>
</div>
<div id="valcon">
<h2>�������� ���������</h2>
<table>
<table name="tvalcon" id="tvalcon"  border="1" bordercolor="#000000" cellspacing="0" cellpadding="1" width="100%">
<colgroup>
<col class="string" width="10%"/>
<col class="string" width="15%"/>
<col class="string" width="10%"/>
<col class="digit" width="10%"/>
<col class="digit" width="10%"/>
<col class="digit" width="10%"/>
<col class="digit" width="10%"/>
<col class="digit" width="10%"/>
</colgroup>
<thead>
<tr>
<th>����</th>
<th>�������</th>
<th>��������</th>
<th>�����</th>
<th>���� 1</th>
<th>���� 2</th>
<th>���� 3</th>
<th>�������� ����</th>
<th>�������� ����</th>
</tr>
</thead>
<tbody>
<%
    rs=rs.NextRecordset;
    while (!rs.eof) 
    {
%><tr class="<%=rs("kol").value==0 || rs("kol").value==null?'borderbottom1':''%>">
		<td><%=rs("portname").value%></td>
		<td><%=rs("tradername").value%></td>
		<td><%=rs("culturename").value%></td>
		<td><%=dateToStr(rs("since").value)%> - <p class="c1"><%=dateToStr(rs("till").value)%></p></td>
		<td class="digit"><%=rs("price1").value%></td>
		<td class="digit"><%=rs("price2").value%></td>
		<td class="digit"><%=rs("price3").value%></td>
		<td class="digit"><%=rs("kol").value%></td>
		<td class="digit"><%=rs("priceval").value%></td><%
%></tr><%
      rs.MoveNext();
    };
%>
</tbody>
</table>
</div>

<div id="recast">
<h2>�����������</h2>
<table>
<table name="trecast" id="trecast" class="grid" width="100%">
<colgroup>
<col class="string" width="25%"/>
<col class="string" width="25%"/>
<col class="string" width="20%"/>
<col class="digit" width="10%"/>
<col class="digit" width="10%"/>
<col class="digit" width="10%"/>
</colgroup>
<thead>
<tr>
<th>�����</th>
<th>�����������</th>
<th>��������</th>
<th>���� 1</th>
<th>���� 2</th>
<th>����������</th>
</tr>
</thead>
<tbody>
<%
    rs=rs.NextRecordset;
    while (!rs.eof) 
    {
%><tr><td><%=rs("portname").value%></td><td><%=rs("tradername").value%></td><td><%=rs("culturename").value%></td><td class="digit"><%=rs("price1").value%></td><td class="digit"><%=rs("price2").value%></td>
<td class="digit"><%=rs("amount").value%></td><%
%></tr><%
      rs.MoveNext();
    };
%>
</tbody>
</table>
</div>

</div> <!--end container-->
<%
  } catch(e) {
    Response.Write(e.message+'; ������ ���������� ������� ');
  }
%>
</BODY>
</HTML>
<script language="javascript">
setInterval("location.reload(true);",1000*60*2);
<% if (lasts<=2) {%>alert("����� ����!");<%;} %>
</script>
