# Creating functions to get data 

box::use(
  dplyr[c_across, contains, filter, group_by, mutate,
        mutate_at, rowwise, select, summarize, vars],
  stats[quantile],
)

# Function to get returns data
returns_data <- function(data, start, end){
  data_results <- do.call(cbind,data$resultsD)
  data_summary <- data_results |>
    mutate(
      Date = `001.Date`,
      IBEX = `001.IBEX`,
      Means = data$resultsMEANS) |>
    mutate(
      Date = as.Date(Date)) |>
    filter(
      Date >= start & Date <= end
    ) |>
    mutate_at(vars(contains("Portre")), ~ replace(., 1, 1)) |>
    mutate(IBEX = replace(IBEX, 1, 1)) |>
    mutate(Means = replace(Means, 1, 1)) |>
    mutate_at(vars(contains("Portre")), ~ cumsum(.)) |>
    mutate(
       IBEX = cumsum(IBEX),
       Means = cumsum(Means)) |>
    group_by(Date) |>
    summarize(
     meanPortre = mean(c_across(contains("Portre"))),
     max_y = max(c_across(contains("Portre"))),
     min_y = min(c_across(contains("Portre"))),
     min_5 = unname(quantile(c_across(contains("Portre")),0.05)),
     max_95 = unname(quantile(c_across(contains("Portre")),0.95)),
     IBEX = IBEX,
     Means = Means)
}

# Function to get indicators data
indic_data <- function(data, start, end){
  data <- do.call(cbind,data$resultsD)
  data_summary <- data |>
    rowwise() |>
    mutate(
      Date = `001.Date`,
      meanmse = mean(c_across(contains("mse"))),
      meanrsqrd = mean(c_across(contains("rsqrd")))
    ) |>
    mutate(
      Date = as.Date(Date)) |>
    filter(
      Date >= start & Date <= end
    ) |>
    select(
      Date, meanmse,meanrsqrd
    )
}
