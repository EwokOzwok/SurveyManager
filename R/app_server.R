#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinyMobile
#' @import dplyr
#' @import readxl
#' @import writexl
#' @import tidyr
#' @import DT
#' @noRd
app_server <- function(input, output, session) {

  # Reactive expression to read the uploaded file
  dataset <- reactive({
    req(input$file)
    # Read the uploaded file as a data frame
    read_excel(input$file$datapath)
  })

  # Reactive expression to filter the dataset based on user input
  filtered_data <- reactive({
    req(input$class_code, input$class_number)
    df <- dataset()
    df$CLASSNUMBER <- as.numeric(df$CLASSNUMBER)

    class_numb <- as.numeric(input$class_number)
    class_code <- input$class_code

    # Filter the dataset
    df_filtered <- df %>%
      filter(CLASSCODE == class_code,
             CLASSNUMBER == class_numb,
             !grepl("Baseline Completed", Status))  # Exclude rows where 'Status' contains 'Baseline Completed'

    df_filtered <- dplyr::select(df_filtered, `Email Address`, Link, Status, GROUP, CLASSCODE, CLASSNUMBER)

    df_filtered
  })





  # Preview the filtered dataset in the app using DT
  output$preview <- renderDT({
    req(filtered_data())

    # Clean up potential NA values in the filtered data before displaying
    filtered_clean <- filtered_data() %>%
      na.omit()  # Remove rows with NA values if necessary

    datatable(
      filtered_clean,
      options = list(pageLength = 10, autoWidth = TRUE),
      class = 'cell-border stripe'  # Adds basic styling like cell borders and stripes
    ) %>% formatStyle(
      # Apply white text to all cells
      columns = names(filtered_clean),
      color = 'white',
      backgroundColor = 'black',   # Set background color to black for contrast
      fontWeight = 'bold'          # Make text bold
    ) %>% formatStyle(
      # Set table width to 100%
      columns = 1:ncol(filtered_clean),
      width = '100%'               # Automatically converted to 'width: 100%'
    )
  })



# Generate a CSV for download
output$downloadData <- downloadHandler(
  filename = function() {
    paste("CLASSROOM NON-COMPLETERS -- ", "CLASS --", input$class_code, " ", input$class_number, " - Downloaded on - ", Sys.Date(), ".csv", sep = "")
  },
  content = function(file) {
    # write_xlsx(filtered_data(), file)
    write.csv(filtered_data(), file, row.names = FALSE)
  }
)



# Gift Card Sort
# df<-read.csv("3 - Exit Survey Distribution List ALL - Sheet1.csv")


dataset_sort <- reactive({
  req(input$file1)
  # Read the uploaded file as a data frame
  read_excel(input$file1$datapath)
  # read.csv(input$file1$datapath, header=T, sep=",", encoding="utf-8-rom")
})





filtered_data1 <- reactive({
  df <- dataset_sort()

  # Sort the filtered dataset by SEND_DATE, earliest to latest
  df <- df %>%
    arrange(SEND_DATE)
  df$SEND_DATE<-as.character(df$SEND_DATE)
  # Function to replace NA with appropriate type-based defaults
  df <- df %>%
    mutate(across(everything(), ~replace_na(.x, ifelse(is.character(.x), "", ifelse(is.numeric(.x), 0, NA)))))
  df
})




output$downloadData1 <- downloadHandler(
  filename = function() {
    paste(input$timepoint, " Survey - Gift Card Data Sorted - ", " - Downloaded on - ", Sys.Date(), ".csv", sep = "")
  },
  content = function(file) {
    # write_xlsx(filtered_data1(), file)

    write.csv(filtered_data1(), file, row.names = FALSE)
  }
)

# Preview the filtered dataset in the app using DT
output$preview1 <- renderDT({
  req(filtered_data1())

  # Clean up potential NA values in the filtered data before displaying
  filtered_clean <- filtered_data1()

  datatable(
    filtered_clean,
    options = list(pageLength = 10, autoWidth = TRUE),
    class = 'cell-border stripe'  # Adds basic styling like cell borders and stripes
  ) %>% formatStyle(
    # Apply white text to all cells
    columns = names(filtered_clean),
    color = 'white',
    backgroundColor = 'black',   # Set background color to black for contrast
    fontWeight = 'bold'          # Make text bold
  ) %>% formatStyle(
    # Set table width to 100%
    columns = 1:ncol(filtered_clean),
    width = '100%'               # Automatically converted to 'width: 100%'
  )
})




#
#
#   output$downloadData <- downloadHandler(
#     filename = function() {
#       paste("CLASSROOM NON-COMPLETERS -- ", "CLASS --", input$class_code, " ", input$class_number, " - Downloaded on - ", Sys.Date(), ".xlsx", sep = "")
#     },
#     content = function(file) {
#       writexl::write_xlsx(filtered_data(), path = file)  # Export as .xlsx using writexl
#     }
#   )
#
#
#
#   output$downloadData1 <- downloadHandler(
#     filename = function() {
#       paste(input$timepoint, " Survey - Gift Card Data Sorted - ", " - Downloaded on - ", Sys.Date(), ".xlsx", sep = "")
#     },
#     content = function(file) {
#       writexl::write_xlsx(filtered_data1(), path = file)  # Export as .xlsx using writexl
#     }
#   )



}
