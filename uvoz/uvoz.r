# 2. faza: Uvoz podatkov


library(dplyr)
library(readr)
library(tidyr)

#PL_17_18 = read.csv("podatki/england-premier-league-players-2017-to-2018-stats.csv", fileEncoding = "utf8") 
#PL_18_19 = read.csv("podatki/england-premier-league-players-2018-to-2019-stats.csv", fileEncoding = "utf8") 
#PL_19_20 = read.csv("podatki/england-premier-league-players-2019-to-2020-stats.csv", fileEncoding = "utf8")
#PL_20_21 = read.csv("podatki/england-premier-league-players-2020-to-2021-stats.csv", fileEncoding = "utf8")
#PL_21_22 = read.csv("podatki/england-premier-league-players-2021-to-2022-stats.csv", fileEncoding = "utf8")

PL_17_18 = read_csv("podatki/england-premier-league-players-2017-to-2018-stats.csv", locale = locale(encoding = "utf8"), col_types = cols(
  .default = col_guess(),
  position = col_factor())) 
PL_18_19 = read_csv("podatki/england-premier-league-players-2018-to-2019-stats.csv", locale = locale(encoding = "utf8"), col_types = cols(
  .default = col_guess(),
  position = col_factor()))
PL_19_20 = read_csv("podatki/england-premier-league-players-2019-to-2020-stats.csv", locale = locale(encoding = "utf8"), col_types = cols(
  .default = col_guess(),
  position = col_factor())) 
PL_20_21 = read_csv("podatki/england-premier-league-players-2020-to-2021-stats.csv", locale = locale(encoding = "utf8"), col_types = cols(
  .default = col_guess(),
  position = col_factor())) 
PL_21_22 = read_csv("podatki/england-premier-league-players-2021-to-2022-stats.csv", locale = locale(encoding = "utf8"), col_types = cols(
  .default = col_guess(),
  position = col_factor()))

###########################################################################################################################################
#------Vsi zbrani podatki, ki so le malo preoblikovani
###########################################################################################################################################

osnovno_preob = function(tabela) {
  tabela_p = tabela %>%
    select(ime.priimek=full_name, starost=age, datum.rojstva=birthday_GMT,
           sezona=season, pozicija=position, klub=`Current Club`, minute.skupno=minutes_played_overall,
           minute.doma=minutes_played_home, minute.gostovanje=minutes_played_away, nacionalnost=nationality, 
           nastopi.skupno=appearances_overall, nastopi.doma=appearances_home, nastopi.gostovanje=appearances_away, 
           goli.skupno=goals_overall, goli.doma=goals_home, goli.gostovanje=goals_away, asistence.skupno=assists_overall,
           asistence.doma=assists_home, asistence.gostovanje=assists_away, penal.zadet=penalty_goals,
           penal.zgresen=penalty_misses, nedotaknjena.mreza.skupno=clean_sheets_overall, 
           nedotaknjena.mreza.doma=clean_sheets_home, nedotaknjena.mreza.gostovanje=clean_sheets_away,
           prejeti.zadetki.skupno=conceded_overall, prejeti.zadetki.doma=conceded_home, 
           prejeti.zadetki.gostovanje=conceded_away,rumeni.kartoni=yellow_cards_overall, rdeci.kartoni=red_cards_overall,
           rank.napadalci=rank_in_league_top_attackers, rank.vezisti=rank_in_league_top_midfielders,
           rank.branilci=rank_in_league_top_defenders) %>%
    tidyr::extract(
      col=datum.rojstva,
      into = c("leto", "mesec", "dan"),
      regex = "(\\d{4})-(\\d{2})-(\\d{2})"
    ) %>%
    mutate_at(c("leto", "mesec", "dan"), as.numeric)
}

PL_17_18 = osnovno_preob(PL_17_18)
PL_18_19 = osnovno_preob(PL_18_19)
PL_19_20 = osnovno_preob(PL_19_20)
PL_20_21 = osnovno_preob(PL_20_21)
PL_21_22 = osnovno_preob(PL_21_22)

PL = rbind(PL_17_18, 
           PL_18_19, 
           PL_19_20,
           PL_20_21,
           PL_21_22)

PL %>% write.csv("podatki/podatki_v.csv", fileEncoding = "utf8")

###########################################################################################################################################
#-----Podatki, kjer so zbrani le igralci, ki so nastopali vseh 5 let in v 5-ih letih niso med sezono zamenjali kluba med sezono------------------------
###########################################################################################################################################

preob_1 = function(tabela){
  tabela_1 = tabela %>% 
    count(ime.priimek) %>% 
    filter(n == 1) %>% 
    inner_join(tabela, by="ime.priimek") %>%
    select(-n)
}

PL_17_18_p1 = preob_1(PL_17_18) 
PL_18_19_p1 = preob_1(PL_18_19) 
PL_19_20_p1 = preob_1(PL_19_20)
PL_20_21_p1 = preob_1(PL_20_21)
PL_21_22_p1 = preob_1(PL_21_22)


