%load fisheriris
%who

%To check the size of the variables, type [rows_meas,columns_meas]=size(meas)

%To see how the sepal measurements differ between species, you can use the two columns containing sepal measurements (first and second columns). Type
% gscatter(meas(:,1), meas(:,2), species,'rgb','osd'); xlabel('Sepal
% length'); ylabel('Sepal width');

%gscatter(X,Y,G)