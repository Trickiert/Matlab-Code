%All varibles are floats by default, unless specified
% Use command window to run statements

x = [1 2 5 1]; % an example vector, 2 dimentional array
x1 = [1 2 3; 5 1 4; 3 2 -1]; % a matrix, "square" 4 dimaentional array

t1 =1:10; %long array, numbers 1 - 10
t2 =2:-0.5:-1; % Long array 2. values each "dimention" seperated with a ":"
t3 = [1:4; 5:8]; % Long array 3, "square array".

%%%%%%%%%%%%%%%%%%Example Code, Run in Command Window%%%%%%%%%%%%%%%%%%%

c1 = zeros(1,3); % x = 0 0 0 (3 zeros)
c2 = ones (1,3); % x = 1 1 1 (3 ones) ect...
c3 = rand(1,3);  % x = (3 random values, between 0 and 1 by default)

%Return a single row only using x(2, :), returns second row only
% x(1,2,2 :) return 1st coloumn, 2nd value

%%%%Operator Examples%%%%%%
%Default operations go by Row the coloumn, see below to do it in element
%order in array.

o1 = [1 2 3; 4 5 6; 7 8 9];
o2 = [3 5 2; 5 2 8; 3 6 9];

o3 = o1 + o2; % adds up each value of the array with the matching one in the other array.
o4 = o1 - o2; %minus each array value
o5 = o1 * o2; %Multiply each array value by the other
%Divide (/) and Power (^) also exist.

o6 = o3'; %Transpose values between both arrays to o6
o7 = o1.*o2; %multiply by element. Rarther than row,coloumn do it by element
             % useful if both arrays have a different number of coloumns or
             % rows than each other.
             
   %%%%%%Basic Functions%%%%%%%%
   
   %Graph
   g=linspace(0,4*pi,100); %Create an x-array of 100 samples between 0
                            %and 4?.
   gy=sin(g); %Calculate sin
              %Can also do exponents and multiply.
   g2 = o1.*o2;
   %plot a caculation like this with (plot(g2))
   
   %Extra display functionality
   %title('Hello, World')
   
   ex=linspace(0,4*pi,100);
   exy=sin(ex);
   %plot(exy)
   %plot(ex,exy)
   
        
   %Stems (Discrete data sequance)
   %stem(exy)
   %stem(ex,exy)
  
   %Can also use contidionals (if,for,while,break) Ect...
    % E.g if (a<3)
    %Some Matlab Commands;
    %elseif (b~=5)
    %Some Matlab Commands;
    %end         
