	clc; close all; clear all;
%% Initialization Parameters
    Pt = 100e-3; %Power in Watt
	L = 1.5;  %Distance Tx and Rx
	D = 1e-5;  %Diameter of PD
	teta = 1e-3; %Laser Beam Divergence Angle
	q = 1.6e-19;  %Electron Field
	B = 1e9; %Bandwidth
	R = 1.68; %Responsivity of PD  
	ID = 1e-8; %Dark Current 
	T = 298; %Temperature 
	Tt = 0.75; 
	kb = 1.38e-23; %Boltzman 
	Fn = 1; %Noise Figure PIN 
	Rl = 1000;  
	m = 8; %Time Slot
	wavl = 1550; %Lambda
	Visibility = 0:0.1:10;
    
%% Loop for different wavelength
    for j=1:length(wavl)
        
%% Loop for Visibility
        for i=1:length(Visibility)
			V=Visibility(i);
            
%% Loop for Kim model value 
			if (V >=50)
				dho=1.6;
			elseif  (V>=6) && (V<50)
				dho=1.3;
			elseif (V>=1)&&(V<6)
				dho=(0.16*V)+0.34;
			elseif (V>=0.5)&&(V<1)
				dho=V-0.5;
			else 
				dho=0;
            end
            
%% Calculate beta and gamma value
			beta(i)=(3.91/V)*(wavl(j)/550)^-dho;
			gamma1(i)=-1*(beta(i)+4.14664859553004);
            
%% Calculate Power value at Receiver
			x(i)= (10.^(gamma1(i)*L/10)); 
			z= (D^2) / ((teta^2)*(L^2));
			pr(i)=Pt*z*x(i)*(Tt^2);
            
%% Current Primer
			Ip(i)=pr(i)*R;
            
%% SNR
            SNR(i) = (Ip(i)^2)/(2*q*B*(Ip(i)+ID)+((4*kb*T*B*Fn)/Rl));
            SNRdb(i) = 10*log10(SNR(i));
            
%% BER
            bernrz(i)=0.5*erfc(0.353*sqrt(SNR(i)));
            berrz(i)=0.5*erfc(0.5*sqrt(SNR(i)));
        	berp(i)=0.5*erfc(0.353*sqrt(SNR(i)*(m/2)*log2(m)));
        end
    end
    
%% Plot Graphic SNRdb
    figure;
	plot(Visibility,SNRdb);
	grid on;
	xlabel('Visibility (km)');
	ylabel('SNRdb');
	legend('SNRdb')
	title('SNRdb per Visibility');
    
%% Plot Graphic BERNRZ
    figure;
	semilogy (Visibility,bernrz,'b-x');
	grid on;
	xlabel('Visibility (km)');
	ylabel('BER');
	legend('NRZ')
	title('BER per Visibility');
    
%% Plot Graphic BERRZ
    figure;
	semilogy (Visibility,berrz,'k-+');
	grid on;
	xlabel('Visibility (km)');
	ylabel('BER');
	legend('RZ')
	title('BER per Visibility');
    
%% Plot Graphic BERPPM
    figure;
	semilogy (Visibility,berp,'g:^');
	grid on;
	xlabel('Visibility (km)');
	ylabel('BER');
	legend('8-PPM')
	title('BER per Visibility');