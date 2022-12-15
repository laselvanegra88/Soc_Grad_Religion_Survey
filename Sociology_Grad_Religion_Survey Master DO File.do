import spss using "T:\Grad Religion Survey\GitHub\Sociology Graduate Program Survey_July 6, 2022_16.06.sav"

	*Drop all who didn't complete at least 75% of online survey*
drop if Progress <75

graph set window fontface "Garamond"

	*Rename Variables*
rename Q1 age
rename Q2 gender
rename Q3 sexuality
rename Q4 marital
rename Q5_1 white
rename Q5_2 black
rename Q5_3 hispanic
rename Q5_5 asian
rename Q5_7 mideast
rename Q5_8 natorigin
rename Q5_9 ethnicity
rename Q7 international1
rename Q8 department
rename Q9 year
rename Q11_6 subfield
rename Q12 methodology
rename Q13 classes
rename Q14 religion_discussed
rename Q15_1 nospecialization
rename Q15_2 track
rename Q15_3 comp
rename Q15_4 workinggroup
rename Q15_5 unsurespecialization
rename Q16 rel_important_research
rename Q17_1 membership_asr
rename Q17_2 membership_sssr
rename Q17_3 membership_asa_r
rename Q18 membership_others
rename Q19 faculty_supportive
rename Q21 discrimination
rename Q25 religion
rename Q25_11 religion_somethingelse
rename Q26 religion_specify
rename Q28 theismscale
rename Q29 religious_person
rename Q30 religion_dailylife
rename Q31 religion_lifedecisions
rename Q32 attendance
rename Q34 private_religious
rename Q20 hurt_career
rename Q33 religiouscommunity
rename Q35 bestunderstand
rename Q36 objective
rename Q37 sociallife
rename Q38 politicallife
rename Q39 culturallife
rename Q40 economiclife
rename Q41 secular_individual
rename Q42 secular_institutional

*Departments*

generate lower_department=lower(department)
generate rdepartment=.
replace rdepartment =1 if strpos(lower_department, "brown")
replace rdepartment =2 if strpos(lower_department, "cornell")
replace rdepartment =3 if strpos(lower_department, "columbia")
replace rdepartment =3 if lower_department == "cu"
replace rdepartment =4 if strpos(lower_department, "duke")
replace rdepartment =5 if strpos(lower_department, "harvard")
replace rdepartment =6 if strpos(lower_department, "cuny")
replace rdepartment =6 if strpos(lower_department, "graduate") //missing 
replace rdepartment =7 if strpos(lower_department, "ucla")
replace rdepartment =7 if strpos(lower_department, "angeles")
replace rdepartment =8 if strpos(lower_department, "princeton") //missing
replace rdepartment =9 if strpos(lower_department, "chicago")
replace rdepartment =10 if strpos(lower_department, "indiana")
replace rdepartment =10 if strpos(lower_department, "bloomington")
replace rdepartment =10 if strpos(lower_department, "iu")
replace rdepartment =11 if strpos(lower_department, "irvine") //missing
replace rdepartment =11 if lower_department =="uci"
replace rdepartment =12 if strpos(lower_department, "pennsylvania") //missing
replace rdepartment =12 if strpos(lower_department, "pennsyv") //missing
replace rdepartment =12 if strpos(lower_department, "upenn") //missing
replace rdepartment =12 if lower_department =="penn"
replace rdepartment =13 if strpos(lower_department, "penn state") //missing
replace rdepartment =14 if strpos(lower_department, "berkeley")
replace rdepartment =15 if strpos(lower_department, "northwest") //missing
replace rdepartment =16 if strpos(lower_department, "ohio")
replace rdepartment =16 if strpos(lower_department, "ou")
replace rdepartment =16 if strpos(lower_department, "osu")
replace rdepartment =17 if strpos(lower_department, "madison")
replace rdepartment =17 if strpos(lower_department, "wisconsin") //missing
replace rdepartment =18 if strpos(lower_department, "unc")
replace rdepartment =18 if strpos(lower_department, "hill")
replace rdepartment =19 if strpos(lower_department, "stan")
replace rdepartment =20 if strpos(lower_department, "mich") 
replace rdepartment =21 if strpos(lower_department, "yale")
replace rdepartment =22 if strpos(lower_department, "minn")
replace rdepartment =23 if strpos(lower_department, "washington")
replace rdepartment =23 if lower_department =="uw"
replace rdepartment =24 if strpos(lower_department, "maryland")
replace rdepartment =24 if strpos(lower_department, "marlyand")
replace rdepartment =24 if lower_department == "umd"
replace rdepartment =25 if strpos(lower_department, "nyu")
replace rdepartment =25 if strpos(lower_department, "new york")
label define department 1 "Brown" 2 "Cornell" 3 "Columbia" 4 "Duke" 5 "Harvard" 6 "CUNY" 7 "UCLA" 8 "Princeton" 9 "Chicago" 10 "Indiana" 11 "UC Irvine" 12 "UPenn" 13 "Penn State" 14 " UC Berkeley" 15 "Northwestern" 16 "Ohio State" 17 "Wisconsin" 18 "UNC Chapel Hill" 19 "Stanford" 20 "Michigan" 21 "Yale" 22 "Minnesota" 23 "Washington" 24 "Maryland" 25 "NYU"
label values rdepartment department


	*Data cleaning, generating new variables*
