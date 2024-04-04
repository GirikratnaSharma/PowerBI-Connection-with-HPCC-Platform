import ut;
rec := {STRING str1, STRING str2};
#DECLARE(xmlstr);
//Export record definition to a string
#EXPORT(xmlstr, rec);
// OUTPUT(%'xmlstr'%);
//Record defintion for input record string that is to be parsed
rowRec := { STRING rowString };

STRING xmlString := %'xmlstr'%;
xmlDSet := DATASET([xmlString],rowRec);

//Output record containing field names as header.
outrec := RECORD
	STRING headerFields := XMLTEXT('@label');
END;

parsedHeaderDS := PARSE(xmlDSet, rowString, outrec , XML('/Data/Field'));
countHeaderFields := COUNT(parsedHeaderDS);
// Headercount := global(countHeaderFields,few);
_mergedHeaderRow := ROLLUP(parsedHeaderDS,TRUE,TRANSFORM(outrec,SELF.headerFields := LEFT.headerFields + ',' + RIGHT.headerFields));

output(_mergedHeaderRow,,'~thor::Forheader',CSV(Separator(',')),OVERWRITE,EXPIRE(1));
DS1 := DATASET('~thor::Forheader',rec,CSV(Separator(',')));
 ds_1 := DATASET([{'1','11'},{'2','22'}],rec);
 ds_2 := DATASET([{'11','111'},{'22','222'}],rec);
 DS := ds_1 + ds_2;
 
Headers := global(DS1,few);
 Dataa := (+) (Headers,DS, ORDERED);
 Dataa;

 EmailMssg := 'Resubmitted Cron Job Status for Today'+'-'+ut.getdate;
   import python;
      
      string formatedemails(dataset(rec) recs , Integer colCount, string EmailMssg )  := embed(Python)
      import csv
      import sys
      import smtplib
      import ssl
      from email.mime.text import MIMEText
      from email.mime.multipart import MIMEMultipart
      
      message = MIMEMultipart('alternative')
      message['Subject'] = EmailMssg
      
      str ='<h3>'+EmailMssg+'</h3>'
      str = str+'<html><body><table align="Center";table border=\'4\ color=\'red\' style=\'font-weight: bold; background-color:red;text-align: center;\'>'
     
      for rec in recs:
          str = str+ '<tr>' 
          for colSeq in range(colCount):
              str = str + '<td>' + rec[colSeq] + '</td>'
          str = str + '</tr>'
      str = str + '</table></body></html>'
      
      part1 = MIMEText(str, 'plain')
      part2 = MIMEText(str, 'html')
      
      message.attach(part1)
      message.attach(part2)
      
      try:
          smtpObj = smtplib.SMTP('appmail.risk.regn.net', '25')
          smtpObj.sendmail('IExchange.Rejects@lexisnexis.com',
                           'harsh.desai@lexisnexisrisk.com',
                           message.as_string())
          print 'Successfully sent email'
      except SMTPException:
          print 'Error: unable to send email'
      return str
      
      endembed;
      
      OUTPUT(formatedemails(Dataa, countHeaderFields,EmailMssg));

   


