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
subplot(2,1,1)
 hold on
 plot(C.Pc.vA(1:ind(1),1))
#Vertical
 plot(C.Pc.vA(1:ind(1),2))
#Inicio del movimiento
 plot([t0,t0],[-0.03,0.02],"-y","LineWidth",1.5)

 legend("Horizontal velocity","Vertical velocity")
 xlabel("Time [ms]")
 ylabel("Normalized Velocity")
 title("Hand velocity on a 7-cycles movement (Forward/Bottom)")
 hold off


#Posicion del pedal
#Horizontal (se mueve hacia atras)
subplot(2,1,2)
 hold on
 plot(C.Pc.pA(1:ind(1),1))
#Vertical (inicia abajo)
 plot(C.Pc.pA(1:ind(1),2))
 #Inicio del movimiento
 plot([t0,t0],[-1,1],"-y","LineWidth",1.5)

 legend("Horizontal position","Vertical position")
 xlabel("Time [ms]")
 ylabel("Normalized Position")
 title("Hand position on a 7-cycles movement (Forward/Bottom)")
 hold off

#Hay 116 neuronas. La matriz C.Pc.xA contiene 116 columnas, donde cada
#una corresponde a la actividad de esa neurona en las 20 pruebas
#concatenadas.
#Los datos ya estan centrados, normalizados y lo que se presenta es un
#promedio entre las iteraciones de una misma prueba.
#Todos los datos se tomaron a 1 kHz, es decir, cada 1 ms.

