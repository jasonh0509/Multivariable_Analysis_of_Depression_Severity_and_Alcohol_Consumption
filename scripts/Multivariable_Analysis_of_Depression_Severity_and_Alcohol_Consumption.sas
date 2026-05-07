libname Cate "C:\SASLib\thesis";

%macro QuickFreq(var);
proc freq data=NHIS;
table &var;
run;
%mend QuickFreq;

%macro SurveyFreq(var,set);
proc surveyfreq data=&set;
strata Strata;
cluster psu;
weight SAMPWEIGHT;
table &var;
run;
%mend;

%macro OutTablePerc(set);
data &set;
set &set;
freq_perc=catx(' ',put(Frequency,10.),'('||strip(put(RowPercent,8.2))||'%)');
cate_perc=catx(' ',put(Frequency,10.),'('||strip(put(Percent,8.2))||'%)');
run;
%mend;


%macro OnlyNeed(set);
data &set;
set &set;
keep keep ALCDAYSYR_cate SLEEPREST_cate freq_perc cate_perc;
run;

%Mend;



data NHIS;
set Cate.nhis_00006;
run;

/*Cleaning and collapsing categories without removing missing*/
data NHIS ;
set NHIS;

where age>=18 and year>=2010;

if Age=997 or Age=999 then Age=.;

/*Recode severity of depression*/
if DEPFEELEVL=0 or DEPFEELEVL=7 or 
DEPFEELEVL=8 or DEPFEELEVL=9 then DEPFEELEVL=.;

/*Recode employment status*/
if EMPSTATIMP5=0 then EMPSTATIMP5=.;


/*Recode insurance status*/

if HINOTCOVE=0 or HINOTCOVE=7 or 
HINOTCOVE=8 or HINOTCOVE=9 then HINOTCOVE=.;

/*Recode sleep quality*/
if SLEEPREST=96 or SLEEPREST=97
or SLEEPREST=98 or SLEEPREST=99 then SLEEPREST=.;

/*Recode drinking frequency*/
if ALCDAYSYR=995 or ALCDAYSYR=996
or ALCDAYSYR=997 or ALCDAYSYR=998
or ALCDAYSYR=999 then ALCDAYSYR=.;

if SMOKFREQNOW=0 or SMOKFREQNOW=7
or SMOKFREQNOW=8 or SMOKFREQNOW=9
then SMOKFREQNOW=.;

if RACENEW=997 or RACENEW=998 or RACENEW=999
or RACENEW=530 then RACENEW=.;
if RACENEW=500 or RACENEW=510 then RACENEW=520;

if INCFAM97ON2=97 or INCFAM97ON2=98 or INCFAM97ON2=99 
then INCFAM97ON2=.;

if SEX=7 or SEX=8 OR SEX=9
THEN SEX=.;
run;


/*See if alcohol consumption frequency is affected by health
insurance coverage status*/

data NHIS;
   set NHIS;

   length ALCDAYSYR_cate EMPSTATIMP5_cate AGE_cate DEPFEELEVL_cate 
          HINOTCOVE_cate INCFAM97ON2_cate RACENEW_cate SEX_cate 
          SLEEPREST_cate SMOKFREQNOW_cate $30.;

   if missing(ALCDAYSYR_cate) then ALCDAYSYR_cate = "Missing";

   if missing(EMPSTATIMP5) then EMPSTATIMP5_cate = "Missing";
   else if EMPSTATIMP5 = 1 then EMPSTATIMP5_cate = "Employed";
   else if EMPSTATIMP5 = 2 then EMPSTATIMP5_cate = "Unemployed";
   else EMPSTATIMP5_cate = "Other";

   if missing(AGE) then AGE_cate = "Missing";
   else AGE_cate = put(AGE, best.);

   if missing(DEPFEELEVL) then DEPFEELEVL_cate = "Missing";
   else DEPFEELEVL_cate = put(DEPFEELEVL, best.);

   if missing(HINOTCOVE) then HINOTCOVE_cate = "Missing";
   else HINOTCOVE_cate = put(HINOTCOVE, best.);

   if missing(INCFAM97ON2) then INCFAM97ON2_cate = "Missing";
   else INCFAM97ON2_cate = put(INCFAM97ON2, best.);

   if missing(RACENEW) then RACENEW_cate = "Missing";
   else RACENEW_cate = put(RACENEW, best.);

   if missing(SEX) then SEX_cate = "Missing";
   else SEX_cate = put(SEX, best.);

   if missing(SLEEPREST) then SLEEPREST_cate = "Missing";
   else SLEEPREST_cate = put(SLEEPREST, best.);