xtset rdepartment

generate international =international1
recode international (1=0)(.=0)(2=1)

replace age = "27" in 382 //they had put "2 7" with a space in between
destring age, replace

generate male=.
replace male =1 if gender==1
replace male=0 if gender==2

generate female=.
replace female=1 if gender==2
replace female=0 if gender==1

generate gendernew = gender
recode gendernew (4=5)(.=5)
label define gender 1 "Male" 2 "Female" 5 "Other"
label values gendernew gender

recode subfield (.=0)

generate married =0
replace married =1 if marital==1

drop if year==. & methodology==. & rdepartment==.
count

label var international "International Student"
label var married "Married"

//label define labels16 1 "Yes", replace


	*Cleaning up race categories and making one race category*

recode white (.=0)
recode hispanic (.=0)
recode black (.=0)
recode asian (.=0)
recode mideast (.=0)

generate white_nonhispanic =0
replace white_nonhispanic =1 if white==1 & hispanic==0

generate black_nonhispanic =0
replace black_nonhispanic =1 if black==1 & hispanic==0

generate race=.
replace race=1 if white_nonhispanic==1
replace race=2 if black_nonhispanic==1
replace race=3 if hispanic==1
replace race=4 if asian==1
replace race=5 if mideast==1 
recode race (.=6)

label define race 1 "White" 2 "Black" 3 "Hispanic" 4 "Asian" 5 "Middle Eastern" 6 "Other"
label values race race


		*Religion Variables*
		
generate affiliated =0
replace affiliated =1 if religion <9
replace affiliated =1 if religion==13
label define affiliated 0 "Unaffiliated (N=340)" 1 "Affiliated (N=133)"
label values affiliated affiliated

generate unaffiliated=0
replace unaffiliated =1 if affiliated==0

*Recode Religion
generate rreligion =.
replace rreligion =1 if religion==9 //atheist
replace rreligion =2 if religion==10 //agnostic
replace rreligion =3 if religion==12 //Nothing
replace rreligion =4 if religion==11 //other, something else
replace rreligion =4 if religion==. //missing as other
replace rreligion =4 if religion==4 //orthodox as other
replace rreligion =4 if religion==3 //mormon as other
replace rreligion =4 if religion==8 //hindu as other
replace rreligion =5 if religion==1 //Mainline
replace rreligion =6 if religion==2 //Catholic
replace rreligion =7 if religion==5 //Jewish
replace rreligion =8 if religion==13 //Evangelical
replace rreligion =9 if religion==6 //Muslim
replace rreligion =10 if religion==7 //Buddhist
label define religion 1 "Atheist" 2 "Agnostic" 3 "None" 4 "Other" 5 "Mainline" 6 "Catholic" 7 "Jewish" 8 "Evangelical" 9 "Muslim" 10 "Buddhist"
label values rreligion religion


