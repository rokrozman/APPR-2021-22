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

klubi = podatki_2 %>% group_by(klub) %>% count() %>% select(klub)  #a ta nacin naredil, zato da so urejeni klubi
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

tabela_1 %>%
  ggplot(
    mapping = aes(x = reorder(klub, -n), y = n, fill = klub, colors(distinct = FALSE))
  ) +
  geom_bar(
    width = 0.8,
    stat = "identity") +
  labs(
    x = "Klub",
    y = "Stevilo razlicnih drzav",
    title = "Premier League",
    subtitle = "V sezoni 2019/2020"
  ) +
  theme_classic() +
  theme(
    axis.text.x = element_text(angle = 90,vjust = 0.5),
    axis.title.x = element_text(vjust = 0)
  ) +
  scale_color_gradientn(colours = rainbow(15))


###############################################################################
# Graf 2
###############################################################################

tabela_1 %>%
  ggplot(
    mapping = aes(x = "", y = n, fill = klub, colors(distinct = FALSE))
  ) +
  geom_bar(
    width = 0.8,
    stat = "identity") +
  labs(
    x = "Klub",
    y = "Stevilo razlicnih drzav",
    title = "Premier League",
    subtitle = "V sezoni 2019/2020"
  ) +
  theme_classic() +
  theme(
    axis.text.x = element_text(angle = 0,vjust = 0.5),
    axis.title.x = element_text(vjust = 0)
  ) +
  scale_color_gradientn(colours = rainbow(15)) +
  coord_polar("y")


###############################################################################
# Graf 3
###############################################################################

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

tabela_3 %>%
  mutate(fokus = ifelse(klub == "MUN", 0.2, 0)) %>%
  ggplot() +
  geom_arc_bar(aes(x0 = 0, y0 = 0, r0 = 0.7, r = 1, amount = n, fill = klub, explode= fokus), alpha = 0.3, stat = "pie") +
  labs(
    title = "Delez tujcev, glede na skupno stevilo",
    subtitle = "V sezoni 2019/2020",
    caption = "Izpostavljen je Manchester City",
    x = "",
    y = "")+
  theme_no_axes() +
  guides(fill=guide_legend(ncol=2)) +
  theme(legend.position="right")


###############################################################################
# Graf 4
###############################################################################

tabela_3_1 = podatki_2 %>% 
  group_by(klub, sezona) %>%
  summarise(vsi_goli = sum(goli.skupno) , doma_goli = sum(goli.doma)) %>%
  mutate(delez.domacih.golov = doma_goli / vsi_goli) %>%
  mutate(klub = replace(klub, klub == "Brighton & Hove Albion", "Brighton")) %>%
  filter(klub == "Manchester City") %>%
  mutate(delez.gostujocih.golov = 1 - delez.domacih.golov) %>%
  pivot_longer(
    cols = c("delez.domacih.golov","delez.gostujocih.golov"),
    names_to =  "Podatek",
    values_to = "Vrednost"
  )

tabela_3_1 %>% group_by(sezona) %>%
  ggplot(
    mapping = aes(x = sezona, y =vrednost , fill = podatek)
  ) +
  geom_bar(
    stat = "identity",
    position = position_fill()
  ) + 
  labs(
    title = "Premier League",
    subtitle = "Manchester City",
    x = "Sezona",
    y = "Delez",
    fill = "Domaci vs. Gostujoci"
  )+
  theme_classic() +
  theme(
    axis.text.x = element_text(angle = 0, vjust = 0.5),
    axis.title.x = element_text(vjust = 0))



###############################################################################
# Graf 5
###############################################################################

tabela_2 = podatki_2 %>% 
  group_by(klub, sezona) %>%
  summarise(vsi_goli = sum(goli.skupno) , doma_goli = sum(goli.doma)) %>%
  mutate(delez.domacih.golov = doma_goli / vsi_goli) %>%
  mutate(klub = replace(klub, klub == "Brighton & Hove Albion", "Brighton"))


tabela_2 %>%
  ggplot(
    mapping = aes(x = sezona, y = delez.domacih.golov, color = klub, group = klub)
  ) +
  geom_point()+
  geom_line() +
  theme_light()+
  theme(
    axis.text.x = element_text(angle = 90,vjust = 0.5),
    axis.title.x = element_text(vjust = 0)
  ) + 
  
  labs(
    x = "Sezona",
    y = "Delez golov zadetih doma",
    title = "Premier League"
  )+
  facet_wrap(~ klub, ncol = 4) 


###############################################################################
# Graf 6
###############################################################################

podatki_3 %>% 
  ggplot(aes(x = povprecna.starost, y = povprecna_trzna_vrednost_v_mil)) +
  geom_image(aes(image = grb), size = 0.065) +
  scale_x_continuous(breaks = pretty_breaks(5),
                     limits = c(24, 29) ) +
  scale_y_continuous(labels = comma,
                     breaks = pretty_breaks(5)) +
  labs(
    x = "Povprecna starost",
    y = "Povprecna trzna vrednost",
    title = "Premier League",
    subtitle = "V sezoni 2019/2020",
    caption = "Trzna vrednost je v milijonih evrov"
  )+
  theme_minimal() 



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


