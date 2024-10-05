#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinyMobile
#' @import htmltools
#' @import DT
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic

    shinyMobile::f7Page(
      title = "Survey Manager",
      options = list(theme=c("auto"), dark=TRUE, preloader = F,  pullToRefresh=F),
      allowPWA=TRUE,


      f7TabLayout(
        # panels are not mandatory. These are similar to sidebars
        navbar = f7Navbar(
          title= "Survey Manager"),


        # f7Tabs is a special toolbar with included navigation
        f7Tabs(
          animated = TRUE,
          id = "tabs",
          swipeable = F,
          f7Tab(
            tabName = "WelcomeTab",
            icon = f7Icon("envelope_fill"),
            active = TRUE,
            hidden= F,
            f7Block(
              f7Shadow(
                intensity = 5,
                hover = TRUE,
                f7Card(
                  f7Align(h2("Step 1: Upload the Baseline List from GDrive"),side=c("left")),
                  f7File("file", "Upload XLSX File", multiple = F, accept = ".xlsx"),
                  br(),
                  f7Align(h2("Step 2: Enter the Class Code and Class Number"),side=c("left")),
                  f7Text("class_code", "Enter Class Code", placeholder = "ECPY"),
                  br(),
                  f7Text("class_number", "Enter Class Number", placeholder = "101"),
                  hr(),
                  br(),
                  f7Align(h2("Step 3: Extract Non-Completers for Mail Merge"),side=c("left")),
                  br(),
                  hr(),
                  br(),
                  f7DownloadButton("downloadData", "Download Filtered CSV"),
                  br(),
                  br(),
                  DTOutput("preview"),
                  footer = NULL,
                  hairlines = F, strong = T, inset = F, tablet = FALSE)
              )
            )
          ),

          f7Tab(
            tabName = "SortTab",
            icon = f7Icon("sort_up"),
            active = F,
            hidden= F,
            f7Block(
              f7Shadow(
                intensity = 5,
                hover = TRUE,
                f7Card(
                  f7Align(h2("Step 1: Upload the Exit or Follow-up List from GDrive"),side=c("left")),
                  f7File("file1", "Upload XLSX File", multiple = F, accept = ".xlsx"),
                  br(),
                  f7Align(h2("Step 2: Sort by Gift Card Send Date"),side=c("left")),
                  br(),
                  hr(),
                  br(),
                  f7Select("timepoint", "Select the time-point", choice = c("Exit", "Follow-up", "6month Follow-up")),
                  br(),
                  f7DownloadButton("downloadData1", "Download Filtered CSV"),
                  br(),
                  br(),
                  DTOutput("preview1"),
                  footer = NULL,
                  hairlines = F, strong = T, inset = F, tablet = FALSE)
              )
            )
          )
        )
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  # add_resource_path(
  #   "www",
  #   app_sys("./www"),
  # )

  tags$head(

    # favicon -----------------------------------------------------------------
    favicon(),
    # bundle_resources(
    #   path = app_sys("./www"),
    #   app_title = "MHScreener"),
    # includeCSS("./www/newcss.css"),

    HTML('<link rel="stylesheet" type="text/css" href="https://ewokozwok.github.io/MHScreener/www/framework7.bundle.min.css">')



    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()

  )

}
