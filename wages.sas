data w;
infile "H:\SAS files\Assignment 3\wage.dat" missover firstobs=2;
input Edu Hr Wage Famearn Self Sal Mar Numkid Age unemp;run;

proc print data=w;  run;

data iden; 
k = 1;
y = 1982;x=1; 
do i = 1 to 1002 by 3;
do j = i to i+2;
id = k; 
year = y+x+1;
x=x+1;
output; 
end;
x=1;
k = k+1;
end; drop i j k y x;
run;
proc print data = iden;run;

data wages;merge w iden;
run;

proc print data = wages; run; 

data wages_log;
   set wages;
   logwages = log(wage);
 run;
 proc print data = wages_log; run;

 data wg; set wages_log (drop=Wage); run;

 proc print data = wg; run;

 /* Multicollinearity check resulted in no multicollinearity*/

 /*1*/
 proc reg data = wg plot = None;  
 model logwages = Age Edu Hr Mar Sal Self / STB VIF Collinoint  ;
run; 

/*2*/
data a; set wg;
Agesq = Age*Age;
Edusq = Edu*Edu;
Hrsq = Hr*Hr;run;
proc reg data = a plot = None;
model logwages = Age Agesq Edu Edusq Hr Hrsq Mar Sal Self;
run;

/*3*/

proc reg data = a plot = None;
model logwages = Age Agesq Edu Edusq Hr Hrsq Mar Sal Self / STB VIF Collinoint White ;
run;
  proc model data=a;
      parms a1 b1 b2 b3 b4 b5 b6 b7 b8 b9;
      logwages = a1 + b1 * Edu + b2 * Edusq + b3 *Hr +b4*Hrsq + b5 * Age + b6 * Agesq + b7 * Mar + b8*Sal + b9*Self;
      fit logwages / white pagan=(1 Edu Edusq Hr Hrsq Age Agesq Mar Sal Self);
   run;

/*4*/
proc panel data=wg plot = None;       
id id year;       
model logwages= Age Edu Hr Mar Sal Self / fixone ranone fixtwo rantwo;    
run;

/*5-6*/
proc panel data=wg;
id id year;
model logwages= Age Edu Hr Mar Sal Self / ranone rantwo;
run;
