function(request){
  dashboardPage(
    dashboardHeader(
      title="JFSP Alfresco",
      tags$li(class="dropdown",
              tags$a(href="http://snap.uaf.edu", target="_blank",
                     tags$img(src="SNAP_acronym_100px.png", width="100%", alt="SNAP"), style="margin: 10px; padding: 0px;")
      )
      #tags$head(includeScript("ga-nwtapp.js"), includeScript("ga-allapps.js")),
    ),
    dashboardSidebar(
      useToastr(),
      sidebarMenu(
        id="tabs",
        menuItem("Data", icon=icon("sliders"), tabName="data"),
        menuItem("Fire", icon=icon("fire", lib="glyphicon"),
          menuSubItem("Burn area", tabName="burnarea"),
          menuSubItem("Fire count", tabName="firefreq"),
          menuSubItem("Fire size", tabName="firesize")
        ),
        menuItem("Vegetation", icon=icon("tree"), badgeColor="green",
          menuSubItem("Cover area", tabName="vegarea"),
          menuSubItem("Stand age", tabName="vegage")
        )
      ),
      #bookmarkButton(style=action_btn_style, class="btn-flat action-button btn-block")
      actionButton("fake", "Bookmark", style=action_btn_style, class="btn-flat action-button btn-block", icon=icon("link")) # placeholder
    ),
    dashboardBody(
      includeCSS("www/styles.css"),
      bsModal("staticmap", "Fire Management Zones", "btn_staticmap", size="large",
        img(src='Fire_Mgmt_Areas.png', align="center", style="width: 100%")
      ),
      tabItems(
        tabItem(tabName="data",
          fluidRow(
            column(6, leafletOutput("Map", width="100%", height="500px")),
            column(6,
              selectInput("regions", "Fire Mgmt Zones", choices=regions, selected="", multiple=TRUE, width="100%"),
              selectInput("veg", "Vegetation", choices=veg, selected="All", multiple=TRUE, width="100%"),
              selectInput("gcms", "GCM", choices=gcms, selected=gcms, multiple=TRUE, width="100%"),
              fluidRow(
                column(6, selectInput("rcps", "RCP", choices=rcps, selected=rcps, multiple=TRUE, width="100%")),
                column(6, selectInput("stat", "Summarize sims by", choices=stats, selected="Mean", width="100%"))
              ),
              sliderInput("yrs", "Years", min=period[1], max=period[2], value=c(2014, 2099), step=1, sep="", width="100%"),
              fluidRow(
                column(6, actionButton("btn_staticmap", "Detailed FMZ map", class="btn-block", icon("globe"))),
                column(6, checkboxInput("flammable", "Show flammable region", TRUE, width="100%"))
                
              )
            )
          ),
          br(),
          fluidRow(
            box(
              tabBox(
                tabPanel("Stand age", verbatimTextOutput("filtered_a"), icon=icon("tree")),
                tabPanel("Cover area", verbatimTextOutput("filtered_v"), icon=icon("tree")),
                tabPanel("Fire size", verbatimTextOutput("filtered_fs"), icon=icon("fire", lib="glyphicon")),
                tabPanel("Fire count", verbatimTextOutput("filtered_fc"), icon=icon("fire", lib="glyphicon")),
                tabPanel("Burn area", verbatimTextOutput("filtered_ba"), icon=icon("fire", lib="glyphicon")),
                tabPanel("Full table", div(DT::dataTableOutput("filtered_data"), style="font-size: 100%"), icon=icon("sliders")),
                id="summary", selected="Full table", title="Full table subset and summaries", width=12, side="right"
              ), title="Current data selections", status="primary", solidHeader=TRUE, width=12, collapsible=TRUE
            )
          )
        ),
        mainModUI(id="mod_burnarea", tab_name="burnarea"),
        mainModUI(id="mod_firefreq", tab_name="firefreq"),
        mainModUI(id="mod_firesize", tab_name="firesize"),
        mainModUI(id="mod_vegarea", tab_name="vegarea"),
        mainModUI(id="mod_vegage", tab_name="vegage")
      )
    ),
    title="JFSP"
  )
}
