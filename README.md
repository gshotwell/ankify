# ankify

The goal of ankify is to generate anki decks from R packages. This
is to assist in learning R functions using spaced repitition. For more
information on Anki visit the [Anki Website](https://apps.ankiweb.net/). For more on using spaced repitition to learn programming see this Michael Nielson [article](http://augmentingcognition.com/ltm.html). 

## Installation

You can install the released version of ankify from [CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("devtools")
devtools::install_github("GShotwell/ankify")
```

## Example

The package contains a few functions to parse a package's documentation into a dataframe. This is useful for creating a dataframe of documentation entries which you can then immport into anki. 

```
df <- generate_anki_df(purrr) 
# You can also write the csv in one step with `write_anki_df`
```

