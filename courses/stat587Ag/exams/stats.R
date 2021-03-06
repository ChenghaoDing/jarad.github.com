library(ggplot2)
library(plyr)
library(reshape2)

# Read in data set
d = read.csv("exam2.csv")

# Fix names
names(d)[13] = "hw" # homework subtotal
names(d)[14] = "exam1"
names(d)[15] = "exam2"
names(d)[17] = "exams"
names(d)[18] = "final"

# Summary statistics
sm = 
ddply(melt(d[,c("exam1","exam2")]),
      .(variable), 
      summarize,
      n = length(value),
      mean = mean(value, na.rm=TRUE),
      sd   = sd(value, na.rm=TRUE))
sm

# Is there a difference in means between the two exams?
t.test(d$exam1, d$exam2, paired=TRUE)

# remove student who hasn't taken the exam
d = d[-which(d$exam2==0 | is.na(d$exam2)),]

ggplot(d, aes(x=exam2)) + geom_histogram(binwidth=1, origin=14.5)

ggplot(d, aes(x=exam1, y=exam2)) + geom_point() + stat_smooth(method='lm') +
  geom_abline(intercept=diff(sm$mean), slope=1, col='red')

# Fit simple linear regression model
m = lm(exam2~exam1, d)
summary(m)


# Compare vs homework
ggplot(d, aes(x=hw, y=exam2)) + geom_point()
ggplot(subset(d, hw>.85), aes(x=hw, y=exam2)) + geom_point() + stat_smooth(method='lm')


# Overall grade
ggplot(subset(d, final>.5), aes(x=100*final)) + geom_histogram(binwidth=0.5)