if missing(SMOKFREQNOW) then SMOKFREQNOW_cate = "Missing";
else if SMOKFREQNOW = 1 then SMOKFREQNOW_cate = "None-Smoker";
else if SMOKFREQNOW = 2 then SMOKFREQNOW_cate = "Some Day Smoker";
else if SMOKFREQNOW = 3 then SMOKFREQNOW_cate = "Everyday Smoker";
else if SMOKFREQNOW = 0 and smokev = 1 then SMOKFREQNOW_cate = "None-Smoker"; /* NIU handling */
else SMOKFREQNOW_cate = "Unknown";

run;



data NHIS;
set NHIS;

if SEX_cate=1 then SEX_cate="Male";
if SEX_cate=2 then SEX_cate="Female";


if RACENEW = 100 then RACENEW_cate = "White only";
   else if RACENEW = 200 then RACENEW_cate = "Black/African American only";
   else if RACENEW = 300 then RACENEW_cate = "American Indian/Alaska Native only";
   else if RACENEW = 400 then RACENEW_cate = "Asian only";
   else if RACENEW = 500 then RACENEW_cate = "Other Race and Multiple Race";
   else if RACENEW = 510 then RACENEW_cate = "Other Race and Multiple Race (2019-forward: Excluding American Indian/Alaska Native)";
   else if RACENEW = 520 then RACENEW_cate = "Other Race";
   else if RACENEW = 530 then RACENEW_cate = "Race Group Not Releasable";
   else if RACENEW = 540 then RACENEW_cate = "Multiple Race";
   else if RACENEW = 541 then RACENEW_cate = "Multiple Race (1999-2018: Including American Indian/Alaska Native)";
   else if RACENEW = 542 then RACENEW_cate = "American Indian/Alaska Native and Any Other Race";

/*Income*/

 if INCFAM97ON2 = 10 then INCFAM97ON2_cate = "$0 - $34,999";
   else if INCFAM97ON2 = 20 then INCFAM97ON2_cate = "$35,000 - $74,999";
   else if INCFAM97ON2 = 30 then INCFAM97ON2_cate = "$75,000 and over";
   else if INCFAM97ON2 = 31 then INCFAM97ON2_cate = "$75,000 - $99,999";
   else if INCFAM97ON2 = 32 then INCFAM97ON2_cate = "$100,000 and over";
   else if INCFAM97ON2 = 96 then INCFAM97ON2_cate = "$20,000 or more (no detail)";
   else if missing(INCFAM97ON2) then INCFAM97ON2_cate = "Missing";
   else INCFAM97ON2_cate = "Unknown";


/*Sleep quality*/
if SLEEPREST_f=00 then SLEEPREST_f="Never felt rested this past week";

/*Insurance*/

  if HINOTCOVE = 1 then HINOTCOVE_cate = "No, has coverage";
   else if HINOTCOVE = 2 then HINOTCOVE_cate = "Yes, has no coverage";
   else if missing(HINOTCOVE) then HINOTCOVE_cate = "Missing";
   else HINOTCOVE_cate = "Unknown";

run;



data NHIS;
	set NHIS;
	length SLEEPREST_cate $20.;

	if SLEEPREST = 0 or (1 <= SLEEPREST and SLEEPREST <= 2) then
		SLEEPREST_cate = "Low Quality";
	else if 3 <= SLEEPREST <= 5 then
		SLEEPREST_cate = "Medium Quality";
	else if 6 <= SLEEPREST <= 7 then
		SLEEPREST_cate = "High Quality";
	else SLEEPREST_cate = "Missing";
run;


/*Table 1 for association between primary predictor of interest and confounder*/
data try;
set NHIS;
length ALCDAYSYR_cate $30.;
if ALCDAYSYR=0 then ALCDAYSYR_cate="Non-drinker";
else if 1<=ALCDAYSYR<=80 then ALCDAYSYR_cate="Sometime Drinker";
else if 81 <= ALCDAYSYR <= 150 then ALCDAYSYR_cate = "Moderate drinker";
else if 151 <= ALCDAYSYR <= 312 then ALCDAYSYR_cate = "Frequent drinker";
else if 313 <= ALCDAYSYR <= 365 then ALCDAYSYR_cate = "Daily drinker";
else ALCDAYSYR_cate = "Unknown"; 
run;


