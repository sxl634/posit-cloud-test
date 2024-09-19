# Here's a ggplot2 theme I will use. I used dftplotr 
# (https://github.com/department-for-transport-public/dftplotr/blob/main/R/themeXDft.R) 
# as a starting point and adapted to how I wanted my theme

my_theme <- function() {
  ggplot2::theme(
    # Define plot title format
    plot.title = ggplot2::element_text(
      size = ggplot2::rel(1.2), 
      margin = ggplot2::margin(b = 40, t = -25), 
      hjust = 0.5,
      face = "bold"
    ),
    # standardise non-data lines to be grey cause it looks nice and isn't 
    # obtrusive like black would be
    line = ggplot2::element_line(colour = "grey80"),
    # only include major y panel lines to help see where data points are.
    # slightly different grey to help differentiate against x axis
    panel.grid.major.y = ggplot2::element_line(
      color = "#CCC1B7"),
    # No need for y axis ticks with major grid lines
    axis.ticks.y = ggplot2::element_blank(),
    # Position y axis title to be at top of y axis and horizontal for easy
    # reading
    axis.title.y = ggplot2::element_text(
      angle = 0,
      margin = ggplot2::margin(r = -70, b = 15),
      # hjust = -1,
      vjust = 1.05,
      size = ggplot2::rel(1.2),
      face = "bold"
    ),
    axis.title.x = ggplot2::element_text(
      size = ggplot2::rel(1.2),
      face = "bold", 
      margin = ggplot2::margin(t = 15)
    ),
    # axis text to be smaller
    axis.text = ggplot2::element_text(
      size = ggplot2::rel(1.1)
    ),
    # adjust where y axis text is to major grid lines
    axis.text.y = ggplot2::element_text(
      margin = ggplot2::margin(r = -2.8, b = 2),
      hjust = 1),
    # Define the x axis tick lengths
    axis.ticks.length = ggplot2::unit(0.3, "lines"),
    # Ensure there is an x axis
    axis.line.x = ggplot2::element_line(),
    # Remove panel background as it's chart junk
    panel.background = ggplot2::element_blank(),
    # Adjust legend to be minimalist right hand side vertical
    legend.title = ggplot2::element_text(
      size = ggplot2::rel(0.9),
      face = "bold"
    ),
    legend.key = ggplot2::element_blank(),
    legend.key.size = ggplot2::unit(1.5, "lines"),
    legend.spacing.x = ggplot2::unit(0.5, 'cm'),
    legend.position = "right",
    legend.justification = "center",
    legend.direction = "vertical",
    legend.box.spacing = ggplot2::unit(14, "pt"),
    # Plot margins
    plot.margin = ggplot2::margin(c(2, 0.5, 1, 0.5), unit = "cm")
  )
}
