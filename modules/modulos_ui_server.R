# Função para converter variável para o tipo factor, ordena em frequência e agrupa os níveis
# após os 5 primeiros. 

func_redu <- function(df, var, n = 5) {
  df %>%
    mutate({{var}} := fct_lump(fct_infreq({{var}}), n = n)) %>%
    group_by({{var}}) %>%
    summarise(frequency = as.integer(sum(weight)))
}


analise_ui <- function(id){
  ns <- NS(id)
  
  prod_codes <- setNames(produtcs1$prod_code, produtcs1$title)
  
  tabItem(
    tabName = 'home',
    class = 'active',
    fluidRow(
      column(8,
             selectInput(ns('code'), 'Sports', choices = prod_codes))
    ),
    fluidRow(
      column(4, tableOutput(ns('diag'))),
      column(4, tableOutput(ns('body_part'))),
      column(4, tableOutput(ns('location')))
    ),
    fluidRow(
      column(2, actionButton(ns('nar'), 'Narrative')),
      column(10, textOutput(ns('narrativa')))
    ),
    fluidRow(
      column(12, plotOutput(ns('plot')))
    )
  )
}


analise_server <- function(input, output, session, dados){
  esporte_escolhido <- reactive(esportes %>% filter(prod_code == input$code))
  output$diag <- renderTable(
    func_redu(esporte_escolhido(), diag), width = '100%'
  )
  output$body_part <- renderTable(
    func_redu(esporte_escolhido(), body_part), width = '100%'
  )
  output$location <- renderTable(
    func_redu(esporte_escolhido(), location), width = '100%'
  )
  padrao <- reactive({esporte_escolhido %>% count(age, sex, wt = weight)})
  output$plot <- renderPlot({
    esporte_escolhido () %>%
      count(age, sex, wt = weight) %>% 
      ggplot(aes(age, n, colour = sex)) + 
      geom_line() + 
      labs(y = 'Number of injuries') +
      labs(x = 'Age') + 
      ggtitle('Injuries') +
      theme(plot.title = element_text(size = 17))
  })
  narrative_sample <- eventReactive(
    list(input$nar, esporte_escolhido()),
    esporte_escolhido() %>% pull(narrative) %>% sample(1)
  )
  output$narrativa <- renderText(narrative_sample())
}

