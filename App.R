library(shiny)
library(shinychat)
library(bslib)

ui <- bslib::page_fluid(
  theme = bslib::bs_theme(bootswatch = "darkly"),
  tags$head(
    tags$title("Geospatial Chatbot"),
    
    # Highlight.js CSS theme
    tags$link(
      rel = "stylesheet",
      href = "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github-dark.min.css"
    ),
    
    # Highlight.js script
    tags$script(src = "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"),
    
    # Initialize Highlight.js and observe DOM changes
    tags$script(HTML("
      document.addEventListener('DOMContentLoaded', function () {
        const observer = new MutationObserver(function () {
          document.querySelectorAll('pre code').forEach((el) => {
            hljs.highlightElement(el);
          });
        });
        observer.observe(document.body, { childList: true, subtree: true });
      });
    ")),
    
    # Copy-to-clipboard logic for code blocks
    tags$script(HTML("
      document.addEventListener('DOMContentLoaded', () => {
        const addCopyButtons = () => {
          document.querySelectorAll('pre code').forEach(block => {
            if (!block.parentElement.querySelector('.copy-btn')) {
              const button = document.createElement('button');
              button.innerText = '📋 Copy';
              button.className = 'copy-btn';
              button.style = 'position: absolute; top: 5px; right: 10px; font-size: 12px; background: #00bcd4; color: black; border: none; border-radius: 5px; padding: 2px 6px; cursor: pointer;';
              
              const wrapper = document.createElement('div');
              wrapper.style = 'position: relative;';
              block.parentNode.insertBefore(wrapper, block);
              wrapper.appendChild(block);
              wrapper.appendChild(button);
              
              button.addEventListener('click', () => {
                navigator.clipboard.writeText(block.innerText);
                button.innerText = '✅ Copied!';
                setTimeout(() => button.innerText = '📋 Copy', 1500);
              });
            }
          });
        };

        const observer = new MutationObserver(addCopyButtons);
        observer.observe(document.body, { childList: true, subtree: true });
        addCopyButtons();
      });
    "))
  ),
  
  titlePanel(
    tags$div(
      style = "text-align:center;",
      tags$span(style = "color:cyan; font-size: 40px;", "R Geospatial Assistant-bot by Kanake ☠️")
    )
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
