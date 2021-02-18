**** Sreeja Pillai ****;
** u1265169 ** ;
* Assignment 1 * ;

*** import data from csv into our own temp dataset called tax_info;
DATA tax_info ; set WORK.import;
RUN;

**** change the FAGI into numerical data type ****;
data tax_info; set tax_info;
fagi2 = input(fagi, dollar10.2);
drop fagi;
rename fagi2 = fagi;
run;

*insert the dollar symbol at the start *;
data tax_info; set tax_info;
format fagi dollar10.2;
run;

*** lets check if we have the fagi has got updated *** ;
proc contents data=tax_info;
run; 


**** load columns into our data set **** ;
data tax_info; set tax_info;
%let exempt_amt = 590;
%let tax_rate = .0495;
line4 = FAGI;
if line4 = . then line4 = 0;
line5 = additions;
if line5 = . then line5 = 0;
line6 = line4 + line5;
line7 = state_refund;
line8 = subtractions;
line9 = line6 - line7 - line8;
*line9 = line6 - sum(line7,line);
line10 = line9*&tax_rate;
line11 = utah_exemptions*&exempt_amt;
line12 = federal_deductions;
line13 = line11 + line12;
line14 = state_inc_deducted_on_5a;
line15 = line13 - line14;
line16 = line15*.06;
line17 = line17;
line18 = max(line9 - line17,0);
line19 = line18*.013;
line20 = max(line16 - line19,0);
line22 = max(line10-line20,0);
run;




****** Question 1 ******;
data tax_info; set tax_info;
%let exempt_amt = 590;
%let tax_rate = .0495;
line4_q1 = FAGI;
if line4_q1 = . then line4_q1 = 0;
call streaminit(7584);  *Specifies a seed value to use for subsequent random number generation by the RAND function.;
tax_exempt_recipient = rand('Bernouli',.20);
if tax_exempt_recipient = 1 then line4_q1 = 0;  * if they have social_security that means they are exempt from pating tax;
line5_q1 = additions;
if line5_q1 = . then line5_q1 = 0;
line6_q1 = line4_q1 + line5_q1;
line7_q1 = state_refund;
line8_q1 = subtractions;
line9_q1 = line6_q1 - line7_q1 - line8_q1;
*line9 = line6 - sum(line7,line);
line10_q1 = line9_q1*&tax_rate;
line11_q1 = utah_exemptions*&exempt_amt;
line12_q1 = federal_deductions;
line13_q1 = line11_q1 + line12_q1;
line14_q1 = state_inc_deducted_on_5a;
line15_q1 = line13_q1 - line14_q1;
line16_q1 = line15_q1*.06;
line17_q1 = line17;
line18_q1 = max(line9_q1 - line17_q1,0);
line19_q1 = line18_q1*.013;
line20_q1 = max(line16_q1 - line19_q1,0);
line22_q1 = max(line10_q1-line20_q1,0);
if tax_exempt_recipient = 1 then line22_q1=.;   *makes sure only mean is calculate from 80% ;
run;

*want to use the prcedure means and have to calculate the sum for line22 and "n" displays the total count ;
* we just want the sum of income tax money we get if we implement the above rule ;
*doubt mean is for the 80% people paying tax or the whole population ;
proc means data=tax_info mean n;
var line22_q1;
title 'Question 1';
run;


*** Question 2 *** ;
* we have to group the income tax by phase out that is line 17;

proc sort data= tax_info;
by line17_q1;
run;

proc means Data = tax_info mean median;
var line22_q1;
by line17_q1;
title 'Question 2';
run;


*** Question 3 *** ;
** doubt should be subtract line22 or line22_q1 ;
data tax_info; set tax_info;
%let exempt_amt = 3113;
%let tax_rate = .0495;
line4_q3 = FAGI;
if line4_q3 = . then line4_q3 = 0;
line5_q3= additions;
if line5_q3 = . then line5_q3 = 0;
line6_q3 = line4_q3 + line5_q3;
line7_q3 = state_refund;
line8_q3 = subtractions;
line9_q3 = line6_q3 - line7_q3 - line8_q3;
line10_q3 = line9_q3*&tax_rate;
line11_q3 = utah_exemptions*&exempt_amt;
line12_q3 = federal_deductions;
line13_q3 = line11_q3 + line12_q3;
line14_q3 = state_inc_deducted_on_5a;
line15_q3 = line13_q3 - line14_q3;
line16_q3 = line15_q3*.06;
line17_q3 = line17;
line18_q3 = max(line9_q3 - line17_q3,0);
line19_q3 = line18_q3*.013;
line20_q3 = max(line16_q3 - line19_q3,0);
line22_q3 = max(line10_q3-line20_q3,0);
difference = line22_q3 - line22;
if difference = 0 then difference = "";
else difference = difference;
run;

*i made the rows with 0 as missing so that i can get the count of non-zero values ;
proc means data=tax_info  n;
var difference;
title 'Question 3';
run;







**** Question 4 **** ;
* we have to exempt 50% of the income ;
*****************************************************;
data tax_info; set tax_info;
%let exempt_amt = 590;
%let tax_rate = .0495;
line4_q4 = FAGI;
if line4_q4 = . then line4_q4 = 0;
call streaminit(7584);  *Specifies a seed value to use for subsequent random number generation by the RAND function.;
social_security_recipient = rand('Bernouli',.25);
if social_security_recipient = 1 then line4_q4 = 0.5*line4_q4;  * if they have social_security that means they pay tax on 50% of it ;
line5_q4 = additions;
if line5_q4 = . then line5_q4 = 0;
line6_q4 = line4_q4 + line5_q4;
line7_q4 = state_refund;
line8_q4 = subtractions;
line9_q4 = line6_q4 - line7_q4 - line8_q4;
*line9 = line6 - sum(line7,line);
line10_q4 = line9_q4*&tax_rate;
line11_q4 = utah_exemptions*&exempt_amt;
line12_q4 = federal_deductions;
line13_q4 = line11_q4 + line12_q4;
line14_q4 = state_inc_deducted_on_5a;
line15_q4 = line13_q4 - line14_q4;
line16_q4 = line15_q4*.06;
line17 = line17;
line18_q4 = max(line9_q4 - line17,0);
line19_q4 = line18_q4*.013;
line20_q4 = max(line16_q4 - line19_q4,0);
line22_q4 = max(line10_q4-line20_q4,0);
difference2 = line22_q4 - line22; *This is my comment;
run;

proc means data=tax_info sum;
var difference2;
title 'Question 4';
run;





**** Question 6 **** ;
data tax_info; set tax_info;
baseline_federal_tax = 0;
new_federal_tax = 0;
baseline_federal_tax = 0.30*fagi;
if fagi ge 400000 then new_federal_tax = 0.28*400000 + 0.5*(fagi-400000);
if fagi lt 400000 then new_federal_tax = 0.28*fagi;
difference3 = new_federal_tax - baseline_federal_tax;
run;

**Tax change for the overall group **;
proc means data=tax_info sum;
var difference3;
title 'Question 6';
run;





*** Question 5 ***;
*** import the dataset into csv to plot it on tableau ***;

/* Stream a CSV representation of SASHELP.CARS directly to the user's browser. */

proc export data=work.tax_info
            outfile=_dataout
            dbms=csv replace;
run;

%let _DATAOUT_MIME_TYPE=text/csv;
%let _DATAOUT_NAME=tax_info_output1.csv;	
