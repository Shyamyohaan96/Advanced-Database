-- Run: grunt> exec -param numtweets="number" query_c.pig

--data1: {twitter_account_id: int,email_address: chararray,phone_number: chararray,user_location: chararray,num_tweets: int}
data1 = LOAD 'HW4-twitter_account.csv' using PigStorage(',') AS (twitter_account_id:int, email_address:chararray, phone_number:chararray, user_location:chararray,num_tweets:int);
Describe data1;

--data2: {email_add: chararray,reputation: int,num_questions: int}
data2 = LOAD 'HW4-stack_overflow_account.csv' using PigStorage(',') AS (email_add:chararray, reputation:int, num_questions:int);
Describe data2;

--joining: {data1::twitter_account_id: int,data1::email_address: chararray,data1::phone_number: chararray,data1::user_location: chararray,data1::num_tweets: int,data2::email_add: chararray,data2::reputation: int,data2::num_questions: int}
joining = JOIN data1 BY email_address, data2 BY email_add;
Describe joining;

--gro: {group: int,joining: {(data1::twitter_account_id: int,data1::email_address: chararray,data1::phone_number: chararray,data1::user_location: chararray,data1::num_tweets: int,data2::email_add: chararray,data2::reputation: int,data2::num_questions: int)}}
gro = GROUP joining BY (num_tweets);
Describe gro;

--avg_rep: {group: int,double}
avg_rep = FOREACH gro GENERATE group, AVG(joining.reputation);
Describe avg_rep;

--result: {group: int,double}
result = FILTER avg_rep BY group > $numtweets;
Describe result;



STORE result INTO 'quer_c' using PigStorage(',');
fs -getmerge quer_c query_c.txt;
rm quer_c;
dump result;
