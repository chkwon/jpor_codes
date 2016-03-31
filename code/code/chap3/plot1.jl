using PyPlot

# Preparing a figure object
fig = figure()

# Data
x = linspace(0,2*pi,1000)
y = sin(3*x)

# Plotting with linewidth and linestyle specified
plot(x, y, color="blue", linewidth=2.0, linestyle="--")

# Labeling the axes
xlabel(L"value of $x$")
ylabel(L"\sin(3x)")

# Title
title("Test plotting")

# Save the figure as PNG and PDF
savefig("myplot1.png")
savefig("myplot1.pdf")

# Close the figure object
close(fig)
