# 4. faza: Napredna analiza podatkov

###################################################################
# CLUSTERING
###################################################################


podatki_0 = read.csv("podatki/podatki_v.csv", fileEncoding = "utf8") 
podatki_clus = podatki_0 %>% filter(sezona == "2019/2020", minute.skupno >1000) %>% select(pozicija, goli.skupno, rumeni.kartoni)


podatki_clus$pozicija[podatki_clus$pozicija == "Forward"] = "N"
podatki_clus$pozicija[podatki_clus$pozicija == "Defender"] = "B"
podatki_clus$pozicija[podatki_clus$pozicija == "Midfielder"] = "V"
podatki_clus$pozicija[podatki_clus$pozicija == "Goalkeeper"] = "G"

graf_clus_1 = podatki_clus %>%
  ggplot() +
  geom_point(
    mapping = aes(x = goli.skupno, y = rumeni.kartoni, fill = pozicija),
    size = 2
  ) 

dendrogram = podatki_clus[, -1] %>%
  dist() %>%
  hclust()

plot(
  dendrogram,
  labels = podatki_clus$pozicija,
  ylab = "višina",
  main = NULL
)

graf_clus_2 = tibble(
  k = 307:1,
  visina = dendrogram$height
) %>%
  ggplot() +
  geom_line(
    mapping = aes(x = k, y = visina),
    color = "blue"
  ) +
  geom_point(
    mapping = aes(x = k, y = visina),
    color = "blue"
  ) +
  scale_x_continuous(
    breaks = rev(seq(0, 300,30 ))
  ) +
  labs(
    x = "število skupin (k)",
    y = "višina združevanja"
  ) +
  xlim(0, 8) +
  theme_classic()
#graf_clus_2

skupine.2 = dendrogram %>% cutree(k = 4) %>% as.ordered()

diagram.skupine = function(podatki, oznake, skupine, k) {
  podatki = podatki %>%
    bind_cols(skupine) %>%
    rename(skupina = ...4)
  
  d = podatki %>%
    ggplot(
      mapping = aes(
        x = goli.skupno, y = rumeni.kartoni, color = pozicija
      )
    ) +
    geom_point() +
    geom_label(label = oznake, size = 2) +
    scale_color_hue() +
    theme_classic()
  
  for (i in 1:k) {
    d = d + geom_encircle(
      data = podatki %>%
        filter(skupina == i)
    )
  }
  d
}

diagram_clus = diagram.skupine(podatki_clus, podatki_clus$pozicija, skupine.2, 4)


###################################################################
###################################################################
#STROJNO UCENJE

#V analizi bom porabil metodo strojenga ucenja
# za napovedovanje ali igralec igra na poziciji
# napadalca ali ne

# to je seveda klasifikacijski problem



podatki = podatki_0 %>%
  filter(minute.skupno >1000) %>%
  select(starost, leto, 
         minute.skupno, minute.doma, minute.gostovanje,
         goli.skupno, goli.doma, goli.gostovanje,
         nastopi.skupno, nastopi.doma, nastopi.gostovanje,
         asistence.skupno, asistence.doma, asistence.gostovanje,
         penal.zadet, penal.zgresen, nedotaknjena.mreza.skupno,
         prejeti.zadetki.doma, prejeti.zadetki.skupno, prejeti.zadetki.gostovanje,
         rumeni.kartoni, rdeci.kartoni,
         ciljna = pozicija
) 

#predobdelava
podatki$ciljna[podatki$ciljna != "Forward"] = "N"
podatki$ciljna[podatki$ciljna == "Forward"] = "Y"
podatki$ciljna %>% as.factor()

#razdelimo mnozico na ucna in testno
indeks_ucna = createDataPartition(podatki$ciljna, p = 0.8, list = FALSE)
ucna = podatki[indeks_ucna,]
testna = podatki[-indeks_ucna,]


###################################################################
# 1. METODA PODPORNIH VEKTORJEV
###################################################################

#za metodo sem izbral podporne vektorje
model_svm <- train(ciljna ~., data = ucna,
                   method="svmLinear",
                   metric = "ROC",
                   tuneGrid=data.frame(C=0.1),
                   trControl = trainControl(method = "cv",
                                            number = 10,
                                            savePredictions = TRUE,
                                            classProbs = TRUE,
                                            summaryFunction = twoClassSummary))

#izracunamo natancnost
napoved_svm = predict(model_svm, newdata = testna)
natancnost_svm = sum(napoved_svm == testna$ciljna) / nrow(testna) *100
sprintf("Natancnost je: %.7f odstotkov", natancnost_svm)


#pogledamo se AUC
AUC_svm = roc.curve(scores.class0 = model_svm$pred$Y[model_svm$pred$obs == "Y"], 
                            scores.class1 = model_svm$pred$Y[model_svm$pred$obs == "N"],
                            curve = TRUE)
plot(AUC_svm)


###################################################################
# 1. METODA NAKLJUČNIH GOZDOV
###################################################################

model_rf <- train(ucna[,1:22], ucna[,23], 
                        method='rf', 
                        metric ="ROC", 
                        trControl = trainControl(method = "cv",
                                                 number = 10,
                                                 savePredictions = TRUE,
                                                 classProbs = TRUE,
                                                 summaryFunction = twoClassSummary),
                        ntree=100)

#izracunamo natancnost
napoved_rf = predict(model_rf, newdata = testna)
natancnost_rf = sum(napoved_rf == testna$ciljna) / nrow(testna) *100
sprintf("Natancnost je: %.7f odstotkov", natancnost_rf)


#pogledamo se AUC
AUC_rf = roc.curve(scores.class0 = model_rf$pred$Y[model_rf$pred$obs == "Y"], 
                    scores.class1 = model_rf$pred$Y[model_rf$pred$obs == "N"],
                    curve = TRUE)

plot(AUC_rf)












