% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/across.R
\name{across}
\alias{across}
\alias{c_across}
\title{Apply a function (or a set of functions) to a set of columns}
\usage{
across(.cols = everything(), .fns = NULL, ..., .names = NULL)

c_across(cols = everything())
}
\arguments{
\item{.fns}{Functions to apply to each of the selected columns.
Possible values are:
\itemize{
\item \code{NULL}, to returns the columns untransformed.
\item A function, e.g. \code{mean}.
\item A purrr-style lambda, e.g. \code{~ mean(.x, na.rm = TRUE)}
\item A list of functions/lambdas, e.g.
\verb{list(mean = mean, n_miss = ~ sum(is.na(.x))}
}

Within these functions you can use \code{\link[=cur_column]{cur_column()}} and \code{\link[=cur_group]{cur_group()}}
to access the current column and grouping keys respectively.}

\item{...}{Additional arguments for the function calls in \code{.fns}.}

\item{.names}{A glue specification that describes how to name the output
columns. This can use \code{{.col}} to stand for the selected column name, and
\code{{.fn}} to stand for the name of the function being applied. The default
(\code{NULL}) is equivalent to \code{"{.col}"} for the single function case and
\code{"{.col}_{.fn}"} for the case where a list is used for \code{.fns}.}

\item{cols, .cols}{<\code{\link[=dplyr_tidy_select]{tidy-select}}> Columns to transform.
Because \code{across()} is used within functions like \code{summarise()} and
\code{mutate()}, you can't select or compute upon grouping variables.}
}
\value{
A tibble with one column for each column in \code{.cols} and each function in \code{.fns}.
}
\description{
\code{across()} makes it easy to apply the same transformation to multiple
columns, allowing you to use \code{\link[=select]{select()}} semantics inside in \code{\link[=summarise]{summarise()}} and
\code{\link[=mutate]{mutate()}}. \code{across()} supersedes the family of "scoped variants" like
\code{summarise_at()}, \code{summarise_if()}, and \code{summarise_all()}. See
\code{vignette("colwise")} for more details.

\code{c_across()} is designed to work with \code{\link[=rowwise]{rowwise()}} to make it easy to
perform row-wise aggregations. It has two differences from \code{c()}:
\itemize{
\item It uses tidy select semantics so you can easily select multiple variables.
See \code{vignette("rowwise")} for more details.
\item It uses \code{\link[vctrs:vec_c]{vctrs::vec_c()}} in order to give safer outputs.
}
}
\examples{
# across() -----------------------------------------------------------------
iris \%>\%
  group_by(Species) \%>\%
  summarise(across(starts_with("Sepal"), mean))
iris \%>\%
  as_tibble() \%>\%
  mutate(across(where(is.factor), as.character))

# A purrr-style formula
iris \%>\%
  group_by(Species) \%>\%
  summarise(across(starts_with("Sepal"), ~mean(.x, na.rm = TRUE)))

# A named list of functions
iris \%>\%
  group_by(Species) \%>\%
  summarise(across(starts_with("Sepal"), list(mean = mean, sd = sd)))

# Use the .names argument to control the output names
iris \%>\%
  group_by(Species) \%>\%
  summarise(across(starts_with("Sepal"), mean, .names = "mean_{.col}"))
iris \%>\%
  group_by(Species) \%>\%
  summarise(across(starts_with("Sepal"), list(mean = mean, sd = sd), .names = "{.col}.{.fn}"))
iris \%>\%
  group_by(Species) \%>\%
  summarise(across(starts_with("Sepal"), list(mean, sd), .names = "{.col}.fn{.fn}"))

# c_across() ---------------------------------------------------------------
df <- tibble(id = 1:4, w = runif(4), x = runif(4), y = runif(4), z = runif(4))
df \%>\%
  rowwise() \%>\%
  mutate(
    sum = sum(c_across(w:z)),
    sd = sd(c_across(w:z))
 )
}