proc surveyfreq data=NHIS;;
 strata STRATA;
   cluster PSU;          
   weight SAMPWEIGHT; 
   table alcdaysyr;
run;


data try;
set try;
if SMOKEV=01 or SMOKEV=02;
run;

data try;
set try;
length ALCDAYSYR_cate $30.;
if ALCDAYSYR=0 then ALCDAYSYR_cate="Non-drinker";
else if 1<=ALCDAYSYR<=80 then ALCDAYSYR_cate="Sometime Drinker";
else if 81 <= ALCDAYSYR <= 150 then ALCDAYSYR_cate = "Moderate drinker";
else if 151 <= ALCDAYSYR <= 312 then ALCDAYSYR_cate = "Frequent drinker";
else if 313 <= ALCDAYSYR <= 365 then ALCDAYSYR_cate = "Daily drinker";
else ALCDAYSYR_cate = "Unknown"; 
run;


data try;
set try;
if SMOKFREQNOW_cate=1 then SMOKFREQNOW_cate="None-Smoker";
else if smokev=01 then SMOKFREQNOW_cate="None-Smoker";
else if SMOKFREQNOW_cate=2 then SMOKFREQNOW_cate="Some Day Smoker";
else if SMOKFREQNOW_cate=3 then SMOKFREQNOW_cate="Everyday Smoker";
run;

/*only run following data step once*/
data cate.NewReduceSet_160k;
set work.Reduced_due_to_missing;
run;


proc surveyfreq data=cate.NewReduceSet_160k;
 strata STRATA;
   cluster PSU;          
   weight SAMPWEIGHT; 
   table depfreq;
run;


/*Alcohol freq vs employment status*/

ods output CrossTabs=cate.alcohol_Emp;

proc surveyfreq data=cate.NewReduceSet_160k;
 strata STRATA;
   cluster PSU;          
   weight SAMPWEIGHT; 
   table ALCDAYSYR_cate*EMPSTATIMP5_cate/ row chisq;
run;
ods output close;



data see12;
set cate.alcohol_Emp;
keep ALCDAYSYR_cate EMPSTATIMP5_cate freq_perc cate_perc;
run;

proc surveylogistic data=cate.NewReduceSet_160k;
  strata STRATA;
  cluster PSU;
  weight SAMPWEIGHT;
  class ALCDAYSYR_cate(ref='Daily drinker') EMPSTATIMP5_cate(ref='Employed') / param=ref;
  model ALCDAYSYR_cate = EMPSTATIMP5_cate;
run;



%OutTablePerc(cate.alcohol_Emp)

data alcohol_Emp;
set alcohol_Emp;
keep  ALCDAYSYR_cate F_EMPSTATIMP5_cate freq_perc cate_perc;
run;

/*Alcohol freq vs SEX*/
ods output CrossTabs=cate.alcohol_sex;

proc surveyfreq data=cate.NewReduceSet_160k;
 strata STRATA;
   cluster PSU;          
   weight SAMPWEIGHT; 
   table ALCDAYSYR_cate*SEX_cate/ row chisq;
run;

ods output close;

%OutTablePerc(cate.alcohol_sex)

data see6;
set cate.alcohol_sex;
keep ALCDAYSYR_cate SEX_cate freq_perc cate_perc;
run;



proc surveylogistic data=cate.NewReduceSet_160k;
  strata STRATA;
  cluster PSU;
  weight SAMPWEIGHT;
  class ALCDAYSYR_cate(ref='Daily drinker') SEX_cate(ref='Female') / param=ref;
  model ALCDAYSYR_cate = SEX_cate;
run;


/*Alcohol freq vs Race*/
ods output CrossTabs=cate.alcohol_race;
proc surveyfreq data=cate.NewReduceSet_160k;
 strata STRATA;
   cluster PSU;          
   weight SAMPWEIGHT; 
   table ALCDAYSYR_cate*Racenew_cate/ row chisq;
run;
ods output close;

%OutTablePerc(cate.alcohol_race)

data seeRace;
set cate.alcohol_race;
keep ALCDAYSYR_cate RACENEW_cate freq_perc cate_perc;
run;

proc sort data=seeRace;
by ALCDAYSYR_cate freq_perc cate_perc ;
run;
/*Alcohol freq vs family income*/
ods output CrossTabs=cate.alcohol_income;

