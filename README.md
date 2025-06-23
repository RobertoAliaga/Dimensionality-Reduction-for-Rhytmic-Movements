# Dimensionality-Reduction-for-Rhytmic-Movements

This work aims to predict the movement onset from neural data for a rhytmic movement.

Data comes from [Russo et al. (2020)](https://github.com/aarusso/trajectory-divergence). It was obtained from an experiment in which a monkey had to pedal through a virtual landscape. Specifically, we use data from monkey C. 

Functions dpca.m, dpca_plot.m, and dpca_plot_default.m were constructed by [Kobak et al. (2016)](https://elifesciences.org/articles/10989) in MATLAB. Small changes were made to dpca_plot_default.m to plot desired colors in the obtained graphs.

The same methodology was followed in each case to establish a threshold that allows us to predict the movement onset. The difference is in the method that was used to process data: in one case, we applied PCA, in the second one, we applied dPCA, and in the third case, we used the raw data, without applying dimensionality reduction. The following four scripts were implemented in Octave:

* **Metodologia1.m**: first approach to data. It shows graphics of the activity of some neurons, and graphs of normalized velocity and position of the monkey's hand.
* **Metodologia2.m**: it shows graphs of velocity and position of the monkey's hand over time, firing rate of all neurons over time, and PCA application to predict movement onset.
* **Metodologia3.m**: it contains a similar procedure to Metodologia2.m, but using dPCA instead of PCA. It also shows a comparison between the performance of both dimensionality reduction techniques that were used (PCA and dPCA).
* **Metodologia4.m**: it contains two ways of predicting movement onset directly from neural activity data (without dimensionality reduction). The first one consists of using only one neuron that has a similar timing to that of the movement. The second one consists on using mean activity of all neurons.

This work was presented at the Summer School in Computational Intelligence (EVIC) 2023:

Roberto Aliaga Medina, Andrea Colins Rodríguez, J. Cristian Salgado. *Decoding rhythmic movements onset from neural activity using dimensionality reduction techniques.* 
