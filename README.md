# Dimensionality-Reduction-for-Rhytmic-Movements

Las funciones dpca.m, dpca_plot.m y dpca_plot_default.m fueron creadas por Kobak et al. (2016).
Sólo se hicieron pequeños cambios sobre dpca_plot_default.m para que entregara resultados con los colores deseados.

Para predecir el inicio del movimiento, en todos los casos se siguió la misma metodología con el fin de establecer un umbral. La diferencia está en el método usado para procesar los datos: se usó PCA, dPCA y los datos directos, sin usar reducción de la dimensionalidad.

Metodologia1.m contiene un primer acercamiento a los datos.
Metodologia2.m contiene gráficos de velocidad y posición de la mano en el tiempo, firing rate de todas las neuronas en el tiempo y aplicación de PCA para predecir tiempos de inicio de movimiento.
Metodologia3.m contiene información análoga a la de Metodologia2.m, pero usando dPCA. También contiene una comparación entre el desempeño de los métodos de predicción usando PCA vs dPCA.
Metodologia4.m contiene dos maneras de predecir el inicio del movimiento usando los datos de la actividad neuronal directamente (sin aplicar reducción de la dimensionalidad). La primera manera consiste en usar sólo una neurona que tiene un timing parecido al del movimiento. La segunda manera consiste en usar la actividad promedio de la población.
