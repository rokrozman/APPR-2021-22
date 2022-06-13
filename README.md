# Analiza podatkov s programom R - 2021/22

Vzorčni repozitorij za projekt pri predmetu APPR v študijskem letu 2021/22. 

## Tematika

Analiziral bom klube, ki so bili del Premier Lige v letih od 2017-2021. 

### Uvoz podatkov
Podatke za analizo sem pridobil iz dveh virov oz. spletnih strani
- [Statistike za igralce PL za sezone od 2017/2018 do 2021/2022](https://footystats.org/england/premier-league), podatke sem dobil za vsako sezono posebej v obliki **csv**.
- [Podatki o tržnih vrednostih klubov PL za sezono 2019/2020](https://www.transfermarkt.com/premier-league/startseite/wettbewerb/GB1/saison_id/2020/plus/1), podatke sem *"scrape-al"* iz spletne strani v obliki **html**.

Podatke sem nato očistil v datoteki `uvoz.r`.

----

### Vizualizacija

Vizualizacijo sem naredil v datoteki `vizualizacija.r`. Naredil sem jo tudi v R Notebook-u, datoteka `vizualizacija.Rmd`.
Prvo sem naredil primerjavo med klubi skozi vse sezone in se nato osredotočil na sezono **2019/2020**, ker sem podatke o tržnih vrednostih pridobil za to sezono. V drugem delu sem podrobneje pogledal še klub **Manchester City**. Na koncu pa še naredil vizualizacijo na zemljevidu Evrope.

---- 

### Analiza

Za 4. fazo sem si izbral, da bom naredil napovedni model s pomočjo strojnega učenja, ki napoveduje ali dani igralec na podlagi podatkov, ki jih imam na voljo, igra na poziciji napadalca ali ne. Za napovedne spremenljivke sem vzel skoraj vse numerične spremenljivke. To je seveda **klasifikacijski** problem, zato sem si za napovedni model izbral model, ki uporablja metodo `svmLinear`, torej **metodo podpornih vektorjev**.
* Natančnost modela: **85,6 %**



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
