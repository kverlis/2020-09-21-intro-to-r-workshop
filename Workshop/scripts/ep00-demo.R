#
# A very quick demonstation of the sorts of things your can do with R
#

# Updated on Monday
# Load the GGPLOT2 library
library(ggplot2)

# The dataset 'diamonds' in included with the ggplot library
View(diamonds)

# Generate a Plot 
ggplot(diamonds) + 
  geom_point(aes(x=carat, y=price, color=cut)) + 
  geom_smooth(aes(x=carat, y=price))

# Display where my remote Git repository is ... can help with trouble shooting

# system("git remote show origin")
