load data;
[M,N]=size(A); % get the size of matrix A
 
%*************************** output 1 
output1=sum(sum(A.^2))/(M*N);
%display output1
disp('Output 1 is'),output1
%*************************** output 2
output2=0.5*sum(sum(A.*(1+0.2*B)))/(M*N);
%display output2
disp('Output 2 is'),output2
%*************************** output 3 
output3=0.5*sum(sum(A.*(1-(1./(1+0.1*B).^2))));
%display output3
disp('Output 3 is'),output3
