package_docs <- function(pkg) {
  help_dir <- system.file("help", package = pkg)
  db_path <- file.path(help_dir, pkg)
  docs <- tools:::fetchRdDB(db_path)
  out <- docs %>%
      map_df(~parse_document_list(., pkg))
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

write_anki_df <- function(pkg, path) {
    write.csv(generate_anki_df(pkg), path)
}
