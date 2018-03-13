library(shiny)
library(rmutil)
library(DT)
library(plotly)



GetTblFergulst <- function(mu, N0, k, n, h = 0.05, num_round = 8){
  Fergulst <- function(N, t) mu*N*(k - N)
  x_vec <- seq(0, 3, h)
  solvFerg <- runge.kutta(Fergulst, N0 ,x_vec)
  solvFerg <- round(solvFerg,num_round)
  return(data.frame(Num = seq(n),
                    N = solvFerg[1:n],
                    N_square = round(solvFerg[1:n]^2,num_round),
                    N_next = solvFerg[2:(n+1)]
  ))
}



MNK_frame <- function(F_tbl){
  m=ncol(F_tbl)-1
  n=nrow(F_tbl)
  
  F_tbl <- as.matrix(F_tbl)
  y <- F_tbl[,ncol(F_tbl)]
  
  X <- list()
  for(i in 1:m) X[[i]] <- as.matrix(F_tbl[,1:i])
  D <- list()
  for(i in 1:m) D[[i]] <- diag(n)-
    X[[i]]%*%solve(t(X[[i]])%*%X[[i]])%*%t(X[[i]])
  h <- list(NA)
  for(i in 2:m) h[[i]] <- t(X[[i-1]])%*%F_tbl[,i]
  eta <- list()
  for(i in 1:m) eta[[i]] <- t(F_tbl[,i])%*%F_tbl[,i]
  gamma <- list()
  for(i in 1:m) gamma[[i]] <- t(F_tbl[,i])%*%y
  
  theta <- list(t(F_tbl[,1])%*%y/t(F_tbl[,1])%*%F_tbl[,1])
  H_inv <- list(1/t(F_tbl[,1])%*%F_tbl[,1])
  beta <- list(NA)
  rss <- c(t(y)%*%D[[1]]%*%y)
  Cp <- c(rss[1]+2)
  FPE <- c(rss[1]*(n+1)/(n-1))
  
  for(s in 1:(m-1)){
    beta[[s+1]] <- eta[[s+1]]-t(h[[s+1]])%*%H_inv[[s]]%*%h[[s+1]]
    theta[[s+1]] <- as.matrix(c(
      theta[[s]]- as.numeric(gamma[[s+1]]-
                               t(h[[s+1]])%*%theta[[s]])*H_inv[[s]]%*%h[[s+1]]/as.numeric(beta[[s+1
                                                                                                ]]),
      (gamma[[s+1]]-t(h[[s+1]])%*%theta[[s]])/beta[[s+1]]),
      nrow=s+1)
    r1 <- cbind(H_inv[[s]]-
                  H_inv[[s]]%*%h[[s+1]]%*%t(h[[s+1]])%*%H_inv[[s]]/as.numeric(beta[[
                    s+1]]),
                -H_inv[[s]]%*%h[[s+1]]/as.numeric(beta[[s+1]]))
    r2 <- cbind(-
                  t(h[[s+1]])%*%H_inv[[s]]/as.numeric(beta[[s+1]]),1/as.numeric(beta[[s
                                                                                      +1]]))
    H_inv[[s+1]] <- rbind(r1,r2)
    rss[[s+1]] <- rss[[s]]-
      (t(F_tbl[,s+1])%*%D[[s]]%*%y)^2/(t(F_tbl[,s+1])%*%D[[s]]%*%F_tbl[,s
                                                                       +1])
    Cp[s+1] <- rss[s+1]+2*s
    FPE[s+1] <- c(rss[s+1]*(n+s)/(n-s))
  }
  return(list(Theta = unlist(theta[[length(theta)]]),
              RSS = rss,
              Cp = Cp,
              FPE = FPE
  ))
}



ui <- fluidPage(
  theme = "superhero.bootstrap.min.css",
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),
  titlePanel("Best team's work ever. Like & repost"),
  navlistPanel(
    tabPanel('Work 2. Part 1',
             fluidRow(
               column(6,wellPanel(
                 numericInput("input_mu","Input mu",value = -0.1),
                 numericInput("input_k","Input K",value = 100),
                 numericInput("input_N0","Input N0",value = 50)
               )),
               column(6,wellPanel(
                 numericInput("input_h","Input delta t",value = 0.05,step =
                                0.01),
                 numericInput("input_n","Input sample length",value = 30),
                 numericInput("input_num_round","Input precision",value =
                                8,min=0)
               ))
             ),
             fluidRow(
               column(12,wellPanel(
                 dataTableOutput("F_table")
               ))
             ),
             fluidRow(
               column(12,wellPanel("Error vs sample size and noise",
                                   dataTableOutput("error_table"))),
               column(12,wellPanel(
                 htmlOutput("result_theta")
               ))
             )
    ),

    tabPanel('Work 2. Part 2',
             fluidRow(
               column(10,wellPanel(
                 numericInput("input_n2","Input sample length",value = 30),
                 sliderInput("input_ab","Input interval [a,b] for matrix X:",min
                             = 0,max=5,value = c(0,1),step = 0.5),
                 numericInput("input_ksi_sd","Input sd of ksi",value = 1)
               ), offset = 1),
               column(12,wellPanel(
                 plotlyOutput("Criteria_plot")
                 
               ))
             ),
             fluidRow(wellPanel(
               dataTableOutput("R_table")
             )))
  )
)


# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$F_table <- renderDataTable({
    datatable(GetTblFergulst(mu = input$input_mu, N0 =
                               input$input_N0, k = input$input_k,
                             n = input$input_n, h = input$input_h, num_round =
                               input$input_num_round)[,-1],
              class = "compact",options = list(pageLength = 50, paging = FALSE, dom = 'tp'))
    
  })
  
  output$result_theta <- renderUI({
    f_tbl <- as.matrix(GetTblFergulst(mu = input$input_mu, N0 =
                                        input$input_N0, k = input$input_k,
                                      n = input$input_n, h = input$input_h, num_round =
                                        input$input_num_round))
    theta_hat <- MNK_frame(f_tbl[,-1])[[1]]
    theta_hat_r <- round(theta_hat,input$input_num_round)
    theta <- c(input$input_h*input$input_mu*input$input_k+1,(-
                                                               1)*input$input_h*input$input_mu)
    theta_r <- round(theta,input$input_num_round)
    HTML(paste(
      paste("Estimated:",theta_hat_r[1],theta_hat_r[2]),
      paste("Real:",theta_r[1],theta_r[2]),
      paste("|Estimated-Real|:",abs(theta_hat[1]-
                                      theta[1]),abs(theta_hat[2]-theta[2])),
      sep="<br/>")
    )
  })
  
  output$R_table <- renderDataTable({
    R_tbl <- data.frame(X1 =
                          runif(input$input_n2,min=input$input_ab[1],max=input$input_ab[2]),
                        X2 =
                          runif(input$input_n2,min=input$input_ab[1],max=input$input_ab[2]),
                        X3 =
                          runif(input$input_n2,min=input$input_ab[1],max=input$input_ab[2]),
                        X4 =
                          runif(input$input_n2,min=input$input_ab[1],max=input$input_ab[2]),
                        X5 =
                          runif(input$input_n2,min=input$input_ab[1],max=input$input_ab[2]))
    theta_real <- c(3,2,1,0,0)
    R_tbl <-
      cbind(R_tbl,as.matrix(R_tbl)%*%theta_real,rnorm(input$input_n2,sd =
                                                        input$input_ksi_sd))
    colnames(R_tbl) <- c("X1","X2","X3","X4","X5","Y0","ksi")
    R_tbl$Y <- R_tbl$Y0+R_tbl$ksi
    R_tbl <- round(R_tbl,5)
    datatable(R_tbl,
              class = "compact",options = list(pageLength = 50, paging = FALSE, dom = 'tp'))
    
  })
  
  output$Criteria_plot <- renderPlotly({
    R_tbl <- data.frame(X1 =
                          runif(input$input_n2,min=input$input_ab[1],max=input$input_ab[2]),
                        X2 =
                          runif(input$input_n2,min=input$input_ab[1],max=input$input_ab[2]),
                        X3 =
                          runif(input$input_n2,min=input$input_ab[1],max=input$input_ab[2]),
                        X4 =
                          runif(input$input_n2,min=input$input_ab[1],max=input$input_ab[2]),
                        X5 =
                          runif(input$input_n2,min=input$input_ab[1],max=input$input_ab[2]))
    theta_real <- c(3,2,1,0,0)
    R_tbl <-
      cbind(R_tbl,as.matrix(R_tbl)%*%theta_real,rnorm(input$input_n2,sd =
                                                        input$input_ksi_sd))
    colnames(R_tbl) <- c("X1","X2","X3","X4","X5","Y0","ksi")
    R_tbl$Y <- R_tbl$Y0+R_tbl$ksi
    res <- MNK_frame(R_tbl[,c(1:5,8)])
    pl <- plot_ly(x=seq(5),y=res$RSS,name="RSS(s)",type="scatter",
                  mode = 'lines+markers') %>%
      add_trace(x=seq(5),y=res$Cp,name="Cp(s)") %>%
      add_trace(x=seq(5),y=res$FPE,name="FPE(s)") %>%
      layout(title = "Criteria vs Complexity", xaxis = list(title =
                                                              "s"),yaxis = list(title = "Criteria"))
    pl
  })
  
  output$error_table <- renderDataTable({
    s_size <- c(5,20,50)
    r_num <- c(1,3,5)
    res <- data.frame(matrix(NA,3,3))
    for(i in 1:3)
      for (j in 1:3){
        f_tbl <- as.matrix(GetTblFergulst(mu = input$input_mu, N0 =
                                            input$input_N0, k = input$input_k,
                                          n = s_size[i], h = input$input_h,
                                          num_round = r_num[j]))
        theta_hat <- MNK_frame(f_tbl[,-1])[[1]]
        theta <- c(input$input_h*input$input_mu*input$input_k+1,(-
                                                                   1)*input$input_h*input$input_mu)
        res[i,j] <- mean(abs(theta_hat-theta))
      }
    colnames(res) <- r_num
    rownames(res) <- s_size
    datatable(res,
              class = "compact",options = list(pageLength = 10, paging = FALSE, dom = 't'))
  })
  
}


# Run the application
shinyApp(ui = ui, server = server)