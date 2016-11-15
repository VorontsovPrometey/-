<SCRIPT RUNAT=Server LANGUAGE=JScript>
var oConn = new ActiveXObject("ADODB.Connection");

function TransformXSL(src,p,destination,xml) {
var oXSLT;
var oTemplate;
result='';
try {
  oXSLT = new ActiveXObject("Msxml2.FreeThreadedDOMDocument.6.0");
  oTemplate = new ActiveXObject("Msxml2.XSLTemplate.6.0");
} catch(e) {
  try {
   oXSLT = new ActiveXObject("Msxml2.FreeThreadedDOMDocument.3.0");
   oTemplate = new ActiveXObject("Msxml2.XSLTemplate.3.0");
   } catch(e) {
       alert('Нет поддержки XML 3.0 и 4.0');
       return;
   }
};
oXSLT.async = false;
oXSLT.load(src);
oTemplate.stylesheet = oXSLT;
delete oXSLT; oXSLT = null; CollectGarbage();
var processor = oTemplate.createProcessor();
processor.input = xml;

var nw=false;
if (p!=null) {
  var i=1;
  while (i<p.length) {
    if ((p[i-1]=='newwindow')&&(p[i]==true)) nw=true;
    processor.addParameter(p[i-1],p[i]); i++;i++;
  };
}
processor.transform();
if (nw==true) {
 result=processor.output;
 return result;
}
else {
 result=processor.output;
 return result;
};
}

function zamena(stf,old,rplc) {
var New='';
while (stf.indexOf(old)!=-1) {
var strt=stf.indexOf(old);
New+=stf.substring(0,strt);
New+=rplc;
stf=stf.substring(strt+old.length,stf.length);
} return New+stf;
}

function InitXSL(oXML, src) {
var oXSLT = new ActiveXObject("Msxml2.FreeThreadedDOMDocument.6.0");
oXSLT.async = false;
oXSLT.validateOnParse = false;
oXSLT.load(src);
return oXML.transformNode(oXSLT);
}

function execute(oConn,sql,ash) {
  if (ash==null) ash=new Array(Server.MapPath("table.xsl"));
  return execute2(oConn,sql,ash)
};

function execute2(oConn,sql,ash) {
var result='';
for (i=0;i<ash.length;i++) {if (ash[i]==null) ash[i]="table.xsl";};
var oRs;
try {
  oConn.CommandTimeout = 0;
  oRs=oConn.Execute(sql);
} catch(e) {
   return 'Ошибка выполнения запроса<br><em>'+e.description+'</em><p>'+sql
}
var xml=new ActiveXObject("MSXML2.DOMDocument.6.0");
var rsno=0;
while ((oRs!=null)&&(rsno<ash.length)) {
  if (oRs.State!=0) {
    oRs.save(xml,1);
    result+=InitXSL(xml, ash[rsno]);
  };
  oRs=oRs.NextRecordset;
  rsno++;
}
xml=null;
return result
}

function execute3(oConn,sql,sh,parm) {
var result='';
var oRs;
try {
  oConn.CommandTimeout = 0;
  oRs=oConn.Execute(sql);
} catch(e) {
   return 'Ошибка выполнения запроса<br><em>'+e.description+'</em><p>'+sql
}
var rsno=0;

var sxml='<?xml version="1.0" encoding="windows-1251" ?>'+
'<root><schema></schema>';

while (oRs!=null) {
  if (oRs.State!=0) {
    var levl=(oRs(oRs.fields.count-1).Name=='levl');
    var prevlevel=-1;
    var curlevel=-1;
    sxml+=('<rows'+rsno+'>');
    var recno=0;
    while (!oRs.eof) {
      recno++;
      if ((levl==false)) { // строки - row
        sxml+='<row ';
        recno++;
        for (i=0;i<oRs.fields.count;i++)
          if (oRs(i).value!=null) {
            s=''+oRs(i).value;
            s=zamena(s,'"','\'');
            sxml+=(oRs(i).Name+'="'+s+'" ');
          }
        sxml+='/>';
      } else 
      { // поля - элементы
        var nextlevel=1*oRs('levl');
        for (i=prevlevel;i>=nextlevel;i--) sxml+=('</a'+i+'>');
        curlevel=nextlevel;
        sxml+=('<a'+curlevel);
        if (curlevel==0) {sxml+=(' id="0"');} else {sxml+=(' id="'+oRs(curlevel-1).value+'"');};
        for (i=curlevel;i<oRs.fields.count-1;i++)
            if ((oRs(i).value!=null) && (oRs(i).Name!='levl') && (oRs(i).Name!='name')) 
            {
               sxml+=(' '+oRs(i).Name+'="'+oRs(i).value+'"');
            };
        sxml+='>';
        prevlevel=curlevel;
      };
      oRs.MoveNext()
    };
    if ((levl==true)) { // строки - row
      for (i=curlevel;i>=0;i--) {sxml+=('</a'+i+'>');}
      }
    sxml+=('</rows'+rsno+'>');
  };
  oRs=oRs.NextRecordset;
  rsno++;
}
sxml+='</root>'
//return sxml;
var xml=new ActiveXObject("MSXML2.DOMDocument.6.0");
xml.loadXML(sxml);
result=TransformXSL(sh,parm,null,xml);
return result
}

