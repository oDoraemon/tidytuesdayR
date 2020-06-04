#' Get Master List of Files from TidyTuesday
#'
#' Import or update dataset from github that records the entire list of objects from tidytuesday
#'
#' @param force force the update to occur even if the SHA matches
#' @param auth github Personal Access Token. See PAT section for more information
#'
#' @section PAT:
#'
#' A Github PAT is a personal Access Token. This allows for signed queries to
#' the github api, and increases the limit on the number of requests allowed from
#' 60 to 5000. Follow instructions https://happygitwithr.com/github-pat.html
#' to set the PAT.
#'
#' @keywords internal
#' @importFrom utils read.csv
tt_update_master_file <- function(force = FALSE, auth = github_pat()){
  # get sha to see if need to update
  sha_df <- github_sha("static")
  sha <- sha_df$sha[sha_df$path == "tt_data_type.csv"]

  if( is.null(TT_MASTER_ENV$TT_MASTER_FILE) || sha != attr(TT_MASTER_ENV$TT_MASTER_FILE, ".sha") || force ){
    file_text <- github_contents("static/tt_data_type.csv", auth = auth)
    content <- read.csv(text = file_text, header = TRUE, stringsAsFactors = FALSE)
    attr(content,".sha") <- sha

    tt_master_file(content)
  }
}

#' Get Master List of Files from Local Environment
#'
#' return or update tt master file
#'
#' @param assign value to overwrite the TT_MASTER_ENV$TT_MASTER_FILE contents with
#'
#' @keywords internal
tt_master_file <- function(assign = NULL){
  if(!is.null(assign)){
    TT_MASTER_ENV$TT_MASTER_FILE <- assign
  }else{
    ttmf <- TT_MASTER_ENV$TT_MASTER_FILE
    if(is.null(ttmf)){
      tt_update_master_file()
      ttmf <- TT_MASTER_ENV$TT_MASTER_FILE
    }
    return(ttmf)
  }
}

#' The Master List of Files from TidyTuesday
#'
#' @keywords internal

TT_MASTER_ENV <- new.env()
TT_MASTER_ENV$TT_MASTER_FILE <- NULL

