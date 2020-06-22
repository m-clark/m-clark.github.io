use "/Users/micl/repos/m-clark.github.io/data/insurance.dta", clear


nbreg claims  i.age, offset(ln_holders) nolog


margins age 

margins age, atmeans
margins, over(age)

nbreg claims i.age i.group i.district, offset(ln_holders) nolog

margins age, at(group =  (1(1)4) district = (1(1)4))

margins age, at(group =  1 )

margins age, at(ln_holders = 5)





nbreg claims  age_num, offset(ln_holders) nolog
*margins   age_num
margins age_num, atmeans(age_num)
margins, dydx(age_num)




poisson claims  i.age, offset(ln_holders) nolog

margins age

margins, dydx(age)

margins, over(age)
