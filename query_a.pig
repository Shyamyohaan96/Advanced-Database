-- Run: grunt> exec -param areacode="number" query_a.pig

--data: {twitter_account_id: int,email_address: chararray,phone_number: chararray,user_location: chararray,num_tweets: int}
data = LOAD 'HW4-twitter_account.csv' using PigStorage(',') AS (twitter_account_id:int, email_address:chararray, phone_number:chararray, user_location:chararray,num_tweets:int);
Describe data;

--sub_data: {email_id: chararray,area_code: chararray}
sub_data = FOREACH data GENERATE email_address as email_id, SUBSTRING (phone_number,0,3) AS area_code;
Describe sub_data;

--grou: {group: chararray,sub_data: {(email_id: chararray,area_code: chararray)}}
grou = GROUP sub_data BY area_code;
Describe grou;

--new: {group: chararray,{(email_id: chararray)}}
new = FOREACH grou GENERATE group,sub_data.email_id;
Describe new;

--result: {group: chararray,{(email_id: chararray)}}
result = FILTER new BY group == (chararray)$areacode;
Describe result;



STORE result INTO 'quer_a' using PigStorage(',');
fs -getmerge quer_a query_a.txt;
rm quer_a;
dump result;
 