proc surveyfreq data=cate.NewReduceSet_160k;
 strata STRATA;
   cluster PSU;          
   weight SAMPWEIGHT; 
   table ALCDAYSYR_cate*incfam97on2_cate/ row chisq;
run;


ods output close;

%OutTablePerc(cate.alcohol_income)

data see4;
set cate.alcohol_income;
keep ALCDAYSYR_cate INCFAM97ON2_cate freq_perc cate_perc;
run;


proc surveyfreq data=see5;
strata STRATA;
   cluster PSU;          
   weight SAMPWEIGHT;
table INCFAM97ON2_cate;
run;

/*Alcohol and insurance status*/

ods output CrossTabs=cate.Insur_sta;
proc surveyfreq data=cate.NewReduceSet_160k;
 strata STRATA;
   cluster PSU;          
   weight SAMPWEIGHT; 
   table ALCDAYSYR_cate*hinotcove_cate/ row chisq;
run;

ods output close;

data cate.insur_sta;
set cate.insur_sta;
freq_perc=catx(' ',put(Frequency,10.),'('||strip(put(RowPercent,8.2))||'%)');
cate_perc=catx(' ',put(Frequency,10.),'('||strip(put(Percent,8.2))||'%)');
run;

data see6;
set cate.insur_sta;
keep ALCDAYSYR_cate HINOTCOVE_cate freq_perc cate_perc;
run;



/*Alcohol Age*/
proc surveyfreq data=cate.NewReduceSet_160k;
	strata STRATA;
	cluster PSU;
	weight SAMPWEIGHT;
	table age;
run;

data cate.forAge_only;
set cate.NewReduceSet_160k;
length age_cate $20.;
 if 18 <= age <= 29 then age_cate = '18-29';
    else if 30 <= age <= 39 then age_cate = '30-39';
    else if 40 <= age <= 49 then age_cate = '40-49';
    else if 50 <= age <= 59 then age_cate = '50-59';
    else if 60 <= age <= 69 then age_cate = '60-69';
    else if 70 <= age <= 79 then age_cate = '70-79';
    else if 80 <= age <= 85 then age_cate = '80-85';
	else age_cate="Missing";
run;


ods output crosstabs=cate.alcohol_age;
proc surveyfreq data=cate.forage_only;
 strata STRATA;
   cluster PSU;          
   weight SAMPWEIGHT; 
   table ALCDAYSYR_cate*age_cate/ row chisq;
run;
ods output close;

%OutTablePerc(cate.alcohol_age)
data see8;
set cate.alcohol_age;
keep ALCDAYSYR_cate AGE_cate freq_perc cate_perc;
run;


/*Alcohol Sleep*/

/*ods output crosstabs=cate.alcohol_sleep;*/
/*proc surveyfreq data=cate.NewReduceSet_160k;*/
/* strata STRATA;*/
/*   cluster PSU;          */
/*   weight SAMPWEIGHT; */
/*   table ALCDAYSYR_cate*hrsleep_cate;*/
/*run;*/

data cate.NewReduceSet_160k;
set cate.NewReduceSet_160k;
if hrsleep=00 or hrsleep=25 or hrsleep=97
or hrsleep=98 or hrsleep=99 then hrsleep=.;

length hrsleep_cate $30.;
if hrsleep in (01,02,03,04,05) then hrsleep_cate="Short";
else if hrsleep in (06,07,08) then hrsleep_cate="Normal";
else hrsleep_cate="Long";
run;

proc surveyfreq data=cate.newreduceset_160k;
strata strata;
weight sampweight;
cluster psu;
table ALCDAYSYR_cate*hrsleep_cate;
run;

proc surveyfreq data=cate.nhis_00006;
strata strata;
weight sampweight;
cluster psu;
table age;
run;


/*alcohol sleeping*/

ods output crosstabs=cate.alcohol_sleep;
proc surveyfreq data=cate.NewReduceSet_160k;
 strata STRATA;
   cluster PSU;          
   weight SAMPWEIGHT; 
   table ALCDAYSYR_cate*hrsleep_cate/ row chisq;
/*  table SMOKFREQNOW_cate/ row chisq;*/

run;
ods output close;

%OutTablePerc(cate.alcohol_sleep)


