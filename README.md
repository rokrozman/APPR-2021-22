# Analiza podatkov s programom R - 2021/22

Vzorčni repozitorij za projekt pri predmetu APPR v študijskem letu 2021/22. 

## Tematika

Analiziral bom igralce Premier Lige. Zbral sem podatke za sezone od leta 2017-2021.
To so vsa imena stolpecev, katere bo uporabil za analizo:
full_name"                      "age"                            "birthday"                      
 [4] "birthday_GMT"                   "league"                         "season"                        
 [7] "position"                       "Current Club"                   "minutes_played_overall"        
[10] "minutes_played_home"            "minutes_played_away"            "nationality"                   
[13] "appearances_overall"            "appearances_home"               "appearances_away"              
[16] "goals_overall"                  "goals_home"                     "goals_away"                    
[19] "assists_overall"                "assists_home"                   "assists_away"                  
[22] "penalty_goals"                  "penalty_misses"                 "clean_sheets_overall"          
[25] "clean_sheets_home"              "clean_sheets_away"              "conceded_overall"              
[28] "conceded_home"                  "conceded_away"                  "yellow_cards_overall"          
[31] "red_cards_overall"              

Stolpci so pravilnega tipa, torej dbl in Chr, ter date. Pri cemer bom stolpec date razdelil na tri.

## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`.
Ko ga prevedemo, se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`.
Potrebne knjižnice so v datoteki `lib/libraries.r`
Podatkovni viri so v mapi `podatki/`.
Zemljevidi v obliki SHP, ki jih program pobere,
se shranijo v mapo `../zemljevidi/` (torej izven mape projekta).
