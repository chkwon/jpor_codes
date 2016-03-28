using PyPlot

# Data
data = randn(100) # Some Random Data
nbins = 10        # Number of bins

# Creating a new figure object
fig = figure()

# Histogram
plt[:hist](data, nbins)

# Title
title("Histogram")

# Save the figure as PNG and PDF
savefig("plot3.png")
savefig("plot3.pdf")

# Closing the figure object
close(fig)
