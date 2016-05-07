using LsqFit		# for curve fitting
using PyPlot		# for drawing plots

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

# Creating a new figure object
fig = figure()

# Plotting two datasets
plot(xdata, ydata, color="black", linewidth=2.0, marker="o", linestyle="None")
plot(xfit, yfit, color="red", linewidth=2.0)

# Labeling axes
xlabel("x", fontsize="xx-large")
ylabel("y", fontsize="xx-large")

# Save the figure as PNG and PDF
savefig("fit_plot.png")
savefig("fit_plot.pdf")

# Closing the figure object
close(fig)
