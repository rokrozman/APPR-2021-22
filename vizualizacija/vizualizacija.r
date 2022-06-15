# 3. faza: Vizualizacija podatkov
library(readr)
library(dplyr)
library(ggplot2)
library(ggforce)
library(ggimage)
library(scales)
library(tidyr)

###############################################################################
# Podatki
###############################################################################

podatki_v = read.csv("podatki/podatki_v.csv", fileEncoding = "utf8")
podatki_1 = read.csv("podatki/podatki_1.csv", fileEncoding = "utf8")
podatki_2 = read.csv("podatki/podatki_2.csv", fileEncoding = "utf8") 
podatki_3 = read.csv("podatki/podatki_drugi_del.csv", fileEncoding = "utf8") 


###############################################################################
# Graf 1
###############################################################################
# prikazuje iz koliko razlicnih drzav prihajajo igralci za posamezen klub 
# za sezonon 2019/2020

klubi = podatki_2 %>% group_by(klub) %>% count() %>% select(klub)  #na ta nacin naredil, zato da so urejeni klubi
klub_kratica = tibble(klub = klubi$klub,
                      kratica = c(
                        "ARS",
                        "BRI",
                        "BUR",
                        "CHE",
                        "CRY",
                        "EVE",
                        "LEI",
                        "LIV",
                        "MCI",
                        "MUN",
                        "NEW",
                        "SOT",
                        "TOT",
                        "WHU"
                      ))

tabela_1 = podatki_2 %>%  filter(sezona == "2019/2020")%>% select(nacionalnost, klub) %>% 
  group_by(klub, nacionalnost) %>% 
  distinct() %>% 
  group_by(klub) %>%
  count() %>%
  left_join(klub_kratica, by= "klub") %>%
  ungroup() %>%
  select(klub = kratica, n)

graf_1 = tabela_1 %>%
  ggplot(
    mapping = aes(x = reorder(klub, -n), y = n, fill = klub, colors(distinct = FALSE))
  ) +
  geom_bar(
    width = 0.8,
    stat = "identity") +
  labs(
    x = "Klub",
    y = "Število različnih držav",
    title = "Mednarodnost klubov",
    subtitle = "V sezoni 2019/2020"
  ) +
  theme_classic() +
  theme(
    axis.text.x = element_text(angle = 90,vjust = 0.5),
    axis.title.x = element_text(vjust = 0)
  ) +
  scale_color_gradientn(colours = rainbow(15))

print(graf_1)

###############################################################################
# Graf 2
###############################################################################
#Graf 2 prikazuje dejansko kaksen delez od vseh tujcev skupaj ima posamezen klub
#izpostavljen pa je tudi Manchester city, ki ga bom analiziral podrobneje se kasneje
# filtrirana je tudi sezona 2019/2020

klubi_2 = podatki_v %>% filter(sezona== "2019/2020") %>% group_by(klub) %>% count() %>% select(klub)
klub_kratica_2 = tibble(klub = klubi_2$klub,
                        kratica = c(
                          "BOU",
                          "ARS",
                          "AVL",
                          "BRI",
                          "BUR",
                          "CHE",
                          "CRY",
                          "EVE",
                          "LEI",
                          "LIV",
                          "MCI",
                          "MUN",
                          "NEW",
                          "NOR",
                          "SHE",
                          "SOT",
                          "TOT",
                          "WAT",
                          "WHU",
                          "WOL"
                        ))


tabela_3 = podatki_v %>% 
  select(klub, nacionalnost, sezona)%>% 
  filter(sezona == "2019/2020", nacionalnost != "England") %>%
  group_by(klub) %>% count()%>%
  left_join(klub_kratica_2, by= "klub") %>%
  ungroup() %>%
  select(klub = kratica, n)


graf_2 = tabela_3 %>%
  mutate(fokus = ifelse(klub == "MUN", 0.2, 0)) %>%
  ggplot() +
  geom_arc_bar(aes(x0 = 0, y0 = 0, r0 = 0.7, r = 1, amount = n, fill = klub, explode= fokus), alpha = 0.3, stat = "pie") +
  labs(
    title = "Delež tujcev, glede na skupno število",
    subtitle = "V sezoni 2019/2020",
    caption = "Izpostavljen je Manchester City",
    x = "",
    y = "",
    fill = "Klub")+
  theme_no_axes() +
  guides(fill=guide_legend(ncol=2)) +
  theme(legend.position="right")

