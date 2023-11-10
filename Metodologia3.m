close all
clear all
clc
pkg load statistics
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

%Se trabaja con PCA
[coef,score,latent,tsquared,explained] = pca(C.Pc.xA(1:ind(4),:),"Centered",false);

%Se proyectan las condiciones de 7 ciclos sobre PC1
C1pca = C.Pc.xA(1:ind(1),:)*coef;
C2pca = C.Pc.xA(ind(1)+1:ind(2),:)*coef;
C3pca = C.Pc.xA(ind(2)+1:ind(3),:)*coef;
C4pca = C.Pc.xA(ind(3)+1:ind(4),:)*coef;
%Se crea una matriz y se calcula el promedio temporal de las proyecciones
A=[C1pca(:,1),C2pca(:,1),C3pca(:,1),C4pca(:,1)];
me = mean(A,2);

%Se define el umbral
[v,iv]=max(me(1:1700));
umbralPCA=v/2;
iumbral=1;
while me(iumbral)<=umbralPCA
  iumbral=iumbral+1;
end

distInicioPCA=1500-iumbral;

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
  while C4ciclosPCA(j,i)<=umbralPCA
     j = j + 1;
  end

  iniciosPCA = [iniciosPCA j+distInicioPCA];
end





#Se trabaja con dPCA
W2 = load("W2.mat");
W2 = W2.W2;
explVar2 = load("explVar2.mat");
explVar2 = explVar2.explVar2;
whichMarg2 = load("whichMarg2.mat");
whichMarg2 = whichMarg2.whichMarg2;

%Se guarda la matriz de datos de 7 ciclos y se transpone
datos = C.Pc.xA(1:ind(4),:);
datost = datos';

%Se da el formato adecuado a los datos
D=zeros(116,4,ind(1));
D(:,1,:)=datost(:,1:ind(1));
D(:,2,:)=datost(:,ind(1)+1:ind(2));
D(:,3,:)=datost(:,ind(2)+1:ind(3));
D(:,4,:)=datost(:,ind(3)+1:ind(4));