data seeAlcohol_sleep;
set cate.alcohol_sleep;
keep ALCDAYSYR_cate hrsleep_cate freq_perc cate_perc;
run;
/*End of table 1 content*/


 
/*Break alcohol var into levels, use the categorical version instead*/
/*Still need to present it in numeric way result section*/

proc surveyreg data=NHIS;
   strata STRATA;
   cluster PSU;
   weight SAMPWEIGHT;
   class HINOTCOVE;
   model ALCDAYSYR = HINOTCOVE;
run;

proc surveyreg data=NHIS;
   strata STRATA;
   cluster PSU;
   weight SAMPWEIGHT;
   class HINOTCOVE;
   model ALCDAYSYR = HINOTCOVE;
   lsmeans HINOTCOVE / cl;
run;




proc surveylogistic data=NHIS nomcar; 
title1 'Logistic looking at effect of sex on depression'; 
class sex(ref='Female')/param=reference; 
model DEPFEELEVL=sex ALCDAYSYR sex*ALCDAYSYR; 
strata STRATA; 
cluster PSU; 
weight SAMPWEIGHT; 
run; 



/*Table 2 start*/

data cate.Tb2;
set try;
run;

data cate.tb2;
set cate.tb2;
/*if DEPFREQ=0 or DEPFREQ=7 or DEPFREQ=8 or DEPFREQ=9*/
/*then depfreq=5;*/
run;

data Reduced_due_to_missing;
set cate.tb2;
if not missing (DEPFREQ);
run;

proc surveyfreq data=cate.nhis_00006;
  strata strata;
  cluster psu;
  weight sampweight;
  tables depfreq / chisq row;
run;


/*depression alcohol*/

ods output crosstabs=depression_alcohol;

proc surveyfreq data=Reduced_due_to_missing;
  strata strata;
  cluster psu;
  weight sampweight;
  tables depfreq*ALCDAYSYR_cate / chisq row;
run;
ods output close;


%OutTablePerc(depression_alcohol)

data depression_alcohol;
set depression_alcohol;
keep depfreq ALCDAYSYR_cate freq_perc cate_perc;
run;

/*depression employment*/
ods output crosstabs=depression_employment;
proc surveyfreq data=Reduced_due_to_missing;
  strata strata;
  cluster psu;
  weight sampweight;
  tables depfreq*EMPSTATIMP5_cate / chisq row;
run;
ods output close;

%OutTablePerc(depression_employment)

data depression_employment;
set depression_employment;
keep depfreq EMPSTATIMP5_cate freq_perc cate_perc;
run;



/*deprssion race*/
ods output crosstabs=depression_race;
proc surveyfreq data=Reduced_due_to_missing;
  strata strata;
  cluster psu;
  weight sampweight;
  tables depfreq*RACENEW_cate / chisq row;
run;
ods output close;

%OutTablePerc(depression_race)

data depression_race;
set depression_race;
keep depfreq race_cate freq_perc cate_perc;
run;



/*Depression income*/
ods output crosstabs=depression_income;

proc surveyfreq data=cate.newreduceset_160k;
  strata strata;
  cluster psu;
  weight sampweight;
  tables depfreq*INCFAM97ON2_cate/ chisq row;
run;

ods output close;


%OutTablePerc(depression_income)

data depression_income;
set depression_income;
keep depfreq INCFAM97ON2_cate  freq_perc cate_perc;
run;

/*depression age*/

data Reduced_due_to_missing;
set Reduced_due_to_missing;
 if 18 <= age <= 29 then age_cate = '18-29';
    else if 30 <= age <= 39 then age_cate = '30-39';
    else if 40 <= age <= 49 then age_cate = '40-49';
    else if 50 <= age <= 59 then age_cate = '50-59';
    else if 60 <= age <= 69 then age_cate = '60-69';
    else if 70 <= age <= 79 then age_cate = '70-79';
    else if 80 <= age <f= 85 then age_cate = '80-85';
	else age_cate="Missing";
run;

ods output crosstabs=depression_age;

proc surveyfreq data=Reduced_due_to_missing;
  strata strata;
  cluster psu;
  weight sampweight;
  tables depfreq*AGE_cate/chisq row;
run;
ods output close;

%OutTablePerc(depression_age)

data depression_age;
set depression_age;
keep depfreq age_cate freq_perc cate_perc;
run;


/*depression sex*/

ods output crosstabs=depression_sex;

proc surveyfreq data=Reduced_due_to_missing;
  strata strata;
  cluster psu;
  weight sampweight;
  tables depfreq*sex_cate/chisq row;
