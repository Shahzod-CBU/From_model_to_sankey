library(networkD3)

#URL <- paste0("D:/Programming/Modelling/MPAFx/mpafx6.json")
URL <- paste0("D:/Programming/Modelling/QPM_23062020/mpafx7.json")
QPM <- jsonlite::fromJSON(URL)
sankeyNetwork(Links = QPM$links, Nodes = QPM$nodes, Source = "source",
              Target = "target", Value = "value", NodeID = "name",
              units = "TWh", fontSize = 12, nodeWidth = 30)