Da = D(:,:)';
Dcen = bsxfun(@minus, Da, mean(Da));
Z = Dcen * W2;
Zfull = reshape(Z(:,1)', [length(1) 4 5330]);
data = squeeze(Zfull);

%Se calcula el promedio temporal de los datos
me = mean(data);

#Proyeccion de la actividad neruonal en PC1 (solo depende de tiempo)
figure(1)
hold on
plot(1:ind(1),data(1,:),'LineWidth',2)
plot(1:ind(1),data(2,:),'LineWidth',2)
plot(1:ind(1),data(3,:),'LineWidth',2)
plot(1:ind(1),data(4,:),'LineWidth',2)
plot(1:ind(1),me,'LineWidth',2)
plot([t0,t0],[-2,3],"-k","LineWidth",1.5)
ylabel("Projection on PC1")
xlabel("Time [ms]")
title("Projection of neural population activity on PC1")
legend("Forward/Bottom (Condition 1)","Forward/Top (Condition 2)","Backward/Bottom (Condition 3)", "Backward/Top (Condition 4)","Mean")
hold off

%DEFINICION DEL UMBRAL
%Se busca el primer peak del promedio de la proyeccion
[u,iu]=max(me(1:1700));
%El umbral se define como la mitad del valor del peak
umbral=u/2;

%Se busca el tiempo para el cual se alcanza el valor umbral
tumbral=1;
while me(tumbral)<=umbral
  tumbral=tumbral+1;
end

%Se calcula el intervalo temporal entre el tiempo en que se alcanza el umbral
%y el tiempo de inicio real del movimiento para condiciones de 7-ciclos
distInicio=1500-tumbral;

%Se busca el tiempo de inicio de la condicion de 4 ciclos, backward/top
tini = find(C.Pc.mask.time(ind(7)+1:ind(8))==0);

%Se cargan todos los datos de 4 ciclos
datos4 = C.Pc.xA(ind(4)+1:ind(8),:);
datos4t = datos4';
largo = ind(5)-ind(4);

%Se da el formato adecuado a los datos
D4=zeros(116,4,largo);
D4(:,1,:)=datos4t(:,1:ind(5)-ind(4));
D4(:,2,:)=datos4t(:,ind(5)-ind(4)+1:ind(6)-ind(4));
D4(:,3,:)=datos4t(:,ind(6)-ind(4)+1:ind(7)-ind(4));
D4(:,4,:)=datos4t(:,ind(7)-ind(4)+1:ind(8)-ind(4));

#Se proyecta la actividad de 4 ciclos en PC1
D4a = D4(:,:)';
D4cen = bsxfun(@minus, D4a, mean(D4a));
Z4 = D4cen * W2;
Z4full = reshape(Z4(:,1)', [length(1) 4 ind(5)-ind(4)]);
data4 = squeeze(Z4full);

%Se predice el tiempo de inicio para cada condicion de 4 ciclos usando dPCA
iniciosDPCA = [];
for i=1:4
  j = 1;
  while data4(i,j)<=umbral
     j = j + 1;
  end
  iniciosDPCA = [iniciosDPCA j+distInicio];
end

%Se grafican las proyecciones de las condiciones de 4 ciclos sobre dPC1
figure(2)
hold on
plot(1:ind(5)-ind(4),data4(1,:),'LineWidth',2)
plot(1:ind(5)-ind(4),data4(2,:),'LineWidth',2)
plot(1:ind(5)-ind(4),data4(3,:),'LineWidth',2)
plot(1:ind(5)-ind(4),data4(4,:),'LineWidth',2)
plot([tini,tini],[-2,3],"-k","LineWidth",1.5)
ylabel("Projection on PC1")
xlabel("Time [ms]")
title("Projection of neural population activity on dPC1 for 4-cycles movements")
legend("Forward/Bottom","Forward/Top","Backward/Bottom", "Backward/Top")
hold off

%Se define una matriz con los tiempos de inicio de PCA y dPCA
tiemposini = [iniciosPCA,;iniciosDPCA]'
%Se grafican las predicciones con dPCA
figure(3)
subplot(1,2,1)
hold on
h = bar (tiemposini);
set (h(1), "facecolor", "#4DBEEE");
set (h(2), "facecolor", "#A2142F");
xlim([0.5,4.5]);
plot([0.5,4.5],[1500,1500],"-k","LineWidth",2);
xlabel("Condition")
ylabel("Predicted time [ms]")
legend("PCA","dPCA","location","north")
hold off
title ("Prediction of movement onset time");

%Se calcula el error absoluto de cada prediccion
diftiemposini = abs((tiemposini-1500*ones(size(tiemposini))))';

%Se grafica el error absoluto acumulado para PCA y dPCA
subplot(1,2,2)
h = bar (diftiemposini,"stacked");
set (gca, 'xtick', [1 2])
set (gca, 'xticklabel', {'PCA','dPCA'})
xlabel("Utilized method")
ylabel("Absolute error [ms]")
legend("Condition 1","Condition 2","Condition 3", "Condition 4")
title("Accumulated absolute error on movement onset prediction")

#Se calculan errores acumulados y promedios para PCA y dPCA
cumErrPCA = sum(diftiemposini(1,:))
cumErrDPCA = sum(diftiemposini(2,:))
meanErrPCA = mean(diftiemposini(1,:))
meanErrDPCA = mean(diftiemposini(2,:))

#VERSION 1
%Se grafican las predicciones con dPCA
figure(4)
subplot(1,2,1)
hold on
h = bar (tiemposini);
set (h(1), "facecolor", "#4DBEEE");
set (h(2), "facecolor", "#A2142F");
xlim([0.5,4.5]);
plot([0.5,4.5],[1500,1500],"-k","LineWidth",2);
xlabel("Condition")
ylabel("Predicted time [ms]")
legend("PCA","dPCA","location","north")
hold off
%title ("Prediction of movement onset time");


%Se grafica el error absoluto para PCA y dPCA
subplot(1,2,2)
hold on
h = bar (diftiemposini');
set (h(1), "facecolor", "#4DBEEE");
set (h(2), "facecolor", "#A2142F");
xlabel("Condition")
ylabel("Absolute error [ms]")
plot([0.825 1.825 2.825 3.825],diftiemposini(1,:),"o","color","#4DBEEE","LineWidth",2);
plot([1.175 2.175 3.175 4.175],diftiemposini(2,:),"o","color","#A2142F","LineWidth",2);
plot([0.825 1.175],diftiemposini'(1,:),"-.k","LineWidth",2);
plot([1.825 2.175],diftiemposini'(2,:),"-.k","LineWidth",2);
plot([2.825 3.175],diftiemposini'(3,:),"-.k","LineWidth",2);
plot([3.825 4.175],diftiemposini'(4,:),"-.k","LineWidth",2);
%legend("PCA","dPCA")
%title("Absolute error on movement onset prediction")



#VERSION 2
%Se grafican las predicciones con dPCA y PCA
figure(5)
subplot(1,2,1)
hold on
h = bar (tiemposini);
set (h(1), "facecolor", "#4DBEEE");
set (h(2), "facecolor", "#A2142F");
xlim([0.5,4.5]);
plot([0.5,4.5], [1500,1500], "-k", "LineWidth",2);
xlabel("Condition")
ylabel("Predicted time [ms]")
legend("PCA", "dPCA", "location", "north")
hold off
%title ("Prediction of movement onset time");


%Se grafica el error absoluto para PCA y dPCA
subplot(1,2,2)
hold on
xlabel("Condition")
ylabel("Absolute error [ms]")
plot([0.825 1.825 2.825 3.825],diftiemposini(1,:),"o","color","#4DBEEE","LineWidth",2);
plot([1.175 2.175 3.175 4.175],diftiemposini(2,:),"s","color","#A2142F","LineWidth",2);
plot([0.825 1.175],diftiemposini'(1,:),"-.k","LineWidth",2);
plot([1.825 2.175],diftiemposini'(2,:),"-.k","LineWidth",2);
plot([2.825 3.175],diftiemposini'(3,:),"-.k","LineWidth",2);
plot([3.825 4.175],diftiemposini'(4,:),"-.k","LineWidth",2);
%legend("PCA","dPCA")
%title("Absolute error on movement onset prediction")
