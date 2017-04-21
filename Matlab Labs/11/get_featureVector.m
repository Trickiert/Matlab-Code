function vector=get_featureVector(image)


[A1,H1,V1,D1] = dwt2(double(image),'haar','mode','per');  % four sub-bands in the first decomposition of the block
[A2,H2,V2,D2] = dwt2(A1,'haar','mode','per'); % second decomposition
[A3,H3,V3,D3] = dwt2(A2,'haar','mode','per'); % third decomposition
% use mean and standard deviation
vector=[mean(mean(abs(H1))),std2(H1),mean(mean(abs(V1))),std2(V1),mean(mean(abs(D1))),std2(D1),mean(mean(abs(H2))),std2(H2),...
    mean(mean(abs(V2))),std2(V2),mean(mean(abs(D2))),std2(D2),...
    mean(mean(abs(H3))),std2(H3),mean(mean(abs(V3))),std2(V3),mean(mean(abs(D3))),std2(D3)]; 

vector=vector';