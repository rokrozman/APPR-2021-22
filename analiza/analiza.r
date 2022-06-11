# 4. faza: Napredna analiza podatkov

#V analizi bom porabil metodo strojenga ucenja
# za napovedovanje ali igralec igra na poziciji
# napadalca ali ne

# to je seveda klasifikacijski problem

#opomba: Za izbirni predmet imam ITAP (izbrane teme iz analize podatkov)
# kjer se ucimo o strojnem ucenju

library(caret)
library(kernlab)

podatki = read.csv("podatki/podatki_v.csv", fileEncoding = "utf8") 
podatki = podatki %>% 
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

#za metodo sem izbral podporne vektorje
model_SVM <- train(ciljna ~., data = ucna,
                   method="svmLinear",
                   metric = "Accuracy",
                   tuneGrid=data.frame(C=0.1),
                   trControl = trainControl(method = "cv",
                                            number = 10))


napoved_svm = predict(model_SVM, newdata = testna)
natancnost_svm = sum(napoved_svm == testna$ciljna) / nrow(testna) *100
sprintf("Natancnost je: %.7f odstotkov", natancnost_svm)























