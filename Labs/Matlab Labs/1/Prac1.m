%Equation 1 using a loop
 N=100; % This is a comment. Comments are preceded by ‘%’. Set N to 100.
 S=0; % initialise the output with zero. Each line is terminated by a semi-colon.
 for i=1:1:N,
 S=S+i^2; % add the new squared integer to the previous value of S.
 end
 disp('The output is '); S % display the result. Note S is not terminated by ‘;’

%Equation 1 using a matrix
% N=100; % This is a comment. Comments are preceded by ‘%’. Set N to 100.
% Vector=1:1:N; % define a vector of incrementing integers from 1 to N.
% S=sum(Vector.^2);
% disp('The output is '); S % display the result. Note S is not terminated by ‘;’