# **Módulos Shiny**

---

## **Introdução**

Agora vamos falar sobre o sistema de módulos do Shiny, que permite extrair a interface do usuário acoplada e o código do servidor em componentes isolados e reutilizáveis, além de deixar seu aplicativo mais limpo e organizado.

À medida que os aplicativos Shiny ficam maiores e mais complicados, usamos módulos para gerenciar a complexidade crescente do código do aplicativo Shiny.

Um módulo é um par de funções **ui** e funções **server**. A mágica dos módulos vem porque essas funções são construídas de uma maneira especial que cria um “namespace”. Até agora, ao escrever um aplicativo, os nomes dos controles `id`  são globais: todas as partes de sua função **server** podem ver todas as partes de sua ui. Os módulos oferecem a capacidade de criar controles que só podem ser vistos de dentro do módulo. Isso é chamado de namespace porque cria “espaços” de “nomes” que são isolados do resto do aplicativo.

Módulos Shiny têm duas grandes vantagens: 

- O namespacing torna mais fácil entender como seu aplicativo funciona porque você pode escrever, analisar e testar componentes individuais de forma isolada. 

- Como os módulos são funções, eles ajudam a reutilizar o código; tudo o que você pode fazer com uma função, você pode fazer com um módulo.


## **Módulo simples**

Vamos criar um aplicativo bem simples que desenha um histograma, que servirá para ilustrar a mecânica básica do funcionamento do módulo. 



```r
library(shiny)
ui <- fluidPage(
  selectInput('var', 'Variável', names(iris)),
  numericInput('bins', 'bins', 10, min = 1),
  plotOutput('hist')
)
server <- function(input, output, session) {
  data <- reactive(iris[[input$var]])
  output$hist <- renderPlot({
    hist(data(), breaks = input$bins, main = input$var)
  }, res = 96)
}
shinyApp(ui = ui, server = server)
```


Como um aplicativo, o módulo é composto por duas partes:

- A função de interface do usuário do módulo que gera a especificação `ui`.

- A função de servidor do módulo que executa o código dentro da função `server`.

As duas funções possuem formulários padrão. Ambos pegam um argumento `id` e o usam para definir o namespace do módulo. Para criar um módulo, precisamos extrair o código da **ui** do aplicativo e do servidor e colocá-lo na ui do módulo.

### **Módulo UI**

No módulo UI existem duas etapas:

- Coloca o código **ui** dentro de uma função que tenha um argumento `id`.

- Envolva cada ID exsitente em uma chamada `NS()`.

**Obs:** a função `NS()` cria IDs com namepace a partir de IDs vazios, os aplicativos Shiny usam IDs para identificar entradas e saídas. Esses IDs devem ser exclusivos em um aplicativo, pois o uso acidental do mesmo ID de entrada/saída mais de uma vez resultará em um comportamento inesperado. A solução tradicional para evitar conflitos de nomes são os namespaces; um namespace está para um ID como um diretório está para um arquivo. Use a função `NS()` para transformar um ID simples em um espaço de nomes, combinando-os com os intermediários `ns.sep`.



```r
histUI <- function(id) {
  tagList(
    selectInput(NS(id, 'var'), 'Variável', choices = names(iris)),
    numericInput(NS(id, 'bins'), 'bins', value = 10, min = 1),
    plotOutput(NS(id, 'hist'))
  )
}
```


Aqui, os componentes da **ui** foram retornado em a `tagList()`, que é um tipo especial de função de layout que permite agrupar vários componentes sem realmente sugerir como eles serão dispostos. É responsabilidade de quem está ligando `histUI()` envolver o resultado em uma função de layout como `column()` ou de `fluidRow()` acordo com suas necessidades.


### **Módulo Server**

A função **server** é empacotada dentro de outra função que deve ter um argumento `id`. Esta função chama `moduleServer()` com o `id` e uma função que se parece com uma função de servidor normal:



```r
histServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    data <- reactive(iris[[input$var]])
    output$hist <- renderPlot({
      hist(data(), breaks = input$bins, main = input$var)
    }, res = 96)
  })
}
```


