package_docs <- function(pkg) {
  help_dir <- system.file("help", package = pkg)
  if (help_dir == "") {
      stop("No help files found for", pkg, "do you have the package installed?")
  }
  db_path <- file.path(help_dir, pkg)
  docs <- tools:::fetchRdDB(db_path)
  out <- docs %>%
      purrr::map_df(~parse_document_list(., pkg))
  return(out)
}

parse_document_list <- function(doc, pkg) {
    names(doc) <- doc %>% purrr::map_chr(~attr(., "Rd_tag"))
    doc <- doc %>%
        purrr::map(unlist)
    out <- tibble::data_frame(
        name = paste0(pkg, "::", doc[["\\name"]]),
        title = doc[["\\title"]],
        description = paste0(doc[["\\description"]], collapse = ""),
        examples = paste0(doc[["\\examples"]], collapse = "")
    )
    out[] <- purrr::map(out, as.character)
    return(out)
}

#' Generate a dataframe for anki cards
#'
#' This generates a dataframe of anki cards. The front of the card is
#' the function name, the back is the title, description, and examples.
#' Note that you need to have the package installed for this to work.
#'
#' @param pkg The package whose functions you want to memorize
#'
#' @return A dataframe
#' @export
#'
#' @examples
#' generate_anki_df("purrr")
generate_anki_df <- function(pkg) {
    docs <- package_docs(pkg)
    out <- tibble::data_frame(
        front = docs$name,
        back = paste(
            docs$title, docs$description, docs$examples, sep = "\n------\n"
        )
    )
    return(out)
}


#' Write an anki csv
#'
#' This writes an anki csv which can then be imported into the anki app
#'
#' @param pkg The name of the package whose functions you would like to
#' memorize
#' @param path Path for the exported csv
#'
#' @return Nothing, called for its side effects.
#' @export
#'
#' @examples
#' write_anki_df("purrr", "purrr.csv")
write_anki_df <- function(pkg, path) {
    utils::write.csv(generate_anki_df(pkg), path)
}
