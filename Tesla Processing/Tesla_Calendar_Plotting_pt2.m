%% code for plotting stuff from Orion BMS csv file
% code for plotting time VS cell voltage 
clear all;
clc

%% Load BMS File
workDir = 'C:\Users\SERF1\Documents\Tesla Calendar Aging';
filename = 'cellvoltages_2022-07-08-12-02-13_T1-12_100.csv';
fname = [workDir,'/',filename]; 
fid = fopen(fname,'r');
Original = textscan(fid, ['%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f ' ...
    '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f ' ...
    '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f ' ...
    '%f %f %f %f %f %f %f %f'], 'HeaderLines', 1,'Delimiter',',');

%% Data Columns
t = Original{:,1};
SOC0 = Original{:,2}; %state of charge (entire pack)
Vpack0 = Original{:,3}; %pack voltage
I0 = Original{:,4}; %Pack current
% Climit = Original{:,5}; %pack CCL
% Dlimit = Original(:,6); %pack DCL
% HighCellID = Original{:,7}; 
% HighCellV0 = Original{:,8};
% LowCellID = Original{:,9};
% LowCellV0 = Original{:,10};
% CSS = Origional{:,11}; %charger safety status
% CHAen = Original{:,12}; %chage enable status
% DCHen = Original{:,13}; %discharge enable status
% HighT = Original{:,14}; %high temp
% LowT = Original{:,15}; %low temp
CV01 = Original{:,16}; %cell voltage 1
CV02 = Original{:,17}; %cell voltage 2
CV03 = Original{:,18};
CV04 = Original{:,19};
CV05 = Original{:,20};
CV06 = Original{:,21};
CR01 = Original{:,22}; %cell resistance 1
CR02 = Original{:,23}; %cell resistance 2
CR03 = Original{:,24};
CR04 = Original{:,25};
CR05 = Original{:,26};
CR06 = Original{:,27};
OCV1 = Original{:,28}; %open cell voltage 1
OCV2 = Original{:,29}; %open cell voltage 2
OCV3 = Original{:,30};
OCV4 = Original{:,31};
OCV5 = Original{:,32};
OCV6 = Original{:,31};
CV1_18 = [CV01 CV02 CV03 CV04 CV05 CV06 CR01 CR02 CR03 CR04 CR05 CR06 OCV1 OCV2 OCV3 OCV4 OCV5 OCV6];

%% Clear extra measurements
keep(1) = 1;
n = 2;
for i = 2:length(t)
    if prod(t{i} == t{i-1}) == 0
    keep(n) = i;
    n = n+1;
    end
end
t0 = t(keep); %Use for analysis
Vpack = Vpack0(keep);
I = I0(keep);
CV = CV1_18(transpose(keep),:);
%writematrix(data,filename)

%% Convert timestamps to hours (takes a while)
for i = 1:length(t)
    X1 = regexp(t{i},' ','split');
    X2 = regexp(X1{4},':','split');
    X3 = [X1{3},'-', X1{2}, '-', X1{6}, '-', X1{4}];
    X4 = datenum(X3,'dd-mmm-yyyy HH:MM:SS');
    t1(i) = X4;
end
t1 = (transpose(t1)-t1(1))*24;
%data = [t1 I Vpack CV];
%[hours amps packV cellV's]

%% making plots
%t1 is the time step
%open cell voltage plots

plot(t1,OCV1) 
title('open cell voltage 1')
xlabel('time')
ylabel("volts")

plot(t1,OCV2)
title('open cell voltage 2')
xlabel('time')
ylabel("volts")

plot(t1, OCV3)
title('open cell voltage 3')
xlabel('time')
ylabel("volts")


plot(t1, OCV4)
title('open cell voltage 4')
xlabel('time')
ylabel("volts")

plot(t1, OCV5)
title('open cell voltage 5')
xlabel('time')
ylabel("volts")

plot(t1, OCV6)
title('open cell voltage 6')
xlabel('time')
ylabel("volts")

%% making more plots
% cell voltage plots

plot(t1, CV01)
title('cell 1 voltage')
xlabel('time')
ylabel("volts")

plot(t1, CV02)
title('cell 2 voltage')
xlabel('time')
ylabel("volts")

plot(t1, CV03)
title('cell 3 voltage')
xlabel('time')
ylabel("volts")

plot(t1, CV04)
title('cell 4 voltage')
xlabel('time')
ylabel("volts")

plot(t1, CV05)
title('cell 5 voltage')
xlabel('time')
ylabel("volts")

plot(t1, CV06)
title('cell 6 voltage')
xlabel('time')
ylabel("volts")


