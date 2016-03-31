# code/chap4/curve_fit.jl
using LsqFit		# for curve fitting
using Gadfly		# for drawing plots

# preparing data for fitting
xdata = [ 15.2; 19.9;  2.2; 11.8; 12.1; 18.1; 11.8; 13.4; 11.5;  0.5;
          18.0; 10.2; 10.6; 13.8;  4.6;  3.8; 15.1; 15.1; 11.7;  4.2 ]
ydata = [ 0.73; 0.19; 1.54; 2.08; 0.84; 0.42; 1.77; 0.86; 1.95; 0.27;
          0.39; 1.39; 1.25; 0.76; 1.99; 1.53; 0.86; 0.52; 1.54; 1.05 ]

# defining a model
model(x,beta) = beta[1] * ((x/beta[2]).^(beta[3]-1)) .*
                          (exp( - (x/beta[2]).^beta[3] ))

# run the curve fitting algorithm
fit = curve_fit(model, xdata, ydata, [3.0, 8.0, 3.0])

# results of the fitting
beta_fit = fit.param
errors = estimate_errors(fit)

# preparing the fitting evaluation
xfit = 0:0.1:20
yfit = model(xfit, fit.param)

# plotting. It will open a web browser to show the plot
fit_plot =
  plot(layer(x=xdata, y=ydata, Geom.point),
       layer(x=xfit, y=yfit, Geom.line, Theme(default_color=colorant"red") ) )

# Saving the plot as SVG/PNG files
draw(SVG("fit_plot.svg", 6inch, 4inch), fit_plot)
draw(PNG("fit_plot.png", 400px, 300px), fit_plot)

# To save the plot in PDF format, you need to install the Cairo package
# julia> Pkg.add("Cairo")
draw(PDF("fit_plot.pdf", 6inch, 4inch), fit_plot)
