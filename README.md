# Dimensionality-Reduction-for-Rhytmic-Movements

Se trabaja con datos de \href{https://github.com/aarusso/trajectory-divergence}{Russo et al. (2020)}, obtenidos a partir de un experimento en el cual un mono debía pedalear a través de un paisaje virtual. Específicamente, se utilizan los datos del mono C.

Las funciones dpca.m, dpca_plot.m y dpca_plot_default.m fueron creadas por \href{https://elifesciences.org/articles/10989{Kobak et al. (2016)} en Matlab.
Sólo se hicieron pequeños cambios sobre dpca_plot_default.m para que el color en los gráficos resultantes fuera el deseado.

Para predecir el inicio del movimiento, en todos los casos se siguió la misma metodología con el fin de establecer un umbral. La diferencia está en el método usado para procesar los datos: se usó PCA, dPCA y los datos directos, sin usar reducción de la dimensionalidad. Los siguientes cuatro archivos fueron creados en Octave:

* **Metodologia1.m** contiene un primer acercamiento a los datos. Gráfico de actividad de algunas neuronas, velocidad y posición de la mano normalizadas.
* **Metodologia2.m** contiene gráficos de velocidad y posición de la mano en el tiempo, firing rate de todas las neuronas en el tiempo y aplicación de PCA para predecir tiempos de inicio de movimiento.
* **Metodologia3.m** contiene información análoga a la de Metodologia2.m, pero usando dPCA. También contiene una comparación del desempeño de las dos herramientas de reducción de la dimensionalidad que se utilizaron (PCA y dPCA).
* **Metodologia4.m** contiene dos maneras de predecir el inicio del movimiento usando los datos de la actividad neuronal directamente (sin aplicar reducción de la dimensionalidad). La primera manera consiste en usar sólo una neurona que tiene un timing parecido al del movimiento. La segunda manera consiste en usar la actividad promedio de la población.
