% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mlim.error.R
\name{mlim.error}
\alias{mlim.error}
\title{imputation error}
\usage{
mlim.error(
  imputed,
  incomplete,
  complete,
  transform = NULL,
  varwise = FALSE,
  ignore.missclass = TRUE,
  ignore.rank = FALSE
)
}
\arguments{
\item{imputed}{the imputed dataframe}

\item{incomplete}{the dataframe with missing values}

\item{complete}{the original dataframe with no missing values}

\item{transform}{character. it can be either "standardize", which standardizes the
numeric variables before evaluating the imputation error, or
"normalize", which change the scale of continuous variables to
range from 0 to 1. the default is NULL.}

\item{varwise}{logical, default is FALSE. if TRUE, in addition to
mean accuracy for each variable type, the algorithm's
performance for each variable (column) of the datast is
also returned. if TRUE, instead of a numeric vector, a
list is retuned.}

\item{ignore.missclass}{logical. the default is TRUE. if FALSE, the overall
missclassification rate for imputed unordered factors will be
returned. in general, missclassification is not recommended,
particularly for multinomial factors because it is not robust
to imbalanced data. in other words, an imputation might show
a very high accuracy, because it is biased towards the majority
class, ignoring the minority levels. to avoid this error,
Mean Per Class Error (MPCE) is returned, which is the average
missclassification of each class and thus, it is a fairer
criteria for evaluating multinomial classes.}

\item{ignore.rank}{logical (default is FALSE, which is recommended). if TRUE,
the accuracy of imputation of ordered factors (ordinal variables)
will be evaluated based on 'missclassification rate' instead of
normalized euclidean distance. this practice is not recommended
because higher classification rate for ordinal variables does not
guarantee lower distances between the imputed levels, despite the
popularity of evaluating ordinal variables based on missclassification
rate. in other words, assume an ordinal variable has 5 levels (1. strongly
disagree, 2. disagree, 3. uncertain, 4. agree, 5.strongly agree). in this
example, if "ignore.rank = TRUE", then an imputation that imputes level
"5" as "4" is equally inaccurate as other algorithm that imputes level "5"
as "1". therefore, if you have ordinal variables in your dataset, make sure
you declare them as "ordered" factors to get the best imputation accuracy.}
}
\value{
numeric vector
}
\description{
calculates NRMSE, missclassification rate, and miss-ranking
             absolute mean distance, scaled between 0 to 1, where 1 means
             maximum distance between the actual rank of a level and the
             imputed level.
}
\examples{

\dontrun{
data(iris)

# add 10\% missing values, ensure missingness is stratified for factors
irisNA <- mlim.na(iris, p = 0.1, stratify = TRUE, seed = 2022)

# run the default imputation
MLIM <- mlim(irisNA)
mlim.error(MLIM, irisNA, iris)

# get error estimations for each variable
mlim.error(MLIM, irisNA, iris, varwise = TRUE)
}
}
\author{
E. F. Haghish
}
