#Se cargan los datos del mono C
C = load("Cousteau_tt.mat");

#Se encuentran los indices finales de cada condicion
ind = zeros(20,1);
for i = 1:20
  ind(i) = find(C.Pc.mask.condNum==i)(end);
end

#Se grafica una condicion de ejemplo. Corresponde a la condicion 1
#C.Pc.mask.condNum -> Numero de condicion (de 1 a 20)
#C.Pc.mask.time -> Tiempo con respecto al inicio del movimiento (en seg)
#C.Pc.mask.dist -> Cantidad de ciclos (7, 4, 2, 1 o 0.5)
#C.Pc.mask.dir -> Direccion del movimiento (hacia adelante 1, hacia atras -1)
#C.Pc.mask.pos -> Posicion de inicio (desde abajo 0, desde arriba 0.5)

#(mono C, 7 ciclos, desde abajo, hacia adelante)

#Se busca el momento de inicio del movimiento
#Se dibuja una recta en cada una de los graficos
t0 = find(C.Pc.mask.time(1:ind(1))==0);

#Velocidad del pedal
#Horizontal
figure(1)
subplot(3,1,1)
 hold on
 plot(C.Pc.vA(1:ind(1),1))
#Vertical
 plot(C.Pc.vA(1:ind(1),2))
#Inicio del movimiento
 plot([t0,t0],[-0.03,0.02],"-y","LineWidth",1.5)

 legend("Horizontal velocity","Vertical velocity")
 xlabel("Time [ms]")
 ylabel("Velocity")
 title("Hand velocity on a 7-cycles movement (Forward/Bottom)")
 hold off


#Posicion del pedal
#Horizontal (se mueve hacia atras)
subplot(3,1,2)
 hold on
 plot(C.Pc.pA(1:ind(1),1))
#Vertical (inicia abajo)
 plot(C.Pc.pA(1:ind(1),2))
 #Inicio del movimiento
 plot([t0,t0],[-1,1],"-y","LineWidth",1.5)

 legend("Horizontal position","Vertical position")
 xlabel("Time [ms]")
 ylabel("Position")
 title("Hand position on a 7-cycles movement (Forward/Bottom)")
 hold off

#Hay 116 neuronas. La matriz C.Pc.xA contiene 116 columnas, donde cada
#una corresponde a la actividad de esa neurona en las 20 pruebas
#concatenadas.
#Los datos ya estan centrados, normalizados y lo que se presenta es un
#promedio entre las iteraciones de una misma prueba.
#Todos los datos se tomaron a 1 kHz, es decir, cada 1 ms.

#Se escogen 4 neuronas
#Se grafica el correspondiente a las mismas condiciones de movimiento
#Neuronas 10, 27, 43 y 99
subplot(3,1,3)
hold on
plot(C.Pc.xA(1:ind(1),10),"g")
plot(C.Pc.xA(1:ind(1),27),"m")
plot(C.Pc.xA(1:ind(1),43),"k")
plot(C.Pc.xA(1:ind(1),99),"c")
#Inicio del movimiento
 plot([t0,t0],[-0.4,0.8],"-y","LineWidth",1.5)
xlabel("Time [ms]")
ylabel("Neuronal activity")
title("Activity of example neurons on a 7-cycles movement (Forward/Bottom)  ")
legend("10th neuron", "27th neuron", "43rd neuron", "99th neuron")
hold off

pkg load statistics
#El promedio de cada condicion por separado no es 0
#El promedio de cada columna si es 0

#Se deberia considerar las primeras 4 condiciones (de 7 ciclos)
#Restar 300 ms al tiempo de cada condicion, para priorizar dimensiones que
#capturan actividad relacionada con el movimiento
C1 = C.Pc.xA(1300:ind(1)-300,:); #7 ciclos, hacia adelante, desde abajo
C2 = C.Pc.xA(ind(1)+1300:ind(2)-300,:); #7 ciclos, hacia adelante, desde arriba
C3 = C.Pc.xA(ind(2)+1300:ind(3)-300,:); #7 ciclos, hacia atras, desde abajo
C4 = C.Pc.xA(ind(3)+1300:ind(4)-300,:); #7 ciclos, hacia atras, desde arriba
X = [C1;C2;C3;C4];

#Se confirma que los indices sean los adecuados
#plot(C.Pc.vA(ind(1)+1300:ind(2)-300,1))

#Se hace PCA
[coef,score,latent,tsquared,explained] = pca(X);
exp = cumsum(explained);
figure(2)
plot(1:116,exp,'o-')
title("Variance explained by Principal Components")
ylabel("Cummulative variance captured (%)")
xlabel("Principal Component")
e3 = exp(3);

figure(3)
plot3(score(:,1),score(:,2),score(:,3))
xlabel("PC1")
ylabel("PC2")
zlabel("PC3")
title("Primera visualizacion")
hold off

C1pca = C1*coef;
C2pca = C2*coef;
C3pca = C3*coef;
C4pca = C4*coef;

figure(4)
hold on
plot3(C1pca(:,1),C1pca(:,2),C1pca(:,3))
plot3(C2pca(:,1),C2pca(:,2),C2pca(:,3))
plot3(C3pca(:,1),C3pca(:,2),C3pca(:,3))
plot3(C4pca(:,1),C4pca(:,2),C4pca(:,3))
xlabel("PC1")
ylabel("PC2")
zlabel("PC3")
legend("Forward/Bottom","Forward/Top","Backward/Bottom", "Backward/Top")
title("Population trajectory during seven-cycle movements")
hold off

figure(5)
hold on
scatter3(C1pca(:,1),C1pca(:,2),C1pca(:,3),14,1:3731,"filled")
xlabel("PC1")
ylabel("PC2")
zlabel("PC3")
title("Population trajectory during seven-cycle movement (Forward/Bottom)")
colorbar
hold off

figure(6)
hold on
scatter3(C2pca(:,1),C2pca(:,2),C2pca(:,3),14,1:3731,"filled")
xlabel("PC1")
ylabel("PC2")
zlabel("PC3")
title("Population trajectory during seven-cycle movement (Forward/Top)")
colorbar
hold off

