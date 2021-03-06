<#list Products as product>
  <#list LogTypes as logType>
  <#assign tableName = product + "_" + logType + "log">
  <#assign filedsFile = "/include/" + logType + ".log.fields">
-----------------------------------------------------------------------------
DROP TABLE IF EXISTS ${tableName};
CREATE TABLE ${tableName} (
  <#include filedsFile>
) 
PARTITIONED BY (year STRING, month STRING) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';

<#list 1..12 as month>
ALTER TABLE ${tableName} ADD PARTITION (year='2016', month='${month?left_pad(2, '0')}');
</#list>


  </#list>
</#list>

<@pp.renameOutputFile extension='${LogTypes?join(".")}.sql' />