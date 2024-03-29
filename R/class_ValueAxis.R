#' @include class_AxisBase.R utils_sharedGenerics.R
NULL

#' @title ValueAxis class
#' @author datastorm-open
#' 
#' @description Extension for ValueAxis to create an axis for amSerialChart, amRadarChart,
#' amXYChart charts, multiple can be assigned.
#' Gets automatically populated, one for amSerialChart and two for amXYChart charts,
#' if none has been specified.
#' @details Run \code{api("ValueAxis")} for more information and all avalaible properties.
#' 
#' @slot title \code{character}. Title of the axis.
#' @slot guides \code{list}.
#' @slot listeners \code{list} containining the listeners to add to the object.
#' The list must be named as in the official API. Each element must be a character string.
#' See examples for details.
#' @slot otherProperties \code{list}
#' containing other avalaible properties not yet implemented in the package.
#' @slot value \code{numeric}.
#' Guides belonging to this axis. Use addGuide method
#' 
#' @export
#' 
setClass(Class = "ValueAxis", contains = "AxisBase",
         representation = representation(title = "character"))

#' @title Initializes ValueAxis
#' @description Creates a ValuesAxis or updates its properties.
#' 
#' @param .Object \linkS4class{ValueAxis}.
#' @param title \code{character}.
#' @param guides \code{list} of \linkS4class{Guide}.
#' @param ... Other properties (depend of call function)
#' 
#' @examples
#' 
#' guides <- list(guide(fillAlpha = .4), guide(fillAlpha = .5))
#' new("ValueAxis", title = "Hello !",  gridThickness = 1, guides = guides)
#' 
#' \dontrun{
#' new("ValueAxis", title = "Hello !", 1) # 1 is not take into account
#' 
#' # If one element of guides is not a Guide object, it shows an error
#' guides <- list(guide(fillAlpha = .4), b = 1)
#' new("ValueAxis", title = "Hello !",  gridThickness = 1, guides = guides)
#' }
#' 
#' @rdname initialize-ValueAxis
#' @export
#' 
setMethod(f = "initialize", signature = c("ValueAxis"),
          definition = function(.Object, title, guides, ...)
          {            
            if (!missing(title)) .Object@title <- title
            if (!missing(guides) && is.list(guides)) .Object@guides <- lapply(guides, listProperties)
            .Object <- setProperties(.Object, ...)
            validObject(.Object)
            return(.Object)
          })

# CONSTRUCTOR ####

#' @rdname initialize-ValueAxis
#' 
#' @examples
#' valueAxis(title = "Hello !", axisTitleOffset = 12)
#' 
#' @export
#' 
valueAxis <- function(...)
{
  .Object <- new("ValueAxis", ...)
  validObject(.Object)
  return(.Object)
}

#' @rdname initialize-ValueAxis
#' 
#' @examples
#' setTitle(.Object = valueAxis(), title = "Hello !")
#' 
#' @export
#' 
setMethod(f = "setTitle", signature = c("ValueAxis", "character"),
          definition = function(.Object, title)
          { 
            .Object@title <- title
            validObject(.Object)
            return(.Object)
          })

