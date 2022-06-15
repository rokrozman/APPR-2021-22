library(shiny)


shinyServer(
  function(input, output)
  {
    output$graf <- renderPlot({
      narisi.graf(input$klub1, input$sezona1)
    })
  }
)

narisi.graf <- function(klubF, sezonaF)
{# pripravim tabelo:
  tabela_shiny_t <- podatki_2 %>% filter(klub == klubF, sezona == sezonaF) %>%
    group_by(klub, sezona) %>%
    summarise( vsi.zadeti.penali = sum(penal.zadet),  vsi.zgreseni.penali = sum(penal.zgresen)) %>%
    ungroup() %>%
    pivot_longer(
      cols = c("vsi.zadeti.penali", "vsi.zgreseni.penali"),
      names_to = "penal",
      values_to = "stevilo"
    ) %>%
    ggplot(
      mapping = aes(x = penal, y = stevilo, fill = penal, colors(distinct = FALSE))
    ) +
    geom_bar(
      width = 0.8,
      stat = "identity") +
    labs(
      x = "",
      y = "Število",
      title = "Primerjava zadetih in zgrešenih penalov",
      subtitle = "Za klub in sezono sezona",
      fill = "Zadet vs. zgrešen"
    )
  
  print(tabela_shiny_t)
}