#Se grafica la actividad de todas las neuronas
figure(2)
hold on
imagesc(C.Pc.xA(1:ind(1),:)')
colormap(flipud(gray))
xlim([1,5330])
ylim([1,116])
colorbar
#Inicio del movimiento
plot([t0,t0],[0.5,116.5],"-y","LineWidth",1.5)
xlabel("Time [ms]")
ylabel("Neurons")
title("Normalized Firing rate of neurons on a 7-cycles movement (Forward/Bottom)")
hold off

#Se juntan las 3 imagenes anteriores
figure(3)
subplot(3,1,1)
 hold on
 plot(C.Pc.vA(1:ind(1),1))
#Vertical
 plot(C.Pc.vA(1:ind(1),2))
#Inicio del movimiento
 plot([t0,t0],[-0.03,0.02],"-y","LineWidth",1.5)
 xlim([1,5330])
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
 xlim([1,5330])
 legend("Horizontal position","Vertical position")
 xlabel("Time [ms]")
 ylabel("Position")
 title("Hand position on a 7-cycles movement (Forward/Bottom)")
 hold off

#Firing rate de todas las neuronas
subplot(3,1,3)
 hold on
 imagesc(C.Pc.xA(1:ind(1),:)')
 xlim([1,5330])
 ylim([1,116])
 colormap(flipud(gray))
 colorbar("northoutside")
#Inicio del movimiento
 plot([t0,t0],[0.5,116.5],"-y","LineWidth",1.5)
 ylabel("Neurons")
 xlabel("Time [ms]")
 title({"Firing rate of neurons on a 7-cycles movement (Forward/Bottom)","","","",""})
 hold off


pkg load statistics
#El promedio de cada condicion por separado no es 0
#El promedio de cada columna si es 0

#Se deberia considerar las primeras 4 condiciones (de 7 ciclos)

#Se hace PCA
[coef,score,latent,tsquared,explained] = pca(C.Pc.xA(1:ind(4),:),"Centered",false);
exp = cumsum(explained);
figure(4)
plot(1:116,exp,'o-')
title("Variance explained by Principal Components")
ylabel("Cummulative variance captured (%)")
xlabel("Principal Component")

figure(5)
plot3(score(:,1),score(:,2),score(:,3))
xlabel("PC1")
ylabel("PC2")
zlabel("PC3")
title("Primera visualizacion")
hold off

C1pca = C.Pc.xA(1:ind(1),:)*coef;
C2pca = C.Pc.xA(ind(1)+1:ind(2),:)*coef;
C3pca = C.Pc.xA(ind(2)+1:ind(3),:)*coef;
C4pca = C.Pc.xA(ind(3)+1:ind(4),:)*coef;

figure(6)
hold on
plot3(C1pca(:,1),C1pca(:,2),C1pca(:,3),'LineWidth',2)
plot3(C2pca(:,1),C2pca(:,2),C2pca(:,3),'LineWidth',2)
plot3(C3pca(:,1),C3pca(:,2),C3pca(:,3),'LineWidth',2)
plot3(C4pca(:,1),C4pca(:,2),C4pca(:,3),'LineWidth',2)
xlabel("PC1")
ylabel("PC2")
zlabel("PC3")
legend("Forward/Bottom (Condition 1)","Forward/Top (Condition 2)","Backward/Bottom (Condition 3)", "Backward/Top (Condition 4)")
title("Population trajectory during seven-cycle movements")
hold off

#Se busca el maximo firing rate de cada neurona entre 250 ms antes y 250 ms
#despues del inicio del movimiento
valores=[];
indval=[];
for j=1:116
  [w,iw]=max(C.Pc.xA(1250:1750,j));
  valores=[valores;w];
  indval=[indval;iw];
end


#Se ordenan segun cual aparece primero
[s,i]=sort(indval);

actNeurSort=zeros(size(C.Pc.xA(1:ind(1),:)));
for j=1:116
  actNeurSort(1:ind(1),j)=C.Pc.xA(1:ind(1),i(j));
end

figure(7)
hold on
imagesc(actNeurSort(1:ind(1),:)')
colormap(flipud(gray))
xlim([1,5330])
ylim([1,116])
colorbar
#Inicio del movimiento
plot([t0,t0],[0.5,116.5],"-y","LineWidth",1.5)
xlabel("Time [ms]")
ylabel("Neurons")
title("Soft normalized firing rate of neurons on a 7-cycles movement (Forward/Bottom)")
hold off


#Se juntan las 3 imagenes
figure(8)
subplot(3,1,1)
 hold on
 plot(C.Pc.vA(1:ind(1),1),"LineWidth",2)
#Vertical
 plot(C.Pc.vA(1:ind(1),2),"LineWidth",2)
#Inicio del movimiento
 plot([t0,t0],[-0.03,0.02],"-k","LineWidth",2)
 xlim([1,5330])
 legend("Horizontal","Vertical","location","northwest")
 xlabel("Time [ms]")
 ylabel("Velocity")
 title("Normalized hand velocity on a 7-cycles movement (Forward/Bottom)")
 hold off

#Posicion del pedal
#Horizontal (se mueve hacia atras)
subplot(3,1,2)
 hold on
 plot(C.Pc.pA(1:ind(1),1),"LineWidth",2)
#Vertical (inicia abajo)
 plot(C.Pc.pA(1:ind(1),2),"LineWidth",2)
 #Inicio del movimiento
 plot([t0,t0],[-1,1],"-k","LineWidth",2)
 xlim([1,5330])
 xlabel("Time [ms]")
 ylabel("Position")
 title("Normalized hand position on a 7-cycles movement (Forward/Bottom)")
 hold off

#Firing rate de todas las neuronas
subplot(3,1,3)
 hold on
 imagesc(actNeurSort(1:ind(1),:)')
 xlim([1,5330])
 ylim([1,116])
 %colormap(flipud(gray))
 colormap(flipud(autumn))
 colorbar("northoutside")
#Inicio del movimiento
 plot([t0,t0],[0.5,116.5],"-k","LineWidth",2)
 ylabel("Neurons")
 xlabel("Time [ms]")
 title({"Soft normalized firing rate of neurons on a 7-cycles movement (Forward/Bottom)","","","",""})
 hold off

A=[C1pca(:,1),C2pca(:,1),C3pca(:,1),C4pca(:,1)];
me=mean(A,2);

#Proyeccion de la actividad neruonal en PC1
figure(9)
hold on
plot(1:ind(1),C1pca(:,1),'LineWidth',2)
plot(1:ind(1),C2pca(:,1),'LineWidth',2)
plot(1:ind(1),C3pca(:,1),'LineWidth',2)
plot(1:ind(1),C4pca(:,1),'LineWidth',2)
plot(1:ind(1),me,'LineWidth',2)
plot([t0,t0],[-2,3],"-k","LineWidth",1.5)
ylabel("Projection on PC1")
xlabel("Time [ms]")
xlim([0,ind(1)])
title("Projection of neural population activity on PC1")
legend("Condition 1: Forward/Bottom","Condition 2: Forward/Top","Condition 3: Backward/Bottom", "Condition 4: Backward/Top","Mean","location","northwest")
hold off

[v,iv]=max(me(1:1700));
umbral=v/2;
iumbral=1;

while me(iumbral)<=umbral
  iumbral=iumbral+1;
end

distInicio=1500-iumbral;

#Se proyecta la actividad de 4 ciclos en PC1
tini = find(C.Pc.mask.time(ind(7)+1:ind(8))==0);

C4ciclosPCA=zeros(length(C.Pc.xA(ind(4)+1:ind(5),:)),4);

C4ciclosPCA(:,1)=(C.Pc.xA(ind(4)+1:ind(5),:)*coef)(:,1);
C4ciclosPCA(:,2)=(C.Pc.xA(ind(5)+1:ind(6),:)*coef)(:,1);
C4ciclosPCA(:,3)=(C.Pc.xA(ind(6)+1:ind(7),:)*coef)(:,1);
C4ciclosPCA(:,4)=(C.Pc.xA(ind(7)+1:ind(8),:)*coef)(:,1);

iniciosPCA = [];
for i=1:4
  j = 1;
  while C4ciclosPCA(j,i)<=umbral
     j = j + 1;
  end

  iniciosPCA = [iniciosPCA j+distInicio];
end

figure(10)
hold on
plot(1:ind(5)-ind(4),C4ciclosPCA(:,1),'LineWidth',2)
plot(1:ind(5)-ind(4),C4ciclosPCA(:,2),'LineWidth',2)
plot(1:ind(5)-ind(4),C4ciclosPCA(:,3),'LineWidth',2)
plot(1:ind(5)-ind(4),C4ciclosPCA(:,4),'LineWidth',2)
plot([tini,tini],[-2,3],"-k","LineWidth",1.5)
ylabel("Projection on PC1")
xlabel("Time [ms]")
title("Projection of neural population activity on PC1 of PCA for 4-cycles movements")
legend("Forward/Bottom","Forward/Top","Backward/Bottom", "Backward/Top")
hold off


