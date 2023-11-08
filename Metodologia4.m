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
t0 = find(C.Pc.mask.time(1:ind(1))==0);

%Se puede ver que la neurona 10 tiene timing parecido entre condiciones
%equivalentes y concuerda con el movimiento
figure(1)
hold on
plot(C.Pc.xA(1:ind(1),10));
plot(C.Pc.xA(1+ind(1):ind(2),10));
plot(C.Pc.xA(1+ind(2):ind(3),10));
plot(C.Pc.xA(1+ind(3):ind(4),10));
plot([t0,t0],[-0.2,0.9],"-k","LineWidth",1.5)
hold off
figure(2)
hold on
plot(C.Pc.xA(1+ind(4):ind(5),10));
plot(C.Pc.xA(1+ind(5):ind(6),10));
plot(C.Pc.xA(1+ind(6):ind(7),10));
plot(C.Pc.xA(1+ind(7):ind(8),10));
plot([t0,t0],[-0.2,0.9],"-k","LineWidth",1.5)
hold off

%Se usa neurona 10 para predecir
C1_10 = C.Pc.xA(1:ind(1),10);
C2_10 = C.Pc.xA(ind(1)+1:ind(2),10);
C3_10 = C.Pc.xA(ind(2)+1:ind(3),10);
C4_10 = C.Pc.xA(ind(3)+1:ind(4),10);
A10=[C1_10,C2_10,C3_10,C4_10];

me10 = mean(A10');
figure(3)
hold on
plot(me10)
title("Firing rate promedio neurona 10")
xlabel("Tiempo [ms]")
ylabel("Firing Rate")
hold off
[u,iu]=max(me10(1:1700));
umb = u/2;
iumbral=1;
while me(iumbral)<=umb
  iumbral=iumbral+1;
end

distIn=1500-iumbral;

datos4 = C.Pc.xA(ind(4)+1:ind(8),:);

C4 = zeros(ind(5)-ind(4),4);
C4(:,1) = datos4(1:ind(5)-ind(4),10);
C4(:,2) = datos4(ind(5)-ind(4)+1:ind(6)-ind(4),10);
C4(:,3) = datos4(ind(6)-ind(4)+1:ind(7)-ind(4),10);
C4(:,4) = datos4(ind(7)-ind(4)+1:ind(8)-ind(4),10);

inicios = [];
for i=1:4
  j = 1;
  while C4(j,i)<=umb
     j = j + 1;
  end

  inicios = [inicios j+distIn];
end

cumErr10 = sum(abs(1500-inicios))
meanErr10 = mean(abs(1500-inicios))




%Se usa promedio de todas las neuronas para predecir
C1_n = mean(C.Pc.xA(1:ind(1),:)');
C2_n = mean(C.Pc.xA(ind(1)+1:ind(2),:)');
C3_n = mean(C.Pc.xA(ind(2)+1:ind(3),:)');
C4_n = mean(C.Pc.xA(ind(3)+1:ind(4),:)');
An=[C1_n;C2_n;C3_n;C4_n];

meN = mean(An);
figure(4)
hold on
plot(meN)
title("Firing rate promedio de toda la población")
xlabel("Tiempo [ms]")
ylabel("Firing Rate")
hold off
[uN,iuN]=max(meN(1:1700));
umbN = uN/2;
iumbralN=1;
while meN(iumbralN)<=umbN
  iumbralN=iumbralN+1;
end

distInN=1500-iumbralN;

C4N = zeros(ind(5)-ind(4),4);
C4N(:,1) = mean(datos4(1:ind(5)-ind(4),:)');
C4N(:,2) = mean(datos4(ind(5)-ind(4)+1:ind(6)-ind(4),:)');
C4N(:,3) = mean(datos4(ind(6)-ind(4)+1:ind(7)-ind(4),:)');
C4N(:,4) = mean(datos4(ind(7)-ind(4)+1:ind(8)-ind(4),:)');

iniciosN = [];
for i=1:4
  j = 1;
  while C4(j,i)<=umbN
     j = j + 1;
  end

  iniciosN = [iniciosN j+distInN];
end

cumErrN = sum(abs(1500-iniciosN))
meanErrN = mean(abs(1500-iniciosN))