*Dummies for Weekly Church Attendance and Private Religious Activities
generate weekly=0
replace weekly=1 if attendance ==7 | attendance==8

generate weeklyprivate =0
replace weeklyprivate=1 if private_religious >3 & private_religious !=.

*Generate Religiosity Scale
egen ztheismscale =std(theismscale)
egen zreligious_person =std(religious_person)
egen zreligion_dailylife =std(religion_dailylife)
egen zreligion_lifedecisions =std(religion_lifedecisions)
egen zattendance =std(attendance)
egen zprivate_religious =std(private_religious)
egen zreligiouscommunity =std(religiouscommunity)

alpha ztheismscale zreligious_person zreligion_dailylife zreligion_lifedecisions zattendance zprivate_religious zreligiouscommunity //.9298

egen religiosity1 = rowmean (ztheismscale zreligious_person zreligion_dailylife zreligion_lifedecisions zattendance zprivate_religious zreligiouscommunity)
sum religiosity1

gen religiosity=(religiosity1 - r(min)) / (r(max) - r(min)) *10
drop religiosity1

	*Religiosity quantile and category
xtile qreligiosity = religiosity, n(4)

generate religiosity_cat =0
replace religiosity_cat =1 if religiosity <=2.5
replace religiosity_cat =2 if religiosity >=2.5 & religiosity <=5
replace religiosity_cat =3 if religiosity >=5 & religiosity <=7.5
replace religiosity_cat =4 if religiosity >=7.5
label define relcat 1 "0-2.5" 2 "2.5-5" 3 "5-7.5" 4 "7.5-10"
label values religiosity_cat relcat

*Generate Scale for "Relevance of Religion in Contemporary Life"
egen zbestunderstand =std(bestunderstand)
egen zsociallife =std(sociallife)
egen zpoliticallife =std(politicallife)
egen zculturallife =std(culturallife)
egen zeconomiclife =std(economiclife)

alpha zbestunderstand zsociallife zpoliticallife zculturallife zeconomiclife

egen relevance1 = rowmean (zbestunderstand zsociallife zpoliticallife zculturallife zeconomiclife)

sum relevance1
gen relevance=(relevance1 - r(min)) / (r(max) - r(min)) *10
drop relevance1



	*Departmental and Work-Related Variables*

*Specialization
generate specialization=1
replace specialization=0 if nospecialization==1 | unsurespecialization==1
//Specialization all people who replied with an option for the 3 possibilies of track, comp, or workinggroup

*Religion Important to work Dummy Variables*
generate rel_important =0
replace rel_important =1 if rel_important_research >=3 & rel_important_research !=.
label variable rel_important "Dummy DV indicating at least moderate"


*Generate DV for "At least 1 class"
generate course =0
replace course =1 if classes ==2 | classes==3 | classes==4


*Departmental Support Scale
revrs faculty_supportive
egen zreligiondiscussed = std(religion_discussed)
egen zrevfaculty_supportive = std(revfaculty_supportive)
egen zspecialization = std(specialization)

alpha zreligiondiscussed zrevfaculty_supportive zspecialization
*Alpha of .70

egen support1 = rowmean (zreligiondiscussed zrevfaculty_supportive zspecialization)
sum support1

gen dept_support=(support1 - r(min)) / (r(max) - r(min)) *10
drop support1


