%% follow nmg advice to calculate the correlation between responses and pixels
%% using the 2nd method calculating the correlations between filter and 
%% and spiking 10/21/15
clear all
close all
clc

load('IM_SPK021.mat')
if exist('AI_SPK')==0; AI_SPK=AI3X3_SPK; AI_dat= AI3X3_dat; end
AI_img=double(AI_dat); AI_img=AI_img-repmat(mean(AI_img,2),1,2500);
NI_img=double(NI_dat); NI_img=NI_img-repmat(mean(NI_img,2),1,2500);
NI_spk=NI_SPK;
AI_spk=AI_SPK;

%% calculate filters
dly=16;
 
 spk_mat=zeros(dly, length(AI_spk));
 AI_spkm=mean(AI_spk);
 for k=1:dly; spk_mat(k, 1:length(spk_mat)-k+1)=AI_spkm( k:length(AI_spk)); end
 AIf=spk_mat*(AI_img./sum(AI_spkm(:)));
 

  %% calculate projections
 
 prjz=AI_img*AIf';
 prj=zeros(size(prjz));
 for k=1:dly; prj(k:end, k)= prjz(1:end-k+1,k); end 
 AIA=sum(prj,2);
 
[c, lags]=xcorr(AIA, mean(AI_SPK)','coeff');
cmx=max(abs(c));

% CCc=zeros(size(AIf));
% indx=reshape(1:length(AIf(:)), size(AIf));
% for j=1:length(AIf(:));
%     AIc=AIf; AIc(j==indx)=0;
%     
%     prjz=AI_img*AIc';
%     prj=zeros(size(prjz));
%     for k=1:dly; prj(k:end, k)= prjz(1:end-k+1,k); end 
%     AIC=sum(prj,2);
%     [c, lags]=xcorr(AIC, mean(AI_SPK)','coeff');
%     CCc(j==indx)=max(abs(c)); 
%     j
% end

load('CCc.mat')
AIc=AIf; AIc(CCc>=cmx)=0;

%%%calculate new projections

prjz=AI_img*AIc';
prj=zeros(size(prjz));
for k=1:dly; prj(k:end, k)= prjz(1:end-k+1,k); end 
AIC=sum(prj,2);

nbn=16;
[nAIC cAIC eAIC]=NLf082115(AIC, AI_SPK, nbn);
[nAIA cAIA eAIA]=NLf082115(AIA, AI_SPK, nbn); 

for k=1:16
     figure(1); subplot(4,4,k); imagesc(reshape(AIc(k,:),50,50)); colormap(gray); 

end

   figure
    subplot(2,2,2)
    plot( AIC,   mean(AI_SPK), ' *', 'color', 'b')  
    hold on; plot( cAIC{1,2}, eAIC, '-rd'); title(['reduced pixels'])

         subplot(2,2,1)
    plot( AIA,   mean(AI_SPK), ' *', 'color', 'b')  
    hold on; plot( cAIA{1,2}, eAIA, '-rd'); title('original')


