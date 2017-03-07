function E=getEnergy(matrix)
[m,n]=size(matrix); % m is the number of rows and n is the number of columns
E=sum(sum(double(matrix).^2));
