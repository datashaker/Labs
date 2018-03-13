library(shiny)
library(ggplot2)
library(pracma)
library(rmutil)
library(deSolve)

# Define UI for application that draws a histogram
ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      body {
        background: #dedede;
      }
      h2 {
        text-align: center;
      }
    "))
  ),
  
  # Application title
  titlePanel("\xF0\x9F\x98\x8E Procrastination team first work for the win!!! \xF0\x9F\x98\x8E"),
  
  tabsetPanel(
    # tab1 ----------------
    tabPanel(
      "Fergulst model",
      fluidRow(
        column(
          width = 12, 
          plotOutput("Fergulst", height = "300px") 
        )
      ),
      fluidRow(
        column(
          width = 4, 
          offset = 4,
          wellPanel(
            #SD for Fergulst model
            numericInput('r', 'r', 0.1,
                         min = -100, max = 100, step = 0.1),
            numericInput('k', 'k', 100,
                         min = 0, max = 100000),
            numericInput('N0', 'N0', 10,
                         min = 0, max = 100000)
          )
        )
      )
    ),
    
    
    
    # tab2---------------
    tabPanel(
      "Solow model",
      fluidRow(
        column(
          width = 12, 
          plotOutput("Solow", height = "300px")
        )
      ),
      fluidRow(
        column(
          width = 4, 
          offset = 4,
          wellPanel(
            numericInput('s', 's', 0.2, min = -100, max = 100, step = 0.1),
            numericInput('k0', 'k0', 0.8, min = 0, max = 100000),
            numericInput('a', 'a', 2.5, min = 0, max = 100000),
            numericInput('m', 'm', 0.1, min = 0, max = 100000),
            numericInput('alpha', 'alpha', 0.3, min = 0, max = 100000),
            numericInput('q', 'q', 0.1, min = 0, max = 100000)
          )
        )
      )
    ),
    
    
    
    #tab3--------
    tabPanel(
      "Fluctation model",
      fluidRow(
        column(6, plotOutput("Fluct", height = "300px")),
        column(6, plotOutput("Fluct2", height = "300px"))
      ),
      fluidRow(
        column(
          width = 4, 
          offset = 4,
          wellPanel(
            numericInput('delta', 'delta', 0.1, min = 0, max = 1, step = 0.1),
            numericInput('w0', 'w0', 2, min = 0, max = 100000),
            numericInput('f0', 'f0', 0, min = 0, max = 100000),
            numericInput('w', 'w', 1, min = 0, max = 100000),
            numericInput('x0_der', 'x0 derivative', 2, min = 0, max = 100000),
            numericInput('x0_fluct', 'x0', 3, min = 0, max = 100000)
          )
        )
      )
    ),
    
    
    
    #tab4----------
    tabPanel(
      "Lotka-Volterra model",
      fluidRow(
        column(6,  plotOutput("predator_prey", height = "300px")),
        column(6, plotOutput("predator_prey2", height = "300px"))
      ),
      fluidRow(
        column(
          width = 4, 
          offset = 4,
          wellPanel(
            numericInput('alpha_x', 'alpha_x', 0.05, min = 0, max = 1, step = 0.1),
            numericInput('beta_x', 'beta_x', 2, min = 0, max = 100000),
            numericInput('alpha_y', 'alpha_y', 5, min = 0, max = 100000),
            numericInput('beta_y', 'beta_y', 1, min = 0, max = 100000),
            numericInput('y0', 'y0', 5, min = 0, max = 100000),
            numericInput('x0_prey', 'x0', 40, min = 0, max = 100000)
          )
        )
      )
    )
  )
);
  
  
  
  
  #rest---------
  
  server <- function(input, output) {
    
    output$Fergulst <- renderPlot({
      # Fergulst model
      Fergulst <- function(N, t) input$r*N*(input$k - N) 
      x_vec <- seq(0, 10, 0.01) 
      solvFirst <- runge.kutta(Fergulst, input$N0 ,x_vec) 
      solvFirst[solvFirst<0] <- 0
      
      ggplot(data.frame(time = x_vec, population = solvFirst), aes(x = time, y = population)) + 
        geom_line(colour = 'red')
      
    })
    
    output$Solow <- renderPlot({
      
      ##### Solow model
      Slow <- function(k, t) {
        input$s*input$a*k^input$alpha - (input$m + input$q)*k
      }
      
      x_vec2 <- seq(0, 100, 1) 
      solvFirst <- runge.kutta(Slow, input$k0 ,x_vec2) 
      solvFirst[solvFirst<0] <- 0
      
      ggplot(data.frame(time = x_vec2, capitallabor = solvFirst), aes(x = time, y = capitallabor)) + 
        geom_line(colour = 'green') 
      
    })
    
    output$Fluct <- renderPlot({
      # Fluctuation model
      f0 <- input$f0
      w <- input$w
      delta <- input$delta
      
      Fluct <- function(t, x)
        as.matrix(c(input$f0*cos(input$w*t) - 2*input$delta*x[1] - input$w0^2*x[2], x[1]))
      t0 <- 0; tf <- 20
      x0 <- as.matrix(c(input$x0_der, input$x0_fluct))
      sol <- ode23(Fluct, t0, tf, x0)
      
      plot(c(0, 10), c(-3, 3), type = "n",
           xlab = "Time", ylab = "", main = "")
      lines(sol$t, sol$y[, 2], col = "blue")
      grid()
      
    })
    
    ### the phase space of fluctuation modeling
    
    output$Fluct2 <- renderPlot({
      # Fluct model (fazovoe)
      f0 <- input$f0
      w <- input$w
      delta <- input$delta
      
      Fluct <- function(t, x)
        as.matrix(c(input$f0*cos(input$w*t) - 2*input$delta*x[1] - input$w0^2*x[2], x[1]))
      t0 <- 0; tf <- 20
      x0 <- as.matrix(c(input$x0_der, input$x0_fluct))
      sol <- ode23(Fluct, t0, tf, x0)
      
      plot(c(-5, 5), c(-5, 5), type = "n",
           xlab = "Time", ylab = "", main = "")
      lines(sol$y[, 1], sol$y[, 2], col = "blue")
      grid()
      
    })
    
    output$predator_prey <- renderPlot({
      LotVmod <- function (Time, State, Pars) {
        with(as.list(c(State, Pars)), {
          dx = x*(alpha*y - beta)
          dy = y*(gamma - delta*x)
          return(list(c(dx, dy)))
        })
      }
      
      Pars <- c(alpha = input$alpha_x, beta = input$beta_x, gamma = input$alpha_y, delta = input$beta_y)
      ##x - predators, y - preys
      State <- c(x = input$x0_prey, y = input$y0)
      Time <- seq(0, 100, by = 0.1)
      
      out <- as.data.frame(ode(func = LotVmod, y = State, parms = Pars, times = Time))
      
      matplot(out[,-1], type = "l", xlab = "time", ylab = "population")
      
      legend("topright", c("Predators", "Preys"), lty = c(1,2), col = c(1,2), box.lwd = 0)
    })
    
    output$predator_prey2 <- renderPlot({
      LotVmod <- function (Time, State, Pars) {
        with(as.list(c(State, Pars)), {
          dx = x*(alpha*y - beta)
          dy = y*(gamma - delta*x)
          return(list(c(dx, dy)))
        })
      }
      
      Pars <- c(alpha = input$alpha_x, beta = input$beta_x, gamma = input$alpha_y, delta = input$beta_y)
      ##x - predators, y - preys
      State <- c(x = input$x0_prey, y = input$y0)
      Time <- seq(0, 100, by = 0.1)
      
      out <- as.data.frame(ode(func = LotVmod, y = State, parms = Pars, times = Time))
      
      plot(out[,2], out[,3], type = "p", xlab = "predators", ylab = "preys")
    })
  }
  
  # Run the application 
  shinyApp(ui = ui, server = server)
  
  