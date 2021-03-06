setwd("U:\\401A\\sleuth3csv") # or wherever your data are



# From lecture
case1002 = read.csv("case1002.csv")

# In R, I would perform all F-Tests "manually"
# I would fit each model and then use anova to compare them
# This is the equivalent to SAS's ANOVA table
m0 = lm(log(Energy)~1, case1002)
m1 = lm(log(Energy)~log(Mass)+Type, case1002)
anova(m0,m1)

# Parameter estimates and confidence intervals
summary(m1)
confint(m1)

# Pairwise comparisons (R automatically performs a multiple comparison adjustment)
# install.packages("lsmeans")
library(lsmeans)
lsmeans(m1, 'Type', contr='pairwise')


# Type III SS F-tests
drop1(m1, test='F')


# Type I SS F-tests (manually)
anova(lm(log(Energy)~Type, case1002),      m1)
anova(lm(log(Energy)~log(Mass), case1002), m1)


# Predictions
new = data.frame(Mass=50, Type='echolocating bats')
exp(predict(m1, new, interval='confidence'))
exp(predict(m1, new, interval='prediction'))

# When interactions are present, you can perform LSMEANS
# at particular values for the continuous explanatory variable.
mI = lm(log(Energy)~log(Mass)*Type, case1002)
lsmeans(mI, 'Type', contr='pairwise', at=list(Mass=exp(mean(log(case1002$Mass))))) 
lsmeans(mI, 'Type', contr='pairwise', at=list(Mass=exp(0)))
lsmeans(mI, 'Type', contr='pairwise', at=list(Mass=exp(5.5)))



lsmeans(mI, pairwise~Type)






#######################################################
# Chapter 10                                         
#######################################################

case1001 = read.csv("case1001.csv")
names(case1001) = tolower(names(case1001))

case1001$height250   = case1001$height-250
case1001$height250sq = case1001$height250^2
case1001$heightsq    = case1001$height^2
case1001$heightcu    = case1001$height^3

mod1 = lm(distance~height+heightsq, case1001)
summary(mod1)

mod2 = lm(distance~height250+height250sq, case1001)
summary(mod2)

mod2 = lm(distance~I(height-250)+I((height-250))^2, case1001)
summary(mod2)

# Compare to Display 10.11
mod0 = lm(distance~1, case1001)
anova(mod0,mod1)

# Compare to Display 10.13
mod3 = lm(distance~height+I(height^2)+I(height^3),case1001)
summary(mod3)

###########################################################

case1002 = read.csv("case1002.csv")
names(case1002) = tolower(names(case1002))

case1002$lenergy = log(case1002$energy)
case1002$lmass   = log(case1002$mass)
case1002$bird = 0
case1002$bird[grep("bird",case1002$type)] = 1
case1002$ebat = 0
case1002$ebat[case1002$type=="echolocating bats"] = 1

# Compare to Display 10.4
plot(lenergy~lmass, case1002, pch=as.numeric(type)) 

# Compare to Display 10.6
mod = lm(lenergy~lmass+bird+ebat, case1002) 
summary(mod)

# rather than creating the bird and ebat variables just relevel the factor
case1002$type = relevel(case1002$type, ref="non-echolocating bats")
mod = lm(lenergy~lmass+type, case1002)
summary(mod) # alternative

# Compare to Display 10.12
mod1 = lm(lenergy~lmass+bird+ebat+lmass*bird+lmass*ebat, case1002)
summary(mod1)

mod2 = lm(lenergy~lmass+bird+ebat, case1002)
summary(mod2)

# Run the F-test to compare these models
anova(mod1,mod2)

# Compare to Display 10.15
mod = lm(lenergy~lmass+type, case1002)
summary(mod)



###################################################################
# use relevel() to change the reference level
case0501 = read.csv("case0501.csv")
case0501$Diet = relevel(case0501$Diet, "NP")

summary(lm(Lifetime~Diet, case0501))

# Be careful if a categorical variable is coded as a numeric variable
# use as.factor() to turn a non-factor into a factor, e.g.
# suppose Diet was coded as numeric
case0501$Diet = as.numeric(case0501$Diet)
summary(case0501)

summary(lm(Lifetime~Diet, case0501))            # Not what you want
summary(lm(Lifetime~as.factor(Diet), case0501)) # but this is










