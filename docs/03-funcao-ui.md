# **Função UI**

---

Vamos adicionar algumas entradas e saídas na função **ui**. Faremos um aplicativo bem simples que mostre os dataframes integrados incluídos no pacote de conjuntos de dados.



```r
library(shiny)
ui <- fluidPage(
  selectInput('dataset', label = 'Datasets', choices = ls('package:datasets')),
  verbatimTextOutput('summary'),
  tableOutput('table')
)
server <- function(input, output, session) {}
shinyApp(ui = ui, server = server)
```


O código acima retorna uma página contendo uma caixa de seleção dos conjuntos dos dados.

*Funções usadas no trecho acima:*

* `fluidPage()` é um controle de layout que configura a estrututa visual básica da página. 

* `selectInput()` é o controle de entrada que permite ao usuário interagir com o aplicativo fornecendo o valor. Nesse caso, é uma caixa de seleção que permite que o usuário escolha um dos conjuntos de dados embutidos que vêm no R. 

* `verbatimTextOutput()` e `tableOutput()` são controles de saída que dizem ao Shiny onde colocar a saída renderizada. `verbatimTextOutput()` exibe códigos e `tableOutput()` exibe tabelas. 


 A **ui** é de fato um arquivo HTML. As funções, entradas e saídas de layout têm usos diferentes, mas são fundamentalmente os mesmos nos bastidores: são apenas maneiras sofisticadas de gerar HTML e, se você chamar qualquer uma delas fora de um aplicativo Shiny, verá uma página HTML impresso no console.

Vemos apenas a entrada porque ainda não dissemos ao Shiny como a entrada e as saídas estão relacionadas.


## **Comportamento da UI**

Agora vamos dizer ao Shiny como a entrada e as saídas estão relacionadas e definir a função **server**. 
O Shiny usa programação reativa para tornar os aplicativos interativos. Que será apresentada mais a frente com mais detalhes.

Diremos ao Shiny como preencher as saídas `summary` e `table` no aplicativo. Substitua sua função **server** vazia por esta:



```r
server <- function(input, output, session) {
    output$summary <- renderPrint({
    dataset <- get(input$dataset, 'package:datasets')
    summary(dataset)
  })
  output$table <- renderTable({
    dataset <- get(input$dataset, 'package:datasets')
    dataset
  })
}
```


*Funções usadas no trecho acima:*

* `output$summary` indica que você está fornecendo como será sua saída do Shiny com esse *summary*. 

* `renderPrint` usa a função de renderização específica para envolver algum código fornecido por você. Cada função `render{Type}` é projetada para produzir um tipo específico de saída (por exemplo, texto, tabelas e gráficos) e geralmente é associada a uma função Output{type}.

Por exemplo, neste aplicativo, `renderPrint()` é pareado com `verbatimTextOutput()` para exibir um resumo estatístico com texto de largura fixa e `renderTable()` é pareado com `tableOutput()` para mostrar os dados de entrada em uma tabela.

Observe que o resumo e a tabela são atualizados sempre que você altera o conjunto de dados de entrada. Essa dependência é criada implicitamente porque nos referimos `input$dataset` nas funções de saída. `input$dataset` é preenchido com o valor atual do componente de **ui** com id dataset e fará com que as saídas sejam atualizadas automaticamente sempre que esse valor mudar. 

Esta é a essência da **reatividade**: *as saídas reagem automaticamente (recalculam) quando suas entradas mudam.*

## **Inputs**

Todas as funções de entrada tem o mesmo primeiro argumento: `inputId`. Este é o identificador usado para conectar o front-end ao back-end: se a UI tiver uma entrada com ID 'name', a função do servidor irá acessá-la com `input$name`.

O `inputId` tem duas restrições:

* Deve ser uma string simples que contém apenas letras, números e sublinhados (sem espaços, travessões, pontos ou outros caracteres especiais permitidos!). Nomeie-o como se fosse uma variável em R.

* Deve ser único. Se não for exclusivo, você não terá como referir-se a esse controle na função **server**. 

A maioria das funções de entrada tem um segundo parâmetro chamado `label`. Isso é usado para criar um rótulo legível para o controle. 

O terceiro parâmetro é normalmente `value`, que quando possível, permite definir o valor padrão. Os parâmetros restantes são exclusivos do controle.

**Algumas funções padrões do Shiny:**


