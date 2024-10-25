# what's the fastest way to check for all integers are the same?
# See https://stackoverflow.com/questions/4752275/test-for-equality-among-all-elements-of-a-single-numeric-vector
# I've been using the first test. It takes 24% of "significant" time for 1e5 reps



library(bench)
library(collapse)

x <- floor(runif(5e6) * 1e4)              # 5 million mostly different values
y <- c(rep(42, 4e6), rep(63, 1e6))        # 5 million numbers, just 2 values
z <- rep(42, 5e6)                         # 5 million all the same
z2 <- z; z2[101] <- NA                    # all the same but with an NA

length(x)
length(y)
length(z)



'test' <- function(x) {
   print(mark(t <- all(x == x[1], na.rm = TRUE)))
   print(t)
   print(mark(t <- length(unique(x[!is.na(x)])) == 1))
   print(t)
   print(mark(t <- var(x, na.rm = TRUE) == 0))
   print(t)
   print(mark(t <- (max(x, na.rm = TRUE) - min(x, na.rm = TRUE)) == 0))
   print(t)
   print(mark(t <- (max(x, na.rm = TRUE) - min(x, na.rm = TRUE)) < 1))
   print(t)
   print(mark(t <- fmode(x, na.rm = TRUE)))
}


test(x)           # 5 million mostly different values
test(y)           # 5 million numbers, just 2 values
test(z)           # 5 million all the same
test(z2)          # all the same but with an NA