print(graf_2)

###############################################################################
# Graf 3
###############################################################################
#graf 3 prikazuje za vsak klub posebej, koliksen je bil delez golov, ki
#so jih dosegli na gostovanju glede na vse gole, ki so jih dosegli
# in ta vrednost je prikazana skozi vseh 5 sezon

tabela_2 = podatki_2 %>% 
  group_by(klub, sezona) %>%
  summarise(vsi_goli = sum(goli.skupno) , goli_gostovanje = sum(goli.gostovanje)) %>%
  mutate(delez.golov.gostovanje = goli_gostovanje / vsi_goli) %>%
  mutate(klub = replace(klub, klub == "Brighton & Hove Albion", "Brighton"))

graf_3 = tabela_2 %>%
  ggplot(
    mapping = aes(x = sezona, y = delez.golov.gostovanje, color = klub, group = klub)
  ) +
  geom_point()+
  geom_line() +
  theme_light()+
  theme(
    axis.text.x = element_text(angle = 90,vjust = 0.5),
    axis.title.x = element_text(vjust = 0)
  ) + 
  
  labs(
    title = "Uspešnost klubov na gostovanjih",
    x = "Sezona",
    y = "Delež golov zadetih v gostovanju",
    color = "Klub"
  )+
  facet_wrap(~ klub, ncol = 4) 

print(graf_3)

###############################################################################
# Graf 4
###############################################################################
# Graf 4 prikazuje delez tujcev v klubu za vse klube, pri cemer je
# izpostavljen manchester city

tabela_6 = podatki_2 %>% 
  select(klub, nacionalnost, sezona) %>%
  group_by(klub, nacionalnost, sezona) %>%
  count() %>%
  filter(nacionalnost == "England") %>%
  select(klub, sezona, stevilo_anglezev = n)

tabela_6_2 = podatki_2 %>% 
  select(klub, nacionalnost, sezona) %>%
  group_by(klub, nacionalnost, sezona) %>%
  count() %>%
  filter(nacionalnost != "England") %>%
  group_by(klub, sezona) %>%
  summarise(st.tujcev = sum(n))

tabela_6_3 = tabela_6 %>% full_join(tabela_6_2, by = c("klub", "sezona")) %>%
  ungroup()%>%
  mutate(delez.tujcev.klub = st.tujcev / (st.tujcev + stevilo_anglezev)) %>%
  select(klub, sezona, delez.tujcev.klub)

tabela_6_4 = podatki_2 %>% 
  group_by(klub, sezona) %>%
  summarise(vsi_goli = sum(goli.skupno) , goli_gostovanje = sum(goli.gostovanje)) %>%
  mutate(delez.golov.gostovanje = goli_gostovanje / vsi_goli) %>%
  ungroup()%>%
  select(klub, sezona,delez.golov.gostovanje )

tabela_6_koncna = tabela_6_3 %>% full_join(tabela_6_4, by = c("klub", "sezona"))


library(gghighlight)
graf_4 = tabela_6_koncna %>%
  ggplot(
    mapping = aes(x = sezona, y = delez.tujcev.klub, group = klub, color=klub)
  ) +
  geom_point()+
  geom_line()+
  gghighlight(klub == "Manchester City",  label_key = klub)+
  labs(
    title = "Premier League",
    x = "Sezona",
    y = "Delež tujcev v klubu") +
  theme_classic()

print(graf_4)

###############################################################################
# Graf 5
###############################################################################

#graf 5 prikazuje dve vrednosti za vsak klub in za vsako sezono
# velikost kroglice predstavlja delez tujcev v klubu
# barva kroglice pa predstavlja delez golov na gostovanju


graf_5 = tabela_6_koncna %>%
  ggplot(
    mapping = aes(x = sezona, y = klub )
  ) +
  geom_count(aes(size= delez.tujcev.klub,color = delez.golov.gostovanje)) +
  labs(
    x = "Sezona",
    y = "Klub",
    title = "Delež tujcev v klubu in delež golov na gostovanju",
    size = "Delež tujcev v klubu",
    color = "Delež golov na gostovanju"
  )

