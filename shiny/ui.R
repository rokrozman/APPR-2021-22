
shinyUI(fluidPage(
  titlePanel(""),
  sidebarLayout(position = "left",
                sidebarPanel(
                  radioButtons(
                  "sezona1", 
                  label = "Sezona:",
                  choices = list("2017/2018" = "2017/2018", 
                                 "2018/2019" = "2018/2019",
                                 "2019/2020" = "2019/2020",
                                 "2020/2021"= "2020/2021",
                                 "2021/2022"= "2021/2022"),
                  selected = "2021/2022"),
                  selectInput(
                    "klub1",
                    label = "Klub:",
                    choices = c(
                      "Arsenal",
                      "Brighton & Hove Albion",
                      "Burnley",
                      "Chelsea",
                      "Crystal Palace",
                      "Everton",
                      "Leicester City",
                      "Liverpool",
                      "Manchester City",
                      "Manchester United",
                      "Newcastle United",
                      "Southampton",
                      "Tottenham Hotspur",
                      "West Ham United"
                    ),
                    selected = "Manchester City"
                  ))
                ,
                mainPanel(plotOutput("graf"))),
  uiOutput("izborTabPanel")))