Funções            | Ações
:---------         | :---------
actionButton       | botão de ação.
checkboxGroupInput | um grupo de caixas de seleção.
checkboxInput      | uma única caixa de seleção.
dateInput	         | um calendário para ajudar na seleção de datas.
dateRangeInput     | um par de calendários para selecionar um intervalo de datas.
fileInput          | um assistente de controle de upload de arquivo.
helpText           | texto de ajuda que pode ser adicionado a um formulário de entrada.
numericInput       | um campo para inserir números.
radioButtons       | um conjunto de botões de opção.
selectInput	       | uma caixa com opções para selecionar.
sliderInput        | uma barra deslizante.
submitButton       | um botão de envio.
textInput	         | um campo para inserir texto.


### **Alguns exemplos de Inputs**

#### **Textos livres**

`textInput()` coleta uma pequena quantidade do texto.

`passwordInput()` coleta a senha. 

`textAreaInput()` parágrafo de texto.



```r
library(shiny)
ui <- fluidPage(
  textInput('nome', 'Qual é o seu nome?'),
  passwordInput('senha', 'Por favor inserir a senha:'),
  textAreaInput('anotacao', 'Em que podemos ajudar?')
)
server <- function(input, output, session) {}
shinyApp(ui = ui, server = server)
```


#### **Entradas numéricas** 

`numericInput()` cria uma caixa de texto restrita.

`sliderInput()` controle deslizante e aqui você pode definir um *intervalo* de valores. 



```r
library(shiny)
ui <- fluidPage(
  numericInput('num1', 'Primeiro número', value = 0, min = 0, max = 50),
  sliderInput('num2', 'Segundo número', value = 25, min = 0, max = 50),
  sliderInput('range', 'Intervalo', value = c(10, 20), min = 0, max = 50)
)
server <- function(input, output, session) {}
shinyApp(ui = ui, server = server)
```


#### **Datas**

`dateInput()` seleciona um único dia.

`dateRangeInput()` seleciona um intervalo de dois dias.



```r
library(shiny)
ui <- fluidPage(
  dateInput('primeiro', 'Quando você entrou no seu primeiro emprego?'),
  dateRangeInput('tempo', 'Por quanto tempo ficou nele?')
)
server <- function(input, output, session) {}
shinyApp(ui = ui, server = server)
```


O formato de data, o idioma e o dia em que a semana começa são padronizados para os padrões dos EUA. 
Você pode mudar essas configurações, definindo o `format`, `language`e `weekstart`. 



```r
library(shiny)
ui <- fluidPage(
  dateInput('primeiro', 'Quando entrou no seu primeiro emprego?', format = 'dd-mm-yyyy', language = 'pt-BR', weekstart= 0),
  dateRangeInput('tempo', 'Por quanto tempo ficou no emprego', format = 'dd-mm-yyyy', language = 'pt-BR', weekstart= 0)
)
server <- function(input, output, session) {}
shinyApp(ui = ui, server = server)
```


#### **Botões de ações**

`actionButton()` ou `actionLink()`: permite que o usuário execute uma ação.



```r
library(shiny)
ui <- fluidPage(
  actionButton('click', 'Click me!'),
  actionLink('click2', 'Click me!')
)
server <- function(input, output, session) {}
shinyApp(ui = ui, server = server)
```


Os links e botões de ações são naturalmente emparelhados com `observeEvent()` ou `eventReactive()` em sua função **server**. 

Você pode personalizar a aparência, utilizando o argumento `class`, usando `btn-primary`, `btn-success`, `btn-info`, `btn-warning`, ou `btn-danger`. Você também pode alterar o tamanho, com `btn-lg`, `btn-sm`, ou `btn-xs`. Finalmente, você pode fazer com que os botões ocupem toda a largura do elemento em que estão embutidos `btn-block`.



```r
library(shiny)
ui <- fluidPage(
  fluidRow(
    actionButton('click', 'Click me!', class = 'btn-danger'),
    actionButton('click2', 'Click me!', class = 'btn-lg btn-success')
  ),
  fluidRow(
    actionButton('click3', 'Click me!', class = 'btn-block')
  )
)
server <- function(input, output, session) {}
shinyApp(ui = ui, server = server)
```


Vimos apenas alguns tipos de entradas **ui**. Tem muitas outras funções que você pode experimentar.(Mais contéudos no final do tutorial.) 


