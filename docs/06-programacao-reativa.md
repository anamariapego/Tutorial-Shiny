# **Programação reativa**

---

## **Introdução**

Já foi apresentado a você as principais funções de entradas e saídas que constituem o font-end de um aplicativo Shiny. Agora passaremos para o back-end do aplicativo Shiny: *o código R que dá vida a sua interface de usuário.*

É fácil criar apliactivos interativos com o Shiny, mas para obter o máximo que ele oferece, você precisar entender a estrutura e o funcionamento de **programação reativa** usada pelo Shiny. 

No Shiny, você expressa a lógica do **server** usando programação reativa. A programação reativa é um paradigma de **programação elegante** e **poderosa**, mas pode ser desorientador no início porque é um paradigma muito diferente de escrever um script. A ideia principal da programação reativa é especificar um gráfico de dependências para que, quando uma entrada for alterada, todas as saídas relacionadas sejam atualizadas automaticamente. Isso torna o fluxo de um aplicativo consideravelmente mais simples.


## **Programação reativa**

A verdadeira magia do Shiny acontece quando você tem um aplicatvos com entradas e saídas. Veremos um simples exemplo:



```r
library(shiny)
ui <- fluidPage(
  textInput('nome', 'Qual é o seu nome?'),
  textOutput('saudacao')
)
server <- function(input, output, session) {
  output$saudacao <- renderText({
    paste0('Olá ', input$nome, '!')
  })
}
shinyApp(ui = ui, server = server)
```


Observe com a saída se altera de acordo com a entrada. Esta é a grande ideia do Shiny: você não precisa dizer a uma saída quando atualizar, porque o Shiny descobre isso automaticamente.

**Como funciona? O que exatamente está acontecendo no corpo da função?**

O código não diz ao Shiny para criar a string e enviá-la ao navegador, mas em vez disso, ele informa ao Shiny como ele poderia criar a string se necessário. Depende do Shiny quando e se o código deve ser executado. Ele pode ser executado assim que o aplicativo for iniciado ou pode ser um pouco mais tarde; ele pode ser executado muitas vezes ou nunca! Isso não quer dizer que Shiny seja caprichoso, apenas que é responsabilidade dele decidir quando o código é executado.

## **Programação declarativa vs imperativa**

* Na **programação declarativa** você expressa objetivos de nível superior ou descreve restrições importantes e confia em outra pessoa para decidir como e/ou quando traduzir isso em ação. Este é o estilo de programação que você usa no Shiny.

* Na **programação imperativa** você emite um comando específico e ele é executado imediatamente. Este é o estilo de programação com o qual você está acostumado em seus scripts de análise: você comanda o R para carregar seus dados, transformá-los, visualizá-los e salvar os resultados no disco.

Na maioria das vezes, a programação declarativa é tremendamente libertadora: você descreve seus objetivos gerais e o software descobre como alcançá-los sem intervenção adicional. A desvantagem é o momento ocasional em que você sabe exatamente o que quer, mas não consegue descobrir como enquadrá-lo de uma forma que o sistema declarativo entenda. 
