% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/class_ChartScrollbar.R
\docType{class}
\name{ChartScrollbar-class}
\alias{ChartScrollbar-class}
\title{ChartScrollbar class}
\description{
Creates a scrollbar for amSerialChart and amXYChart charts.
}
\details{
Run \code{api("ChartScrollbar")} for more information and all avalaible properties.
}
\section{Slots}{

\describe{
\item{\code{enabled}}{\code{logical}.
Specifies if the chart should be updated while dragging/resizing the scrollbar
or only at the moment when user releases mouse button.}

\item{\code{graph}}{\code{list}.
Specifies which graph properties will be displayed in the scrollbar.
Only Serial chart's scrollbar can display a graph.}

\item{\code{listeners}}{\code{list} containining the listeners to add to the object.
The list must be named as in the official API. Each element must be a character string.}

\item{\code{otherProperties}}{\code{list}
containing other avalaible properties not yet implemented in the package.}

\item{\code{value}}{\code{numeric}.}
}}

\author{
datastorm-open
}