print(graf_5)

###############################################################################
# Graf 6
###############################################################################

#graf 6 prikazuje kaksen je bil delez golov na gostovanju in delez domacih golov 
# posledicno, za Manchester City za vse sezone

tabela_3_1 = podatki_2 %>% 
  group_by(klub, sezona) %>%
  summarise(vsi_goli = sum(goli.skupno) , goli_gostovanje = sum(goli.gostovanje)) %>%
  mutate(delez.golov.gostovanje = goli_gostovanje / vsi_goli) %>%
  filter(klub == "Manchester City") %>%
  mutate(delez.golov.doma = 1 - delez.golov.gostovanje) %>%
  pivot_longer(
    cols = c("delez.golov.doma","delez.golov.gostovanje"),
    names_to =  "podatek",
    values_to = "vrednost"
  )


graf_6 = tabela_3_1 %>% group_by(sezona) %>% 
  ggplot(
    mapping = aes(x = sezona, y =vrednost , fill = podatek)
  ) +
  geom_bar(
    stat = "identity",
    position = position_fill()
  ) + 
  labs(
    title = "Delež domačih golov vs delež golov na gostovanju",
    subtitle = "Manchester City",
    x = "Sezona",
    y = "Delež",
    fill = "Domači vs. Gostujoči"
  )+
  theme_classic() +
  theme(
    axis.text.x = element_text(angle = 0, vjust = 0.5),
    axis.title.x = element_text(vjust = 0))

print(graf_6)

###############################################################################
# Graf 7
###############################################################################

#graf 7 prikazuje pa obe statistiki za manchester city skupaj, pri cemer
# je narisana se regresijska premica

tabela_7 = tabela_6_koncna %>% filter(klub == "Manchester City") %>%
  pivot_longer(
    cols = c("delez.tujcev.klub","delez.golov.gostovanje"),
    names_to =  "podatek",
    values_to = "vrednost"
  ) 

graf_7 = tabela_7 %>%
  ggplot(
    mapping = aes(x = sezona, y =vrednost , group = podatek, colour = podatek)
  ) +
  geom_point()+
  geom_smooth(method="lm", se=FALSE)+
  labs(
    title = "Delež tujcev vs delež golov na gostovanju",
    subtitle = "Manchester City",
    x = "Sezona",
    y = "",
    colour = "Vrsta deleža") +
  theme_classic()

print(graf_7)

###############################################################################
# Graf 8
###############################################################################

#graf 8 sem kot zanimivost narisal in prikazuje kaksna je porazdelitev 
# stevila golov na gostovanju, kjer tudi locim med igralci glede na
# kateri poziciji igrajo

tabela_4 = podatki_v 
tabela_4$pozicija[tabela_4$pozicija == "Forward"] = "Napdalec"
tabela_4$pozicija[tabela_4$pozicija == "Defender"] = "Branilec"
tabela_4$pozicija[tabela_4$pozicija == "Midfielder"] = "Vezist"
tabela_4$pozicija[tabela_4$pozicija == "Goalkeeper"] = "Golman"


graf_9 = tabela_4 %>% filter(minute.skupno > 1000) %>%
  ggplot(
    mapping = aes(x = goli.gostovanje, fill =pozicija)
  ) +
  geom_area(
    mapping = aes(y = ..density..),
    stat = "bin", bins = 10
  )+
  labs(
    title = "Porazdelitev števila golov na gostovanju",
    x = "Število golov v gostovanju",
    y = "Gostota",
    fill = "Pozicija"
  )+
  theme_classic() 

print(graf_8)

###############################################################################
# Graf 9
###############################################################################

#Graf 9 kaze povezavo med povprecno trzno vrednostjo in povprecno starostjo
# za vsak klub posebej in za sezono 2019/2020

graf_9 = podatki_3 %>% 
  ggplot(aes(x = povprecna.starost, y = povprecna_trzna_vrednost_v_mil)) +
  geom_image(aes(image = grb), size = 0.065) +
  scale_x_continuous(breaks = pretty_breaks(5),
                     limits = c(24, 29) ) +
  scale_y_continuous(labels = comma,
                     breaks = pretty_breaks(5)) +
  labs(
    x = "Povprečna starost",
    y = "Povprečna tržna vrednost",
    title = "Povezava med povprečno starostjo in tržno vrednostjo",
    subtitle = "V sezoni 2019/2020",
    caption = "Tržna vrednost je v milijonih evrov"
  )+
  theme_minimal() 


