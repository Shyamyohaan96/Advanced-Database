-- Run: grunt> exec query_b.pig

--data: {twitter_account_id: int,email_address: chararray,phone_number: chararray,user_location: chararray,num_tweets: int}
data = LOAD 'HW4-twitter_account.csv' using PigStorage(',') AS (twitter_account_id:int, email_address:chararray, phone_number:chararray, user_location:chararray,num_tweets:int);
Describe data;

--grou: {group: chararray,data: {(twitter_account_id: int,email_address: chararray,phone_number: chararray,user_location: chararray,num_tweets: int)}}
grou = GROUP data BY user_location;
Describe grou;

--result: {group: chararray,long}
result = FOREACH grou GENERATE group, COUNT(data);
Describe result;


STORE result INTO 'quer_b' using PigStorage(',');
fs -getmerge quer_b query_b.txt;
rm quer_b;
dump result;

