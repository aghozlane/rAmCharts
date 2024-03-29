context("getTransformTS tests")

tz = "CET"
date.begin = "2010/10/30 00:00:00"
date.end = "2010/12/01 23:50:00"
vdate <- seq.POSIXt(as.POSIXct(date.begin, tz=tz),
                    as.POSIXct(date.end, tz=tz),
                    by="10 min")
data <- data.frame(date=vdate, value=rnorm(length(vdate)))

# for check type.aggre
data.last <- data
data.last$date <- data.last$date+600

test_that("getTransformTS & data.table object", {
  if (require(data.table)) {
    dt.ok <- getTransformTS(data = data.table(data), tz="CET", ts = "hour")
    expect_equal("data.frame", class(dt.ok))
    
    dt.ok <- getTransformTS(data = data.table(data), tz="CET", ts = "5 min")
    expect_equal("data.frame", class(dt.ok))
  }
})

test_that("getTransformTS variables name", {
  colnames(data)[2] <- "123"
  name.ok <- getTransformTS(data = data, tz = "CET", ts = "hour")
  expect_equal("data.frame", class(name.ok))
})

test_that("getTransformTS NA column", {
  data[, 2] <- NA
  class(data[, 2]) <- "numeric"
  na.ok <- getTransformTS(data = data, tz = "CET", ts = "hour")
  expect_equal("data.frame", class(na.ok))
})

test_that("getTransformTS tz", {
  cet <- getTransformTS(data = data, tz = "CET")
  expect_equal(cet, data)
  
  utc <- getTransformTS(data = data, tz = "UTC")
  data.utc <- data
  attr(data.utc$date, "tzone") <- "UTC"
  expect_equivalent(utc, data.utc)
})


test_that("getTransformTS NA", {
  data.na <- data
  data.na <- data.na[-c(5, 6, 10),]
  check <- getTransformTS(data=data.na, tz = "CET", control_date = TRUE)
  expect_equal(dim(data), dim(check))
  expect_true(all(is.na(check[c(5, 6, 10), 2])))
  
  check <- getTransformTS(data = data.na, tz = "CET", treat_missing = TRUE)
  expect_equal(dim(data), dim(check))
  expect_true(!any(is.na(check[, 2])))
  expect_equal(mean(data[c(9, 11), 2]), check[10, 2])
})


test_that("getTransformTS function", {
  data.mean <- getTransformTS(data, tz = "CET", ts = "30 min",
                                     fun_aggr = "mean")
  expect_equal(mean(data[1:3, 2]), data.mean[1, 2])
  
  data.sum <- getTransformTS(data, tz = "CET", ts = "30 min",
                             fun_aggr = "sum")
  expect_equal(sum(data[1:3, 2]), data.sum[1, 2])
  
  data.min <- getTransformTS(data, tz = "CET", ts = "30 min",
                             fun_aggr = "min")
  expect_equal(min(data[1:3, 2]), data.min[1, 2])
  
  data.max <- getTransformTS(data, tz = "CET", ts = "30 min",
                             fun_aggr = "max")
  expect_equal(max(data[1:3, 2]), data.max[1, 2])
})

test_that("getTransformTS full", {
  stats <- c("min", "max", "mean", "sum")
  ts <- c(10 * 60, 30 * 60, 60 * 60, 120 * 60, 180 * 60, 24 * 60 * 60)
  test <- expand.grid(stats, ts)
  ctrl <- sapply(1:nrow(test), function(x) {
    stats <- as.character(test[x, 1])
    ts <- test[x, 2]
    
    data.check.first <- getTransformTS(data, tz = "CET", ts = ts,
                                              fun_aggr = stats, type_aggr = "first")
    
    data.check.last <- getTransformTS(data.last, tz = "CET", ts = ts,
                                             fun_aggr = stats, type_aggr = "last")
    
    expect_equal(data.check.first[1:nrow(data.check.first), "value"], 
                 data.check.last[1:nrow(data.check.first), "value"])
  })
})

test_that("getTransformTS aggregation", {
  data.30.min <- getTransformTS(data, tz = "CET", ts = "30 min")
  expect_equal(mean(data[1:3, 2]), data.30.min[1, 2])
  
  data.hour <- getTransformTS(data, tz = "CET", ts = "hour")
  expect_equal(mean(data[1:6, 2]), data.hour[1, 2])
  
  data.2.hours <- getTransformTS(data, tz = "UTC", ts = "2 hour")
  expect_equal(mean(data[1:12, 2]), data.2.hours[1, 2])
  
  data.days <- getTransformTS(data, tz = "CET", ts = "day")
  expect_equal(mean(data[1:144, 2]), data.days[1, 2])
  
})


test_that("getTransformTS interpolation", {
  
  data.5.min <- getTransformTS(data, tz = "CET", ts = "5 min")
  expect_equal(mean(data[1:2, 2]), data.5.min[2, 2])
  
  vdate <- seq.POSIXt(as.POSIXct(date.begin, tz = tz),
                      as.POSIXct(date.end, tz = tz),
                      by = "2 hour")
  data <- data.frame(date = vdate, value = rnorm(length(vdate)))
  data.hour <- getTransformTS(data, tz = "CET", ts = "hour")
  expect_equal(mean(data[1:2, 2]), data.hour[2, 2])
})


test_that("getTransformTS control", {
  
  expect_error(getTransformTS(data, ts = "30 min", fun_aggr = "sd"))
  expect_error(getTransformTS(data, ts = 10))
  expect_error(getTransformTS(data, col_date = "wrongname"))
  expect_error(getTransformTS(data, col_quanti = "wrongname"))
  
  # exotic sequence
  expect_error(getTransformTS(data, ts = "15 min"))
  expect_error(getTransformTS(data, ts = "25 min"))
  expect_error(getTransformTS(data, ts = "80 min"))
  expect_error(getTransformTS(data, ts = 90*60))
  expect_error(getTransformTS(data, ts = 5*60*60))
  expect_error(getTransformTS(data, ts = "5 hour"))
  expect_error(getTransformTS(data, ts = "36 hour"))
  expect_error(getTransformTS(data, ts = "450 day"))
  
  # warning on head and tail
  expect_warning(getTransformTS(data, ts = 4*60*60, tz = "UTC", showwarn = T))
  expect_warning(getTransformTS(data[-1, ], ts = "hour", tz = "CET", showwarn = T))
  expect_warning(getTransformTS(data[-nrow(data), ], ts = "hour", tz = "CET", showwarn = T))
  
  #check quanti
  data.notquanti <- cbind(data, valuechar = as.character(data$value), stringsAsFactors = FALSE)
  expect_error(getTransformTS(data.notquanti, col_quanti = c("value", "valuechar")))
  
})