function execute4(oConn,sql,sh,parm) {
var result='';
var rs;
try {
  oConn.CommandTimeout = 0;
  rs=oConn.Execute(sql);
} catch(e) {
   return 'Ошибка выполнения запроса<br><em>'+e.description+'</em><p>'+sql
}
var rsnum=0;
var sxml='<xml id="xmlDoc" async="false">'+
'<?xml version="1.0" encoding="windows-1251" ?>'+
'<root>'+
'<schema></schema>';
var recno=0;
while (rs!=null) {
  var levl=(rs(rs.fields.count-1).Name=='levl');
  var prevlevel=-1;
  var curlevel=-1;
  sxml+='<rows'+rsnum+'>';
  while (!rs.eof) {
    if (levl==false) { // строки - row
      sxml+='<row ';
      recno++;
      for (i=0;i<rs.fields.count;i++)
        if (rs(i).value!=null) {
          s=''+rs(i).value;
          //  s=fieldStr(rs(i));
          s=zamena(s,'"','\'');
          sxml+=(rs(i).Name+'="'+s+'" ');
        }
        sxml+='/>';
    } else { // поля - элементы
      var nextlevel=1*rs('levl');
      for (i=prevlevel;i>=nextlevel;i--)
        sxml+=('</a'+i+'>');
        curlevel=nextlevel;
        sxml+=('<a'+curlevel);
        if (curlevel==0) {
          sxml+=(' id="0"')
        } else {
          sxml+=(' id="'+rs(curlevel-1).value+'"')
        };
        for (i=curlevel;i<rs.fields.count-1;i++)
        if ((rs(i).value!=null) && (rs(i).Name!='levl') && (rs(i).Name!='name')) 
          {
             sxml+=(' '+rs(i).Name+'="'+rs(i).value+'"');
          }
        sxml+=('>');
        prevlevel=curlevel;
    }
    rs.MoveNext()
  }
  if ((levl==true)) { // строки - row
    for (i=curlevel;i>=0;i--) {
    sxml+=('</a'+i+'>');
  }
  }
sxml+=('</rows'+rsnum+'>');
rs=rs.NextRecordset;
rsnum++;
}
sxml+='</root></xml>';
var xml=new ActiveXObject("MSXML2.DOMDocument.6.0");
xml.loadXML(sxml);
result=TransformXSL(sh,parm,null,xml);
return result
}

function callRep(sql,sh,parm) {
  var d=window.open();
  d=d.document;
  d.open();
  d.charset=document.charset;
  d.writeln('<html><head><meta http-equiv="Content-Type" content="text/html; charset=windows-1251"><LINK href=xtree.css rel=STYLESHEET type=text/css></head><body><div id="report"></div>');
  d.writeln(execute(oConn,sql,sh));
  d.close();
}

function expand(id) {
entity=document.all['i'+id];
if (entity.style.display == "block") entity.style.display = "none"
else entity.style.display = "block"
}

function shiftleft(lgap) {
var c=document.all.tags('col');
for (i=lgap;i<c.length;i++) {
  if (c[i].style.display!='none') {c[i].style.display='none'; break;}
}
}

function shiftright(lgap) {
var c=document.all.tags('col');
for (i=c.length-1;i>=0;i--) {
  if (c[i].style.display=='none') {c[i].style.display=''; break;}
}
}
</SCRIPT>
