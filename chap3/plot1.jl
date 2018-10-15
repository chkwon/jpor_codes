using PyPlot

# Preparing a figure object
fig = figure()

# Data
x = range(0, stop=2*pi, length=1000)
y = sin.(3*x)

# Plotting with linewidth and linestyle specified
plot(x, y, color="blue", linewidth=2.0, linestyle="--")

# Labeling the axes
xlabel(L"value of $x$")
ylabel(L"\sin(3x)")

# Title
title("Test plotting")

# Save the figure as PNG and PDF
savefig("plot1.png")
savefig("plot1.pdf")

# Close the figure object
close(fig)