generate reltest_1 =0
replace reltest_1 =1 if sociallife != politicallife 
generate reltest_2 =0
replace reltest_2 =1 if politicallife != culturallife 
generate reltest_3 =0
replace reltest_3 =1 if culturallife != sociallife 
generate reltest_4 =0
replace reltest_4=1 if economiclife != sociallife
generate reltest_5 =0
replace reltest_5=1 if politicallife != economiclife
generate reltest_6 =0
replace reltest_6=1 if culturallife != economiclife
generate reltest=0
replace reltest=1 if reltest_1 ==1 | reltest_2 ==1 | reltest_3 ==1 | reltest_4 ==1 | reltest_5 ==1 | reltest_6 ==1
label variable reltest "Varied in 4 core Relevance Questions"


	*Mean Imputation (Age)*
	
*Run M1 with missing age*
regress relevance c.religiosity i.rreligion i.race i.year i.gendernew c.age i.international i.married i.methodology

*MI work
generate age2 =age
fre age2
generate age_missing =1 if age2 ==.
fre age_missing
recode age_missing (.=0)
fre age_missing
label variable age_missing "Missing Age"
generate age3 =age
summarize age
replace age3 = 29.16307 if age3==.
label variable age3 "Age (Mean Imputed)

*Run M1 with mean imputted age*
regress relevance c.religiosity i.rreligion i.race i.year i.gendernew c.age3 i.international i.married i.methodology
//this is just one of the models, but I did run some others too

*Run M1 with mean imputted age AND dummy indicating missing age*
regress relevance c.religiosity i.rreligion i.race i.year i.gendernew c.age3 i.age_missing i.international i.married i.methodology
//The Missing dummy is NOT significant- no evidence that the mean imputation altered it



	*Multiple Imputation (Age)*
mi set flong
generate age4 = age
label variable age4 "Age (Multiple Imputed)"
mi register imputed age4 
mi register passive relevance methodology gendernew international year rreligion religiosity dept_support race
set seed 42
mi impute mvn age4 =  relevance international methodology gendernew year rreligion religiosity dept_support race, add(5) force
order _mi_id
sort _mi_id

*Run M1 with multiple imputted age*
mi estimate: regress relevance c.religiosity i.rreligion i.race i.year i.gendernew c.age4 i.international i.married i.methodology

*Run M1 with multiple imputted age AND dummy indicating missing age*
mi estimate: regress relevance c.religiosity i.rreligion i.race i.year i.gendernew c.age4 i.international i.married i.methodology i.age_missing

//starting to think about how to visualize the interaction, getting at DEPT_SUPPORT causality (can't use MI')
xtreg relevance i.rreligion i.race i.year i.gendernew c.age3 i.international i.married i.methodology  c.religiosity c.dept_support c.religiosity#c.dept_support

margins, at(religiosity=(0 (1) 10) dept_support=(0 (1) 10)) saving(predictions, replace)
use predictions, clear
rename _at9 religiosity
rename _at10 dept_support
rename _margin pr_relevancescore
twoway  (contour pr_relevancescore dept_support religiosity , ccuts(7(.15)9)), ytitle("Departmental Support", margin(b=3)) ylabel(, nogrid) xtitle("Religiosity") zlabel(7 7.25 7.5 7.75 8 8.25 8.5 8.75 9, noticks) ztitle("Predicted Relevance Score") graphregion(color(white))
graph export "Twoway Contour Plot", as(png) replace

twoway contour pr_relevancescore dept_support religiosity, levels(10) 

//from "https://www.stata.com/stata-news/news32-1/spotlight/"

twoway lfit relevance dept_support, by(affiliated) ylab(, nogrid) xlab(0 2 4 6 8 10) xtitle("Departmental Support")
graph export "Twoway by Affiliated.png", as(png) replace

Can't use Department as Multiple Imputted. WILL just STAY WITH AGE


*Regressions*

*Model 1- Relevance (two options)*
regress relevance c.religiosity i.rreligion i.race i.year i.gendernew c.age i.international i.married i.methodology

*Model 2 - Relevance (two options)* - add departmental stuff
regress relevance c.religiosity i.rreligion i.race i.gender c.age i.international i.married i.methodology c.departmental

