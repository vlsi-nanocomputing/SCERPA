function [ output_args ] = PlotElectrodeVariations( starting_point, electrode_width, electrode_height, test_lenght, surface_vector, color )

% QCASurface=[0.00109961477929809 0.00284178149510178 0.00585689761145013 0.00873450609107390 0.00564674356942750 -0.0160718080395823 -0.0740473364910968 -0.181051872410607 -0.330010453847524 -0.485644117921039 -0.595202968178298 -0.616499703618534 -0.543573853468711 -0.409186665925926 -0.262904979987113 -0.143651646537349 -0.0661923378714440;0.00128858277836597 0.00375606990797602 0.00879505938119915 0.0158947066671223 0.0191582364915501 0.00290019213549821 -0.0577654785216305 -0.184864672422156 -0.375711187601293 -0.587266657330197 -0.746926714976795 -0.791149764283510 -0.705071944049889 -0.530392054632814 -0.335975110706744 -0.177552363791339 -0.0765950703418218;0.000665646391900360 0.00315013847760032 0.00986681896749404 0.0231462599808460 0.0408348752284620 0.0490631690215254 0.0185471378046712 -0.0850047906722067 -0.273506866615914 -0.509635905833136 -0.710334595148595 -0.791037874041925 -0.720506059223909 -0.539674032240421 -0.329497481393735 -0.158944952408931 -0.0550847535062773];      
% starting_point=[0 0 0];
% electrode_width=1;
% electrode_height=2;
% test_lenght=8;
% surface_vector=QCASurface(2,8:16)
% color=10;

step_lenght=size(surface_vector, 2);
for i=1:step_lenght
    
    X(1,i) = [starting_point(1)-(test_lenght/(step_lenght-1))+i*(test_lenght/(step_lenght-1))];
    Y(1,i) = [starting_point(2)];
    Z(1,i) = [starting_point(3)+surface_vector(i)];    
end

for i=1:(step_lenght)
       
    X(1,i+step_lenght) = [starting_point(1)+test_lenght-(i-1)*(test_lenght/(step_lenght-1))];
    Y(1,i+step_lenght) = [starting_point(2)+electrode_width];
    Z(1,i+step_lenght) = [starting_point(3)+surface_vector(step_lenght-i+1)];  
end

for i=1:step_lenght
    
    X(2,i) = [starting_point(1)-(test_lenght/(step_lenght-1))+i*(test_lenght/(step_lenght-1))];
    Y(2,i) = [starting_point(2)];
    Z(2,i) = [starting_point(3)+surface_vector(i)+electrode_height];    
end

for i=1:step_lenght
       
    X(2,i+step_lenght) = [starting_point(1)+test_lenght-(i-1)*(test_lenght/(step_lenght-1))];
    Y(2,i+step_lenght) = [starting_point(2)+electrode_width];
    Z(2,i+step_lenght) = [starting_point(3)+surface_vector(step_lenght-i+1)+electrode_height];
end

for i=1:step_lenght
    
    X(3,i) = [X(1,i)];
    Y(3,i) = [Y(1,i)];
    Z(3,i) = [Z(1,i)];    
end

for i=1:step_lenght
       
%     X(3,i+step_lenght) = [starting_point(1)+test_lenght-i*(test_lenght/step_lenght)];
%     Y(3,i+step_lenght) = [starting_point(2)];
%     Z(3,i+step_lenght) = [starting_point(3)+surface_vector(i)+electrode_height];  
    
    X(3,i+step_lenght) = [X(2,step_lenght-i+1)];
    Y(3,i+step_lenght) = [Y(2,step_lenght-i+1)];
    Z(3,i+step_lenght) = [Z(2,step_lenght-i+1)];  

end

for i=1:step_lenght
    
%     X(4,i) = [starting_point(1)-(test_lenght/step_lenght)+i*(test_lenght/step_lenght)];
%     Y(4,i) = [starting_point(2)+electrode_width];
%     Z(4,i) = [starting_point(3)+surface_vector(i)];

    X(4,i) = [X(1,step_lenght+i)];
    Y(4,i) = [Y(1,step_lenght+i)];
    Z(4,i) = [Z(1,step_lenght+i)]; 
end

for i=1:step_lenght
           
    X(4,i+step_lenght) = [X(2,2*step_lenght-i+1)];
    Y(4,i+step_lenght) = [Y(2,2*step_lenght-i+1)];
    Z(4,i+step_lenght) = [Z(2,2*step_lenght-i+1)];
    
end


    S(1,1) = [X(1,1)];
    P(1,1) = [Y(1,1)];
    Q(1,1) = [Z(1,1)];
   
    S(1,2) = [X(2,1)];
    P(1,2) = [Y(2,1)];
    Q(1,2) = [Z(2,1)];


    S(1,3) = [X(2,2*step_lenght)];
    P(1,3) = [Y(2,2*step_lenght)];
    Q(1,3) = [Z(2,2*step_lenght)];


    S(1,4) = [X(1,2*step_lenght)];
    P(1,4) = [Y(1,2*step_lenght)];
    Q(1,4) = [Z(1,2*step_lenght)];
    



       
    S(2,1) = [X(2,step_lenght+1)];
    P(2,1) = [Y(2,step_lenght+1)];
    Q(2,1) = [Z(2,step_lenght+1)];
   
    S(2,2) = [X(2,step_lenght)];
    P(2,2) = [Y(2,step_lenght)];
    Q(2,2) = [Z(2,step_lenght)];


    S(2,4) = [X(1,step_lenght+1)];
    P(2,4) = [Y(1,step_lenght+1)];
    Q(2,4) = [Z(1,step_lenght+1)];


    S(2,3) = [X(1,step_lenght)];
    P(2,3) = [Y(1,step_lenght)];
    Q(2,3) = [Z(1,step_lenght)];
      
    

C = [0.5000 2.0000 1.0000 0.5000];

for i=1:2*step_lenght
    C(i)=color;
end

for i=1:4
    C_front(i)=color;
end


for i=1:4
fill3(X(i,:),Y(i,:),Z(i,:),C)
axis('equal');
hold on
end

for i=1:2
fill3(S(i,:),P(i,:),Q(i,:),C_front)
axis('equal');
hold on
end
output_args='true';
end

