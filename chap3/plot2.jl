using PyPlot

# Data
lower_bound = [4.0, 4.2, 4.4, 4.8, 4.9, 4.95, 4.99, 5.00]
upper_bound = [5.4, 5.3, 5.3, 5.2, 5.2, 5.15, 5.10, 5.05]
iter = 1:8

# Creating a new figure object
fig = figure()

# Plotting two datasets
plot(iter, lower_bound, color="red", linewidth=2.0, linestyle="-",
 marker="o", label=L"Lower Bound $Z^k_L$")
plot(iter, upper_bound, color="blue", linewidth=2.0, linestyle="-.",
 marker="D", label=L"Upper Bound $Z^k_U$")

# Labeling axes
xlabel(L"iteration clock $k$", fontsize="xx-large")
ylabel("objective function value", fontsize="xx-large")

# Putting the legend and determining the location
legend(loc="upper right", fontsize="x-large")

# Add grid lines
grid(color="#DDDDDD", linestyle="-", linewidth=1.0)
tick_params(axis="both", which="major", labelsize="x-large")

# Title
title("Lower and Upper Bounds")

# Save the figure as PNG and PDF
savefig("plot2.png")
savefig("plot2.pdf")

# Closing the figure object
close(fig)