run;

ods output close;
%OutTablePerc(depression_sex)

data depression_sex;
set depression_sex;
keep depfreq sex_cate freq_perc cate_perc;
run;

/*depression insurance*/
ods output crosstabs=depression_insurance;


proc surveyfreq data=Reduced_due_to_missing;
  strata strata;
  cluster psu;
  weight sampweight;
  tables depfreq*hinotcove_cate/chisq row;
/*table HINOTCOVE_cate;*/
run;

ods output close;

%OutTablePerc(depression_insurance)

data depression_insurance;
set depression_insurance;
keep depfreq HINOTCOVE_cate freq_perc cate_perc;
run;



ods output close;


proc surveyfreq data=forSleep_reduced;
 strata strata;
  cluster psu;
  weight sampweight;
  table hrsleep_cate;
  run;

data forSleep_reduced;
set reduced_due_to_missing;
length hrsleep_cate $30.;
if hrsleep in (01,02,03,04,05) then hrsleep_cate="Short";
else if hrsleep in (06,07,08) then hrsleep_cate="Normal";
else hrsleep_cate="Long";
run;


/*Depression sleep*/
ods output crosstabs=depression_sleep;

proc surveyfreq data=forSleep_reduced;
  strata strata;
  cluster psu;
  weight sampweight;
  tables depfreq*hrsleep_cate/chisq row;
run;
ods output close;

%OutTablePerc(depression_sleep)

data depression_sleep;
set depression_sleep;
keep depfreq hrsleep_cate freq_perc cate_perc;
run;


proc surveyfreq data=cate.newreduceset_160k;
strata strata;
  cluster psu;
  weight sampweight;
  table depfreq/row;
  run;
 
proc surveyfreq data=cate.tb2;
strata strata;
  cluster psu;
  weight sampweight;
  table depfreq/row;
  run;

%macro SurvFreq(set,var);
proc surveyfreq data=&set;
strata strata;
  cluster psu;
  weight sampweight;
  table &var/row;
  run;
%mend;

/*Models Fitting Start*/
/*Start of handling proportional/adjacent odd*/
/*Fit only with response and predictor, assumption */
/*Proportional odds*/

proc contents data=cate.NewReduceSet_160k;
run;

proc logistic data=cate.NewReduceSet_160k;
   class ALCDAYSYR_cate / param=ref;
   model DEPFREQ = ALCDAYSYR_cate / link=logit aggregate scale=none unequalslopes;
run;

/*POM main effect see if hold*/
proc logistic data=cate.NewReduceSet_160k;
   class ALCDAYSYR_cate(ref='Non-drinker') / param=ref;
   model depfreq_new = ALCDAYSYR_cate / link=clogit clodds=wald;
run;
/*hold,AIC 368214.76 */


/*hold AIC does not improve much, stick to POM*/

data cate.newreduceset_160k;
set cate.newreduceset_160k;
length depfreq_new $30;
if depfreq=1 then depfreq_new="High";
else if DEPFREQ in (2,3) then depfreq_new="Medium";
else if depfreq in (4,5) then depfreq_new="Low";
run;

proc surveyfreq data=cate.finalSet;
strata strata;
  cluster psu;
  weight sampweight;
  table AGE_cate;run;


proc logistic data=cate.NewReduceSet_160k;
   class ALCDAYSYR_cate(ref='Non-drinker') / param=ref;
   model depfreq_new = ALCDAYSYR_cate / link=logit aggregate scale=none;
run;

/*POM was found to be violated, no partial pom available in sas,
opt in binary logistic regression model*/


/*Try Binary*/

/*data cate.binaryDepre;*/
/*set cate.newreduceset_160k;*/
/*length depfreq_binary $30;*/
/*if depfreq=1 then depfreq_binary="Daily";*/
/*else if DEPFREQ in (2,3,4,5) then depfreq_binary="Non-Daily";*/
/*run;*/




proc surveylogistic data=cate.binaryDepre;
   strata strata;
   cluster psu;
   weight sampweight;

   class 
      ALCDAYSYR_cate(ref='Non-drinker')
/*      AGEGROUP_cate*/
	  hrsleep_cate(ref='Short')
      SEX_cate (ref='Male')
      RACENEW_cate (ref='White only')
      EMPSTATIMP5_cate (ref='Unemployed')
      HINOTCOVE_cate (ref='Yes, has no coverage')
      INCFAM97ON2_cate (ref='$0 - $34,999')
      / param=ref;

   model depfreq_binary = 
      ALCDAYSYR_cate