print(graf_9)

###############################################################################
# Zemljevid
###############################################################################

library(mosaic)
source("lib/uvozi.zemljevid.r")

zemljevid <-
  uvozi.zemljevid(
    "http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
    "ne_50m_admin_0_countries",
    mapa = "zemljevidi",
    pot.zemljevida = "",
    encoding = "UTF-8"
  ) %>%
  fortify() %>% 
  filter(CONTINENT %in% c("Europe"), long < 50 & long > -30 & lat > 35 & lat < 85)


evropske.drzave = tibble(
  drzava = c(
    "Albania", "Andorra", "Armenia",
    "Austria", "Azerbaijan", "Belarus",
    "Belgium", "Bosnia and Herzegovina",
    "Bulgaria", "Croatia", "Cyprus",
    "Czechia", "Denmark", "Estonia",
    "Finland", "France", "Georgia",
    "Germany", "Greece", "Hungary",
    "Iceland", "Ireland", "Italy",
    "Kazakhstan", "Latvia",
    "Liechtenstein", "Lithuania",
    "Luxembourg", "Malta", "Moldova",
    "Monaco", "Montenegro",
    "Netherlands", "North Macedonia",
    "Norway", "Poland", "Portugal",
    "Romania", "Russia", "San Marino",
    "Serbia", "Slovakia", "Slovenia",
    "Spain", "Sweden", "Switzerland",
    "Turkey", "Ukraine", "United Kingdom",
    "Holy See (Vatican City)"
  )
)

tabela_zemljevid = podatki_v 
tabela_zemljevid$nacionalnost[tabela_zemljevid$nacionalnost == "England"] = "United Kingdom"
tabela_zemljevid$nacionalnost[tabela_zemljevid$nacionalnost == "Wales"] = "United Kingdom"
tabela_zemljevid$nacionalnost[tabela_zemljevid$nacionalnost == "Northern Ireland"] = "United Kingdom"
tabela_zemljevid$nacionalnost[tabela_zemljevid$nacionalnost == "Scotland"] = "United Kingdom"
tabela_zemljevid$nacionalnost[tabela_zemljevid$nacionalnost == "Republic of Ireland"] = "Ireland"
tabela_zemljevid$nacionalnost[tabela_zemljevid$nacionalnost == "FYR Macedonia"] = "North Macedonia"

zemljevid$NAME[zemljevid$NAME == "Bosnia and Herz."] = "Bosnia and Herzegovina"
colnames(zemljevid)[26] <- "nacionalnost"

tabela_zemljevid = tabela_zemljevid %>% select(nacionalnost= nacionalnost, rumeni.kartoni =rumeni.kartoni, rdeci.kartoni=rdeci.kartoni) %>%
  filter(nacionalnost %in% evropske.drzave$drzava) %>% 
  mutate(vsi.kartoni = sum(rdeci.kartoni) + sum(rumeni.kartoni)) %>%
  group_by(nacionalnost) %>% 
  summarise(agresivnost = (sum(rdeci.kartoni) + sum(rumeni.kartoni)) / sum(vsi.kartoni))

zemljevid_kartonov = tabela_zemljevid %>% right_join(zemljevid, by ="nacionalnost") %>%
  ggplot() +
  geom_polygon(
    mapping = aes(x = long, y = lat, group = group, fill = agresivnost),
    color = "grey") +
  labs(
    title = "Delež kartonov v Premier ligi",
    subtitle = "V sezonah 2017/2018 - 2021/2022",
  )+ 
  theme(axis.title=element_blank(), 
        axis.text=element_blank(), 
        axis.ticks=element_blank(), 
        panel.background = element_blank()) +
  scale_fill_gradient(low = munsell::mnsl("5B 7/8"),
                      high = munsell::mnsl("5Y 7/8")) +
  labs(fill="Delež kartonov") +
  geom_path(data = right_join(tabela_zemljevid, zemljevid, by = "nacionalnost"),
            aes(x = long, y = lat, group = group), 
            color = "white", size = 0.1)

print(zemljevid_kartonov)
