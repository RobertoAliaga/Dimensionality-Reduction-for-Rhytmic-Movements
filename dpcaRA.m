%Se cargan los datos
C = load("Cousteau_tt.mat");

%Se busca el indice de termino de cada condicion
ind = zeros(20,1);
for i = 1:20
    a = find(C.Pc.mask.condNum==i);
    ind(i) = a(end);
end

%Se guarda la matriz de datos y se transpone, para darle el formato
datos = C.Pc.xA(1:ind(4),:);
datost = datos';

%Se da el formato adecuado a los datos
D=zeros(116,4,ind(1));
D(:,1,:)=datost(:,1:ind(1));
D(:,2,:)=datost(:,ind(1)+1:ind(2));
D(:,3,:)=datost(:,ind(2)+1:ind(3));
D(:,4,:)=datost(:,ind(3)+1:ind(4));

%Se crea un vector de tiempos y se marca el tiempo de inicio
time = 1:ind(1);
timeEvents = 1500;

%D(neuronas,tiempo,condicion)
%1.-  Condicion
%2.-  Tiempo
%    [1 2] - tiempo/condicion interaction

%%%%%%%%%%%%%%% PRUEBA CON CONDICION/TIEMPO, TIEMPO Y CONDICION %%%%%%%%%%%
combinedParams1 = {{1, [1 2]},{2},{1}};

%Se hace dPCA
[W, V, whichMarg]= dpca(D,12, 'combinedParams', combinedParams1);

%Se guardan datos del DPCA aplicado
explVar = dpca_explainedVariance(D, W, V,'combinedParams', combinedParams1)

margNames = {'Condition/Time','Time','Condition'};
margColours = [23 100 171; 187 20 25;150 150 150]/256;

dpca_plot(D, W, V, @dpca_plot_default, ...
    'explainedVar', explVar, ...
    'marginalizationNames', margNames, ...
    'marginalizationColours', margColours, ...
    'whichMarg', whichMarg,                 ...
    'time', time,                        ...
    'timeEvents', timeEvents,               ...
    'timeMarginalization', 2, ...
    'legendSubplot', 16);

%%%%%%%%%%%%%%%%%%% PRUEBA CON CONDICION/TIEMPO Y TIEMPO  %%%%%%%%%%%%%%%%%
combinedParams2 = {{1, [1 2]},{2}};

%Se hace dPCA
[W2, V2, whichMarg2]= dpca(D,12, 'combinedParams', combinedParams2);

%Se guardan datos del DPCA aplicado
explVar2 = dpca_explainedVariance(D, W2, V2,'combinedParams', combinedParams2)

margNames2 = {'Condition/Time','Time'};
margColours2 = [23 100 171; 187 20 25]/256;

dpca_plot(D, W2, V2, @dpca_plot_default, ...
    'explainedVar', explVar2, ...
    'marginalizationNames', margNames2, ...
    'marginalizationColours', margColours2, ...
    'whichMarg', whichMarg2,                 ...
    'time', time,                        ...
    'timeEvents', timeEvents,               ...
    'timeMarginalization', 2, ...
    'legendSubplot', 16);

%%%%%%%%%%%%%%%%%%% PRUEBA CON SEPARACION DIRECCION/INICIO  %%%%%%%%%%%%%%%

%Se prueba separando la direccion del punto de inicio
E=zeros(116,2,2,ind(1));
E(:,1,1,:)=datost(:,1:ind(1));
E(:,1,2,:)=datost(:,ind(1)+1:ind(2));
E(:,2,1,:)=datost(:,ind(2)+1:ind(3));
E(:,2,2,:)=datost(:,ind(3)+1:ind(4));

%E(neuronas,tiempo,direccion,inicio)
%1.- Direccion (adelante/atras)
%2.- Inicio (abajo/arriba)
%3.- Tiempo
combinedParams3 = {{1, [1 3]}, {2, [2 3]}, {3}, {[1 2], [1 2 3]}};
margNames3 = {'Direction/Tiempo', 'Start/Time', 'Time', 'Direction/Start Interaction'};
margColours3 = [23 100 171; 187 20 25; 150 150 150; 114 97 171]/256;

%dpca_perMarginalization(E, @dpca_plot_default, ...
%   'combinedParams', combinedParams2);


[X, Y, whichMarg3]= dpca(E,12, 'combinedParams', combinedParams3);
explVar3 = dpca_explainedVariance(E, X, Y,'combinedParams', combinedParams3)


dpca_plot(E, X, Y, @dpca_plot_default, ...
    'explainedVar', explVar3, ...
    'marginalizationNames', margNames3, ...
    'marginalizationColours', margColours3, ...
    'whichMarg', whichMarg3,                 ...
    'time', time,                        ...
    'timeEvents', timeEvents,               ...
    'timeMarginalization', 3, ...
    'legendSubplot', 16);