/*      AGEGROUP_cate*/
      SEX_cate
	  hrsleep_cate
      RACENEW_cate
      EMPSTATIMP5_cate
      HINOTCOVE_cate
      INCFAM97ON2_cate
      / link=logit clparm;

run;

proc surveyfreq data=cate.newreduceset_160k;
strata strata;
   cluster psu;
   weight sampweight;
table depfreq;
run;



%SurvFreq(cate.NewReduceSet_160k,ALCDAYSYR_cate)



data cate.finalSet;
set cate.newreduceset_160k;
 if 18 <= age <= 29 then age_cate = '18-29';
    else if 30 <= age <= 39 then age_cate = '30-39';
    else if 40 <= age <= 49 then age_cate = '40-49';
    else if 50 <= age <= 59 then age_cate = '50-59';
    else if 60 <= age <= 69 then age_cate = '60-69';
    else if 70 <= age <= 79 then age_cate = '70-79';
    else if 80 <= age <= 85 then age_cate = '80-85';
	else age_cate="Missing";
run;


data cate.finalset;
set cate.finalset;

 /* Create individual flags */
    flag_age  = (Age_cate = "Missing");
    flag_sex  = (Sex_cate = "Missing");
    flag_race = (racenew_cate = "Missing");
    flag_emp  = (EMPSTATIMP5_cate = "Missing");
    flag_ins  = (HINOTCOVE_cate = "Missing");
    flag_sleep = (hrsleep_cate = "Missing");
    flag_income = (INCFAM97ON2_cate = "Missing");

    /* Create master flag: 1 = any missing, 0 = all complete */
    flag = max(of flag_:);
/*Individual flag for each var*/



run;


data cate.finalset;
set cate.finalset;
length depfreq_binary $30;
if depfreq in (1,2,3) then depfreq_binary="Severe";
else if depfreq in (4,5) then depfreq_binary="Not Severe";
run;

proc surveyfreq data=cate.finalset;
/*    where flag_income = 0;*/
    tables depfreq_binary;
run;


/*Including missing employment */
proc surveylogistic data=cate.finalSet;

strata strata;
   cluster psu;
   weight sampweight;
/*	where flag_income=0;*/
   class 
      ALCDAYSYR_cate(ref='Non-drinker')
      age_cate
      SEX_cate
      RACENEW_cate
      EMPSTATIMP5_cate
      HINOTCOVE_cate
	  hrsleep_cate
      INCFAM97ON2_cate / param=ref;

   model depfreq_binary = 
      ALCDAYSYR_cate
      age_cate
      SEX_cate
      RACENEW_cate
      EMPSTATIMP5_cate
      HINOTCOVE_cate
      INCFAM97ON2_cate
	  hrsleep_cate
      /link=logit clparm;
run;

/*Excluding missing employment*/
proc surveylogistic data=cate.finalSet;
	where flag_income=0;

	strata strata;
   cluster psu;
   weight sampweight;

   class 
      ALCDAYSYR_cate(ref='Non-drinker')
      age_cate
      SEX_cate
      RACENEW_cate
      EMPSTATIMP5_cate
      HINOTCOVE_cate
	  hrsleep_cate
      INCFAM97ON2_cate / param=ref;

   model depfreq_binary = 
      ALCDAYSYR_cate
      age_cate
      SEX_cate
      RACENEW_cate
      EMPSTATIMP5_cate
      HINOTCOVE_cate
      INCFAM97ON2_cate
	  hrsleep_cate
      / clparm;
run;


proc surveyfreq data=cate.finalset;
/*where flag_emp=0;*/

	strata strata;
   cluster psu;
   weight sampweight;
   table hrsleep_cate;
   run;




/*Including missing employment*/
   proc surveylogistic data=cate.finalSet;
/*	where flag_emp=0;*/

	strata strata;
   cluster psu;
   weight sampweight;

   class 
      ALCDAYSYR_cate(ref='Non-drinker')
      age_cate
      SEX_cate
      RACENEW_cate
      EMPSTATIMP5_cate
      HINOTCOVE_cate
	  hrsleep_cate
      INCFAM97ON2_cate / param=ref;

   model depfreq_binary = 
      ALCDAYSYR_cate
      age_cate
      SEX_cate
      RACENEW_cate
      EMPSTATIMP5_cate
      HINOTCOVE_cate
      INCFAM97ON2_cate
	  hrsleep_cate
      / clparm;
