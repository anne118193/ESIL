%% ORION BMS PROCESSING
% run each section individually
clear all;
clc

%% Load BMS File
%FOR TEST "Nissan_Aging1wk_da2"
workDir = 'C:\Users\SERF1\Documents\Tesla Calendar Aging';
filename = 'cellvoltages_2022-07-08-12-02-13_T1-12_100.csv';
fname = [workDir,'/',filename]; 
fid = fopen(fname,'r');
Original = textscan(fid, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'HeaderLines', 1,'Delimiter',',');

% Data Columns
t = Original{:,1};
% SOC0 = Original{:,2};
Vpack0 = Original{:,3};
I0 = Original{:,4};
% Climit = Original{:,5};
% Dlimit = Original(:,6);
% HighCellID = Original{:,7};
% HighCellV0 = Original{:,8};
% LowCellID = Original{:,9};
% LowCellV0 = Original{:,10};
% CHAen = Original{:,12};
% DCHen = Original{:,13};
% HighT = Original{:,14};
% LowT = Original{:,15};
CV01 = Original{:,16};
CV02 = Original{:,17};
CV03 = Original{:,18};
CV04 = Original{:,19};
CV05 = Original{:,20};
CV06 = Original{:,21};
CV07 = Original{:,22};
CV08 = Original{:,23};
CV09 = Original{:,24};
CV10 = Original{:,25};
CV11 = Original{:,26};
CV12 = Original{:,27};
CV13 = Original{:,28};
CV14 = Original{:,29};
CV15 = Original{:,30};
CV16 = Original{:,31};
CV1_16 = [CV01 CV02 CV03 CV04 CV05 CV06 CV07 CV08 CV09 CV10 CV11 CV12 CV13 CV14 CV15 CV16];

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
CV = CV1_16(transpose(keep),:);

%% Convert timestamps to hours (takes a while)
for i = 1:length(t0)
    X1 = regexp(t0{i},' ','split');
    X2 = regexp(X1{4},':','split');
    X3 = [X1{3},'-', X1{2}, '-', X1{6}, '-', X1{4}];
    X4 = datenum(X3,'dd-mmm-yyyy HH:MM:SS');
    t1(i) = X4;
end
t1 = (transpose(t1)-t1(1))*24;
data = [t1 I Vpack CV];
%[hours amps packV cellV's]
%writematrix(data,filename) 

%% Start of Steps
L = length(data(:,2));
n = 1;
for i=1:L-1
    if abs(data(i,2)) > 0
        if data(i+1,2) == 0
            Step(n) = i+1;
            n = n+1;
        end
    else
        if abs(data(i+1,2)) > 0
            Step(n) = i+1;
            n = n+1;
        end
    end
end
%Start/End Voltages of Full Discharge
StartVs = data(Step(17)-1,4:end);
EndVs = data(Step(23)-1,4:end); %after pause

%% Convert Voltages to SOH to capcity
SOCcurve = xlsread('SOC_curve.xls');
x=SOCcurve(:,1);
y=SOCcurve(:,2);
for i = 1:length(StartVs)
V = StartVs(i); %Put Voltage to get SOC
A = find(y == V);
if A ~= []
    SOCstart(i) = x(A);
elseif V >= y(end)
    SOCstart(i) = 100;
elseif V <= y(1)
    SOCstart(i) = 0;
else
    A1 = find(y<V);
    A2 = find(y>V);
    SOCstart(i) = ((x(A2(1))-x(A1(end)))/(y(A2(1))-y(A1(end))))*(V-y(A1(end)))+x(A1(end));
end
end

for i = 1:length(EndVs)
V = EndVs(i); %Put Voltage to get SOC
A = find(y == V);
if A ~= []
    SOCend(i) = x(A);
elseif V >= y(end)
    SOCend(i) = 100;
elseif V <= y(1)
    SOCend(i) = 0;
else
    A1 = find(y<V);
    A2 = find(y>V);
    SOCend(i) = ((x(A2(1))-x(A1(end)))/(y(A2(1))-y(A1(end))))*(V-y(A1(end)))+x(A1(end));
end
end
%% Integrate Discharge AmpHours on BMS
%get discharge current values

% get time between steps
n = 1;
for i = 2:length(data)
    newt(i) = data(i,1)-data(i-1,1);
end
newt = transpose(newt);

% Use riemann sum to get Ah between steps
for i = 1:length(Step)-1
    Ah0 = newt.*data(:,2);
       Ah = sum(Ah0(Step(i):Step(i+1)-1));
       StepAh(i) = Ah;
end

DCH1 = sum(StepAh(find(StepAh(1:17)>0)));
TotalDchAh = sum(Ah0(find(Ah0>0)));
DCH2 = TotalDchAh - DCH1; 
CapDchAh = 20*(data(Step(18),1)-data(Step(17),1)); %battery DCH capacity from time at constant current
%%
% %% Integrate Discharge AmpHours on BMS
% %get discharge current values
% n = 1;
% for i = 1:length(Step)
%     if abs(data(Step(i),2)) > 1
%        Ah = sum(data(Step(i):Step(i+1)-1,2)./3600);
%        StepAh(n) = Ah;
%        n = n+1;
%     end
% end
% 
% %CapDchAh = StepDchAh(); %Ah discharged of full step of full discharge
% n = 1;
% for i = 1:length(StepAh)
%     if StepAh(i) > 0
%         StepDchAh(n) = StepAh(i);
%         n = n+1;
%     end
% end
% TotalDchAh = sum(StepDchAh); %Total Ah discharged from test

%% Capacity Calculation
CapDchAh = 40.918188504213148;
for i =1:length(SOCstart)
   Cap(i) = (100/(SOCstart(i)-SOCend(i)))*CapDchAh; %Capacity
%    disp(sprintf('y%d = [y%d; %.15f];',i,i,Cap(i)))
end

% plot values

disp('Start and end dates:')
t0{1}
t0{end}

%% plotting
plot(Cap)
title('Capacitance')
