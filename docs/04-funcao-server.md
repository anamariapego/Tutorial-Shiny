# **Função Server**

---

A função  do **server** contém três parâmetros: `input`, `output`, e `session`. Como você mesmo nunca chama a função do **server**, nunca criará esses objetos sozinhos. Em vez disso, eles são criados pelo Shiny quando a sessão começa, conectando-se de volta a uma sessão específica. Como qualquer outra função do R, quando a função **server** é chamada, ela cria um novo ambiente local que é independente de todas as outras chamadas da função. Isso permite que cada sessão tenha um estado único, além de isolar as variáveis criadas dentro da função. É por isso que quase toda a programação reativa que você fará no Shiny estará dentro da função **server**.

* O `input` é um objeto semelhante a uma lista que contém todos os dados de entradas enviados do navegador, nomeandos de acordo com o ID de entrada. 

* O `output` é bem semelhante ao input; também tem um objeto semelhante a uma lista nomeado de acordo com o ID de saída. A principal diferença é que você o usa para enviar saída em vez de receber entrada. Você sempre usa o objeto `output` em conjunto com uma função `render`. 


## **Outputs**

As saídas na **ui** criam espaços reservados que posteriormente são preenchidos pela função **server**. Como as entradas, as saídas recebem um ID exclusivo como primeiro argumento: se sua especificação de UI criar uma saída com ID 'plot', você a acessará na função de **server** com `output$plot`.

Cada função `output` no front-end é acoplada a uma função `render` no back-end. Existem três tipos principais de saída, correspondendo às três coisas que você geralmente inclui em um relatório: **textos**, **tabelas** e **gráficos**. 

Os pares de funções `output` e `render` que trabalham juntos para adicionar saída de R para o aplicativo shiny:


Função Output       | Função render | Cria
:---                | :---          | :---
htmlOutput/uiOutput | renderUI      | um objeto de tag Shiny ou HTML.
imageOutput         | renderImage	  | imagens (salvas como um link para um arquivo de origem).
plotOutput       	  | renderPlot	  | gráficos.
tableOutput	        | renderTable	  | quadro de dados, matriz, outras estruturas semelhantes a tabelas.
textOutput          | renderText	  | cadeias de caracteres.
verbatimTextOutput  | renderPrint	  | qualquer saída impressa.


### **Alguns exemplos de Outputs**

#### **Textos**

`textOutput()` saída de texto normal.

`verbatimTextOutput()` código fixo e saída de console.

`renderText()` combina o resultado em uma única string e geralmente é pareado com `textOutput`. 

`renderPrint()` imprime o resultado, como se você estivesse em um console R, e geralmente está emparelhado com `verbatimTextOutput`.



```r
library(shiny)
ui <- fluidPage(
  textOutput('texto'),
  verbatimTextOutput('codigo')
)
server <- function(input, output, session) {
  output$texto <- renderText('Hello world!')
  output$codigo <- renderPrint(summary(1:50))
}
shinyApp(ui = ui, server = server)
```


#### **Tabelas**

Existem duas maneiras de exibir um conjunto de dados em tabelas:

* `tableOutput()` e `renderTable()` cria  tabelas de dados estáticas e mostrando todos os dados de uma vez só. É mais útil para resumos pequenos e fixos.

`dataTableOutput()` e `renderDataTable()` cria tabelas dinâmicas, mostrando um número fixo de linhas e controles para alterar as linhas a serem visíveis. É mais útil para visualizar um conjunto de dados completo. 



```r
library(shiny)
ui <- fluidPage(
  tableOutput('linhas'),
  dataTableOutput('dados')
)
server <- function(input, output, session) {
  output$linhas <- renderTable(head(iris))
  output$dados <- renderDataTable(iris, options = list(pageLength = 7))
}
shinyApp(ui = ui, server = server)
```


#### **Gráficos**

Você pode gerar qualquer tipo de gráficos no R(no R base, com pacotes como ggplot2, highcharts e outros) com o `plotOutput()` e `renderPlot()`. 

Por padrão, `plotOutput()` ocupará toda a largura de seu contêiner. Você pode substituir esses padrões com os argumentos `height` e `width`. Os gráficos são saídas que também podem atuar como entradas. 



```r
library(shiny)
ui <- fluidPage(
  plotOutput('plot')
)
server <- function(input, output, session) {
  output$plot <- renderPlot(plot(1:10))
}
shinyApp(ui = ui, server = server)
```
