	clc; clear all; close all;
    
    %This is a value from scintillation, which takes on turbulences of
    %10e-14 (Weak)
    
    Cn = 10e-14; %Refractive Index Bias Structure Parameter 
	k = (2*pi)/(1550e-9); % k = (2*pi)/lamda
	L = 1500; %Distance Tx and Rx in meter 
	a = k^1.17;
	b = L^1.83;   
	dox = 1.23*Cn*a*b;
	doxin = 2*sqrt(dox);