regress relevance c.religiosity i.rreligion i.race i.gendernew c.age i.married i.international i.methodology i.year c.dept_support c.religiosity#c.dept_support

//dept support is significant for the whole scale, just not zQ35 - this is a big finding (this stays even when controlling for subfield)
*?=/  Religion important in every model, much more than other significant factors and stays even when we control for whether or not religion is important to work. Methdology stays, but "male" loses signifiance in the "relevance" models

*Model 3- Important to work*
logit rel_important c.religiosity i.rreligion i.race i.gendernew c.age i.married i.international i.methodology, or
logit rel_important c.religiosity i.rreligion i.race i.gendernew c.age i.married i.international i.methodology c.dept_support, or
//So no matter how you cut it, dept support not associated with anything. However, course is even when controlling for subfield//
*/

est clear
mi estimate, post: xtreg relevance c.religiosity i.rreligion i.race c.year i.gendernew c.age4 i.international i.married i.methodology
estimates store m1, title(Model 1)
mi estimate, post: xtreg relevance c.religiosity c.dept_support i.rreligion i.race c.year i.gendernew c.age4 i.international i.married i.methodology 
estimates store m2, title(Model 2)
mi estimate, post: xtreg relevance c.religiosity c.dept_support c.religiosity#c.dept_support i.rreligion i.race c.year i.gendernew c.age4 i.international i.married i.methodology
estimates store m3, title(Model 3)


esttab m1 m2 m3 using "regchart.rtf", replace cells(b(star fmt(3)) se(par fmt(2))) label legend varlabels(_cons "Constant" religiosity "Religiosity" age4 "Age" international "International Student" dept_support Departmental Support, span) nobaselevels order(religiosity dept_support religiosity#dept_support) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) 

est clear
mi estimate,  or post: logistic rel_important c.religiosity
estimates store m1, title(Model 1)
mi estimate, or post: logistic rel_important c.religiosity i.rreligion i.race i.gendernew c.year c.age4 i.married i.international i.methodology
estimates store m2, title(Model 2)
mi estimate, or post: logistic rel_important c.religiosity i.rreligion i.race i.gendernew c.year c.age4 i.married i.international i.methodology c.dept_support
estimates store m3, title(Model 3)


esttab m1 m2 m3 using "logchart.rtf", replace cells(b(star fmt(3)) se(par fmt(2))) label legend varlabels(_cons "Constant" religiosity "Religiosity" age4 "Age" international "International Student" dept_support Departmental Support, span) nobaselevels order(religiosity dept_support religiosity#dept_support) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) eform
//explain that I didn't do interaction because dept_support wasn't even significant in bivariate (footnote)


*Interaction Term Plot*
xtreg relevance c.religiosity c.dept_support c.religiosity#c.dept_support i.rreligion i.race c.year i.gendernew c.age3 i.international i.married i.methodology

margins, dydx(religiosity) at(dept_support=(0(1)10)) vsquish

margins, at(dept_support=(0 2 4 6 8 10) religiosity=(2.79 )) vsquish

marginsplot, plot (, label("Atheist (0.70)" "Agnostic/None (1.70)" "Sample Mean (2.79)")) title("") legend( label(1 "Unaffiliated Mean")) x(dept_support) recast(line) xlabel(0(1)10) xtitle("Departmental Support") ytitle("Predicted Relevance Score") graphregion(color(white)) ylabel(, nogrid) 

graph export "Marginal Effect.png" , as(png)

mtable, dydx(dept_support) at(religiosity=(1 2 3 3.1 4 5 6)) stat(est se p) post
mlincom 2 - 1, stat(est se p)


generate rel_under31 =0
replace rel_under31=1 if religiosity <=3.1
//to show that this would impact 64.69% of the sample (those with religiosity under 4.5)
generate rel_over8 =0
replace rel_over8=1 if religiosity >=8
////to show that this would impact 7.40 % of the sample (those with religiosity over 8
*/

