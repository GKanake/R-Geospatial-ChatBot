library(shiny)
library(shinychat)

ui <- bslib::page_fluid(
  theme = bslib::bs_theme(bootswatch = "darkly"),
  tags$head(
    tags$title("Geospatial Chatbot") # Page Title
  ),
  # App title centered
  titlePanel(
    tags$div(style="text-align:center;",
             tags$span(style="color:cyan; font-size: 40px;", "R Geospatial Analyst Assistant-bot by Kanake ☠️")) # Added font-size here
  ),
  chat_ui("chat")
)

server <- function(input, output, session) {
  api_key <- Sys.getenv("GOOGLE_API_KEY")
  
  chat <- ellmer::chat_gemini(
    system_prompt = "You're a geospatial analyst proficient in R and RStudio"
  )
  
  observeEvent(input$chat_user_input, {
    stream <- chat$stream_async(input$chat_user_input)
    chat_append("chat", stream)
  })
}

shinyApp(ui, server)

  
