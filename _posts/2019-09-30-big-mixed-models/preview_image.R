library(mgcViz)
n  <- 1e3
x1 <- rnorm(n)
x2 <- rnorm(n)
dat <- data.frame("x1" = x1, "x2" = x2,
                  "y" = sin(x1) + 0.5 * x2^2 + pmax(x2, 0.2) * rnorm(n))
b <- bamV(y ~ s(x1)+s(x2), data = dat, method = "fREML", aGam = list(discrete = TRUE))

o <- plot(sm(b, 1), nsim = 50) # 50 posterior simulations 

# Plot with fitted effect + posterior simulations + rug on x axis
o + 
  l_ciPoly(mul = 2, fill = "#00aaff40", linetype = 1) +
  l_simLine(alpha = .05) + 
  l_fitLine(colour = "#ff5500") + 
  # l_rug(alpha = 0.08)  +
  
  # Add CI lines at 1*sigma and 5*sigma
  # visibly::theme_clean()
  theme_void()

ggsave('img/gam_sim.png', width = 4, height = 3)
# # Add partial residuals and change theme
# ( o + l_points(shape = 19, size = 1, alpha = 0.2) + theme_classic() )