Observe que `moduleServer()` cuida do namespace automaticamente: dentro de`moduleServer(id)`, `input$var` e `input$bins` consulta as entradas com nomes `NS(id, 'var')` e `NS(id, 'bins')`.

**Aplicativo atualizado**



```r
histogramApp <- function() {
  ui <- fluidPage(
    histUI('hist1')
  )
  server <- function(input, output, session) {
    histServer('hist1')
  }
  shinyApp(ui = ui, server = server)  
}

histogramApp() # chamando o aplicativo
```


## **Entradas e Saídas**

Os módulos podem representar entrada, saída ou ambos. Eles podem ser tão simples quanto uma única saída ou tão complicados quanto uma interface com várias guias repleta de controles/saídas orientados por múltiplas expressões reativas e observers.

Ás vezes, um módulo com apenas um argumento `id` para o módulo **ui** e o **server** é útil porque permite isolar o código complexo em seu próprio arquivo. Isso é particularmente útil para aplicativos que agregam componentes independentes, como um painel corporativo onde cada guia mostra relatórios personalizados para cada linha de negócios. Aqui, os módulos permitem que você desenvolva cada peça em seu próprio arquivo sem ter que se preocupar com o conflito de IDs entre os componentes.

Muitas vezes, no entanto, o módulo **ui** e o **server** precisarão de argumentos adicionais. Adicionar argumentos à **ui** do módulo oferece maior controle sobre a aparência do módulo, permitindo que você use o mesmo módulo em mais lugares em seu aplicativo. Mas a **ui** do módulo é apenas uma função R regular, portanto, há relativamente pouco a aprender que seja específico do Shiny. Ao contrário do código Shiny regular, conectar módulos requer que você seja explícito sobre entradas e saídas. Inicialmente, isso vai parecer cansativo. E é certamente mais trabalhoso do que a associação de forma livre usual de Shiny. Mas os módulos impõem linhas específicas de comunicação por um motivo: eles são um pouco mais trabalhosos de criar, mas muito mais fáceis de entender e permitem que você crie aplicativos substancialmente mais complexos.

Para ver como as entradas e saídas funcionam, vamos fazer um aplicativo simples, mas que ilustra alguns dos princípios básicos. Vamos criar um módulo que permite ao usuário selecionar um conjunto de dados a partir dos dados integradosfornecidos pelo pacote de conjuntos de dados. 

**Obs**: a função de um módulo **ui** deve ser um nome que é o sufixo `Input`, `Output` ou `UI`; por exemplo, `datasetInput`, `selecNumOutput`, ou `analiseUI`. 

Módulo UI: 



```r
datasetInput <- function(id, filter = NULL) {
  names <- ls('package:datasets')
  if (!is.null(filter)) {
    data <- lapply(names, get, 'package:datasets')
    names <- names[vapply(data, filter, logical(1))]
  }
  selectInput(NS(id, 'dataset'), 'Escolha um conjunto de dados:', choices = names)
}
```


Aqui, usamos um argumento adicional que possa limitar as opções do conjuntos de dados integrados que são data.frame (filter = is.data.frame) ou matrizes (filter = is.matrix). Este argumento filtra opcionalmente os objetos encontrados no pacote de conjuntos de dados e, em seguida, criamos um `selectInput`.  

Módulo Server: 

Usamos o `get` para recuperar o conjunto de dados com seu nome.



```r
datasetServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    reactive(get(input$dataset, 'package:datasets'))
  })
}
```


Criando o aplicativo com os módulos `datasetInput` e `datasetServer`: 



```r
datasetApp <- function(filter = NULL) {
  ui <- fluidPage(
    datasetInput('dataset', filter = filter),
    tableOutput('data')
  )
  server <- function(input, output, session) {
    data <- datasetServer('dataset')
    output$data <- renderTable(head(data()))
  }
  shinyApp(ui = ui, server = server)
}

datasetApp() 
```


Para usar o valor retornado no módulo `datasetServer`, só precisamos capturar o seu valor de retorno com (`data <- datasetServer('dataset')`) e exibimos o conjunto de dados no `tableOutput()`. É necessário um argumento `filter` que é passado para o módulo **ui**, facilitando a experiência com esse argumento de entrada. 
