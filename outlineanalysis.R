library(Momocs)


setwd("C:/PathToFolder")

# Import data and put into correct format for Momocs
outl = import_tps("Data.TPS")
outlcoo = outl$coo
outlines = Out(outlcoo)
# Plot all outlines before Procrustes alignment
stack(outlines)


# Make all outlines have the same number of points
# Set this as high as you can without it returning an error.
equalptsout = coo_sample(outlines,120)
# Do Procrustes alignment, and set point 1 on each outline to be
# the homologous starting point
# (not actually sure it does anything with this point)
shells = coo_slide(fgProcrustes(equalptsout, tol= 1e-3, coo = 1), 1)
# If we do not want to fix the starting point uncomment the following instead
# shells = fgProcrustes(equalptsout, tol= 1e-3, coo = 1)


# Plot the aligned outlines
stack(shells)



# Do elliptic Fourier analysis using nb.h harmonics
# Use norm = TRUE to get rid of rotation factor
shells.e = efourier(shells, nb.h = 10, norm = TRUE)
# Do a PCA of the Fourier coefficients
shells.p = PCA(shells.e)


## Visualising the results
# PCA plot
plot(shells.p)
# Variance explained by the first 10 PC's
scree_plot(shells.p)
# The contribution to shape of the first 10 PC's
PCcontrib(shells.p)

# Transform the fourier coefficients into a standard R data frame.
# This can be used for plots etc.
coeffs = shells.e$coe
coeffdf = as.data.frame(coeffs)

# This is the PCA scores.
prcmp = shells.p$x

# Write an outputfile of the PCA scores.
write.csv(prcmp,file = "ER_EA_pcascores.csv")

