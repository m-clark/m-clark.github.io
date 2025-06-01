# source("renv/activate.R")
Sys.setenv(RETICULATE_PYTHON = "~/anaconda3/envs/m-clark-github-io/bin/python")
library(reticulate)



plot_ff = 'Roboto Condensed'
# plot_ff = 'Arial Narrow'
# plot_ff = 'Roboto'


theme_clean = function(
    font_size = 12,
    font_family = plot_ff,
    center_axis_labels = FALSE
) {
    if (center_axis_labels) {
        haxis_just_x = 0.5
        vaxis_just_y = 0.5
        v_rotation_x = 0
        v_rotation_y = 0
    } else {
        haxis_just_x = 0
        vaxis_just_y = 1
        v_rotation_x = 0
        v_rotation_y = 0
    }

    ggplot2::theme(
        text = ggplot2::element_text(
        family = font_family,
        face = 'plain',
        color = 'gray30',
        size = font_size,
        hjust = 0.5,
        vjust = 0.5,
        angle = 0,
        lineheight = 0.9,
        margin = ggplot2::margin(),
        debug = FALSE
        ),
        axis.title.x = ggplot2::element_text(
        hjust = haxis_just_x,
        angle = v_rotation_x,
        size  = 1.2 * font_size,
        face = 'bold'
        ),
        axis.title.y = ggplot2::element_text(
        vjust = vaxis_just_y,
        hjust = 0,
        angle = v_rotation_y,
        size  = 1.2 * font_size,
        family = font_family,
        face = 'bold',
        ),
        axis.ticks = ggplot2::element_line(color = 'gray30'),
        title = ggplot2::element_text(
        color = 'gray30', 
        size = font_size * 1.25,
        margin = margin(b = font_size * 0.3),
        family = font_family,
        face = 'bold',
        ),
        plot.subtitle = ggplot2::element_text(
        color = 'gray30', 
        size = font_size * 1, 
        hjust = 0,
        family = font_family,
        face = 'bold',      
        ),
        plot.caption = ggplot2::element_text(
        color = 'gray30', 
        size = font_size * .8, 
        hjust = 0,
        family = font_family,
        face = 'bold',      
        ),
        legend.position = 'bottom',
        legend.key = ggplot2::element_rect(fill = 'transparent', color = NA),
        legend.background = ggplot2::element_rect(fill = 'transparent', color = NA),
        legend.title = ggplot2::element_blank(),
        panel.background = ggplot2::element_blank(),
        panel.grid.major = ggplot2::element_line(color = 'gray95'),
        strip.background = ggplot2::element_blank(),
        plot.background = ggplot2::element_rect(fill = 'transparent', color = NA),
    )
}