PL_p1_0 = rbind(PL_17_18_p1,
                PL_18_19_p1,
                PL_19_20_p1,
                PL_20_21_p1,
                PL_21_22_p1)

PL_p1 = PL_p1_0 %>%
  count(ime.priimek) %>%
  filter(n == 5) %>%
  inner_join(PL_p1_0, by="ime.priimek") 

PL_p1 %>% write.csv("podatki/podatki_1.csv", fileEncoding = "utf8")


###########################################################################################################################################
#------Podatki, kjer so zbrani samo klubi, ki nastopajo v vseh 5-ih sezonah
###########################################################################################################################################

k = PL_17_18 %>% distinct(klub)
j = PL_17_18 %>% distinct(klub) 
i = PL_18_19 %>% distinct(klub) 
l = PL_19_20 %>% distinct(klub)
h = PL_20_21 %>% distinct(klub)
g = PL_21_22 %>% distinct(klub)

skupni_klubi = k %>% inner_join(j, by = "klub") %>%
  inner_join(i, by = "klub")%>%
  inner_join(l, by = "klub")%>%
  inner_join(h, by = "klub")%>%
  inner_join(g, by = "klub")

PL_klubi = PL %>% filter(klub %in% skupni_klubi$klub)

PL_klubi %>% write.csv("podatki/podatki_2.csv", fileEncoding = "utf8")


###########################################################################################################################################
#--Drugi del podatkov, ki sem jih pobral iz transfermarkt-a
###########################################################################################################################################

library(rvest)   
library(polite)  
library(tidyr)   
library(purrr)   
library(stringr) 
library(glue)    
library(rlang) 

url = "https://www.transfermarkt.com/premier-league/startseite/wettbewerb/GB1/saison_id/2020/plus/1"
session = bow(url)

st_igralcev = scrape(session) %>%
  html_nodes(".no-border-links+ .zentriert") %>%
  html_text() 
st_igralcev = st_igralcev[c(1:20)]

povprecna_starost = scrape(session) %>%
  html_nodes("tbody .zentriert:nth-child(4)") %>%
  html_text()
povprecna_starost = povprecna_starost[c(1:20)]

stevilo_tujcev = scrape(session) %>%
  html_nodes("tbody .zentriert:nth-child(5)") %>%
  html_text()
stevilo_tujcev = stevilo_tujcev[c(1:20)]

povprecena_trzna_vrednost = scrape(session) %>%
  html_nodes("tbody .zentriert+ .rechts") %>%
  html_text()
povprecena_trzna_vrednost = povprecena_trzna_vrednost[c(1:20)]

celotna_trzna_vrednost = scrape(session) %>%
  html_nodes("tbody .rechts+ .rechts") %>%
  html_text()
celotna_trzna_vrednost = celotna_trzna_vrednost[c(1:20)]

klubi_2 = scrape(session) %>%
  html_nodes(".no-border-links") %>%
  html_text() 
klubi_2 = klubi_2[c(1:20)]

grbi = scrape(session) %>%
  html_nodes(".tiny_wappen") %>%
  html_attr("src")
grbi = grbi[c(1:20)]


data = list(klubi_2, 
            grbi,
            st_igralcev,
            povprecna_starost,
            stevilo_tujcev,
            povprecena_trzna_vrednost,
            celotna_trzna_vrednost)

imena_stolpcev = c("klub",
                   "grb",
                   "st.igralcev",
                   "povprecna.starost",
                   "stevilo.tujcev",
                   "povprecna.trzna.vrednost",
                   "celotna.trzna.vrednost")

PL_drugi_del = data %>% 
  reduce(cbind) %>% 
  tibble::as_tibble() %>% 
  set_names(imena_stolpcev)

PL_drugi_del = PL_drugi_del %>% 
  tidyr::extract(
    col = povprecna.trzna.vrednost,
    into = c("valuta", "povprecna_trzna_vrednost_v_mil"),
    regex = "^(.)(\\d*\\.\\d{2})m$"
  ) %>%
  tidyr::extract(
    col = celotna.trzna.vrednost,
    into = c("celotna_trzna_vrednost", "enota_za_cel_trzno_vr"),
    regex = "^.(\\d*\\.\\d{2})(m|bn)$"
  )  %>%
  mutate_at(c("st.igralcev", "povprecna.starost", 
              "stevilo.tujcev","povprecna_trzna_vrednost_v_mil",
              "celotna_trzna_vrednost"), as.numeric) %>%
  mutate(klub = str_replace(klub, "(\\s*FC\\s*)$", ""))%>%
  mutate(grb =  str_replace(grb, "/tiny/", "/head/"))
  
PL_drugi_del %>% write.csv("podatki/podatki_drugi_del.csv", fileEncoding = "utf8")