run;


/*excluding missing employment*/
   proc surveylogistic data=cate.finalSet;
	where flag_emp=0;

	strata strata;
   cluster psu;
   weight sampweight;

   class 
      ALCDAYSYR_cate(ref='Non-drinker')
      age_cate
      SEX_cate
      RACENEW_cate
      EMPSTATIMP5_cate
      HINOTCOVE_cate
	  hrsleep_cate
      INCFAM97ON2_cate / param=ref;

   model depfreq_binary = 
      ALCDAYSYR_cate
      age_cate
      SEX_cate
      RACENEW_cate
      EMPSTATIMP5_cate
      HINOTCOVE_cate
      INCFAM97ON2_cate
	  hrsleep_cate
      / clparm;
run;


data cate.finalset;
set cate.finalset;
Flag_emp_income=1;
if EMPSTATIMP5_cate="Missing" or INCFAM97ON2_cate="Missing" 
then Flag_emp_income=0;
run;

/*the output domain flag=1 means?*/
/*the output domain flag=0 means?*/

/*Final Final Binary and unweighed partial proportional logistic*/
/*Model 1 and 2 without var but not keep/keep missing*/

/*Model 1,excluding income and employment, full data*/
proc surveylogistic data=cate.finalset;
strata strata;
   cluster psu;
   weight sampweight;

   class 
      ALCDAYSYR_cate(ref='Non-drinker')
      age_cate(ref='18-29')
      SEX_cate(ref='Male')
      RACENEW_cate(ref='White only')
      EMPSTATIMP5_cate(ref='Unemployed')
      HINOTCOVE_cate(ref='Yes, has no coverage')
      hrsleep_cate(ref='Short')
      INCFAM97ON2_cate(ref='$75,000 - $99,999') / param=ref;

   model depfreq_binary(event='Severe')= 
      ALCDAYSYR_cate
      age_cate
      SEX_cate
      RACENEW_cate
/*      EMPSTATIMP5_cate*/
      HINOTCOVE_cate
/*      INCFAM97ON2_cate*/
      hrsleep_cate
      / clodds;
run;


ods output crosstabs=model2;

/*Model 2 , domain analysis,only read domain flag=1  */
proc surveylogistic data=cate.finalset;
strata strata;
   cluster psu;
   weight sampweight;

   class 
      ALCDAYSYR_cate(ref='Non-drinker')
      age_cate(ref='18-29')
      SEX_cate(ref='Male')
      RACENEW_cate(ref='White only')
      EMPSTATIMP5_cate(ref='Unemployed')
      HINOTCOVE_cate(ref='Yes, has no coverage')
      hrsleep_cate(ref='Short')
      INCFAM97ON2_cate(ref='$75,000 - $99,999') / param=ref;

   model depfreq_binary(event='Severe')= 
      ALCDAYSYR_cate

	        age_cate
      SEX_cate
      RACENEW_cate
      EMPSTATIMP5_cate
      HINOTCOVE_cate
      INCFAM97ON2_cate
      hrsleep_cate
      / clodds;
	  domain Flag_emp_income;
run;
ods output close;
/*Model 3, use full data set(include rows with missing
in employment and income),include emp and income var*/
proc surveylogistic data=cate.finalset;
strata strata;
   cluster psu;
   weight sampweight;

   class 
      ALCDAYSYR_cate(ref='Non-drinker')
      age_cate(ref='18-29')
      SEX_cate(ref='Male')
      RACENEW_cate(ref='White only')
      EMPSTATIMP5_cate(ref='Unemployed')
      HINOTCOVE_cate(ref='Yes, has no coverage')
      hrsleep_cate(ref='Short')
      INCFAM97ON2_cate(ref='$75,000 - $99,999') / param=ref;

   model depfreq_binary(event='Severe')= 
      ALCDAYSYR_cate
      age_cate
      SEX_cate
      RACENEW_cate
      EMPSTATIMP5_cate
      HINOTCOVE_cate
      INCFAM97ON2_cate
      hrsleep_cate
      / clodds;
run;

proc surveyfreq data=NHIS;
strata strata;
   cluster psu;
   weight sampweight;
   table depfreq;
   run;
