# **Aplicativo Shiny**

--- 

Um *aplicativo Shiny* contém duas partes:

* **UI**: (abreviação de user interface), que controla a aparência do aplicativo (fron-end). 

* **SERVER**: que controla a lógica, contém as instruções de que seu computador precisa para construir seu aplicativo (back-end). 

Essa é a essência de um aplicativo Shiny:



```r
# install.packages("shiny")
library(shiny)
ui <- fluidPage(
  # front-end/interface
)
server <- function(input, output, session) {
  # back-end/lógica
}
shinyApp(ui = ui, server = server)
```


A função **server**  monitora a função **ui**.Sempre que houver uma mudança na **ui**, o **server** seguirá algumas instruções (executará algum código R) de acordo e atualizará a exibição dos visuais. Esta é a ideia básica da expressão reativa, que é uma característica distinta do Shiny.


## **Construindo um aplicativo Shiny**

Inicialmente vamos criar um aplicativo shiny simples, o Shiny usa programação reativa para atualizar automaticamente as saídas quando as entradas mudam (vamos ver mais a frente sobre esse conceito e entender seu funcionalidade). 

Instalação do pacote shiny: 



```r
# install.packages('shiny')
```


Carregue o pacote em sua sessão atual do R. 



```r
library(shiny)
```


Agora vamos criar um novo diretório e colocar no nome de `app.R`, esse arquivo será usado para dizer ao Shiny como o aplicativo deve ficar e como deve se comportar. 



```r
library(shiny)
ui <- fluidPage(
   'Hello, world!'
)
server <- function(input, output, session) {
}
shinyApp(ui = ui, server = server)
```


* `library(shiny)` carrega o pacote  Shiny. 

* A  **ui** nesse caso é uma página HTML contendo "Hello World!".

* A função **server** está vazia, no momento, então o aplicativo não faz nada.

* `shiny(ui = ui, server = server)` cria e inicia o aplicativo Shiny a partir do **ui** e do **server**.

Você pode clica em `Run App` na barra de ferramenta para executar o aplicativo ou usar o atalho `Ctrl`+`shift`+ `Enter`.

Pronto, você criou seu primeiro aplicativo em Shiny.
