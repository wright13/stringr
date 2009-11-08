#' Detect the presence or absence of a pattern in a string
#'
#' @param string input character vector
#' @param pattern pattern to look for.  See \code{\link{regex}} for
#'   description.
#' @value boolean vector
#' @seealso \code{\link{grepl}} which this function wraps
#' @examples
#' fruit <- c("apple", "banana", "pear", "pinapple")
#' str_detect(fruit, "a")
#' str_detect(fruit, "^a")
#' str_detect(fruit, "a$")
#' str_detect(fruit, "b")
#' str_detect(fruit, "[aeiou]")
str_detect <- function(string, pattern) {
  results <- grepl(pattern, string)
  is.na(results) <- is.na(string)
  
  results
}

#' Locate the position of the first occurence of a pattern in a string.
#'
#' @param string input character vector
#' @param pattern pattern to look for.  See \code{\link{regex}} for
#'   description.
#' @value numeric matrix.  First column gives start postion of match, and
#'   second column gives end position.
#' @seealso \code{\link{regexpr}} which this function wraps
#' @seealso \code{\link{str_extract}} for a convenient way of extracting 
#'   matches
#' @seealso \code{\link{str_locate_all}} to locate position of all matches
str_locate <- function(string, pattern) {
  match <- regexpr(pattern, string)  
  
  start <- as.vector(match)
  end <- start + attr(match, "match.length") - 1
  
  missing <- start == -1
  start[missing] <- NA
  end[missing] <- NA
  
  cbind(start = start, end = end)
}

#' Locate the position of all occurences of a pattern in a string.
#'
#' @param string input character vector
#' @param pattern pattern to look for.  See \code{\link{regex}} for
#'   description.
#' @value list of numeric matrices.  First column gives start postion of
#'   match, and second column gives end position.
#' @seealso \code{\link{regexpr}} which this function wraps
#' @seealso \code{\link{str_extract}} for a convenient way of extracting 
#'   matches
#' @seealso \code{\link{str_locate}} to locate position of first match
str_locate_all <- function(string, pattern) {
  matches <- gregexpr(pattern, string)  
  llply(matches, function(match) {
    if (length(match) == 1 && match == -1) return(NULL)
    
    start <- as.vector(match)
    end <- start + attr(match, "match.length") - 1
    cbind(start = start, end = end)
  })
}

#' Extract pieces of a string that match a pattern.
#'
#' @param string input character vector
#' @param pattern pattern to look for.  See \code{\link{regex}} for
#'   description.
#' @value list of character vectors.
str_extract <- function(string, pattern) {
  positions <- str_locate_all(string, pattern)
  llply(seq_along(string), function(i) {
    position <- positions[[i]]
    substring(string[i], position[, "start"], position[, "end"])
  })
}

#' Replace replaced occurences of a matched pattern in a string.
#'
#' @param string input character vector
#' @param pattern pattern to look for.  See \code{\link{regex}} for
#'   description.
#' @value character vector.
#' @seealso \code{\link{gsub}} which this function wraps
str_replace <- function(string, pattern, replacement) {
  gsub(pattern, replacement, string)
}


#' Split up a string by a pattern
#' 
#' @param string input character vector
#' @param pattern pattern to split up string by.  See \code{\link{regex}} for
#'   description.  If \code{NA}, returns original string.  If \code{""} splits
#'   into individual characters.
#' @value a list of character vectors.
#' @seealso \code{\link{strsplit}} which this function wraps
str_split <- function(string, pattern) {
  strsplit(pattern, string)
}
