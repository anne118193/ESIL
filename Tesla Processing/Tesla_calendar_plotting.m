%% Tesla Calendar Plotting
% SOC and Voltage VS time 
data = csvread('/Users/ITSloaner/Downloads/Tesla Processing/cellvoltages_2022-07-08-12-02-13_T1-12_100.csv',1,1);


rows = height(data); %get number of rows in csv file

%calculate time
time = zeros(rows);
for i=1 : rows
    time(i) = data(i+1,4)-data(i+2,4);
end
%use VOC from the .csv data 
plot()