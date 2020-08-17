library(networkD3)

URL <- paste0("From_model_to_sankey/mpafx6.json")

QPM <- jsonlite::fromJSON(URL)
sankeyNetwork(Links = QPM$links, Nodes = QPM$nodes, Source = "source",
              Target = "target", Value = "value", NodeID = "name",
              units = "TWh", fontSize = 12, nodeWidth = 30)

