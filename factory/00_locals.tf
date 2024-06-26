locals {
  conf_sources = [
    { "source" : "meteo", "format" : "csv", "schedule" : "0 10 * * 0,3" },
    { "source" : "nps", "format" : "parquet", "schedule" : "0 10 * * 1,2" },
    { "source" : "stock_prices", "format" : "csv", "schedule" : "0 10 * * 1,3" },
    { "source" : "stock_orders", "format" : "csv", "schedule" : "0 10 * * 2,4" },
    { "source" : "elec_consump", "format" : "parquet", "schedule" : "0 10 * * 3,5" }
  ]

  schedule_gen_data = { for conf in local.conf_sources : conf["source"] => conf }

}