%% follow nmg advice to calculate the correlation between responses and pixels
%% using the first method measuring the correlations between image pixels and 
%% and spiking 10/21/15
clear all
close all
clc

thr=0.045; %%thr of 0.0375 gives me identical filters/nl curves 

load('IM_SPK021.mat')
if exist('AI_SPK')==0; AI_SPK=AI3X3_SPK; AI_dat= AI3X3_dat; end
AI_img=double(AI_dat); AI_img=AI_img-repmat(mean(AI_img,2),1,2500);
NI_img=double(NI_dat); NI_img=NI_img-repmat(mean(NI_img,2),1,2500);
NI_spk=NI_SPK;
AI_spk=AI_SPK;

mAIs=mean(AI_spk,1);

cm=zeros(14039, 2500);
for k=1:2500;

[c lags]=xcorr(mAIs', AI_img(:,k),'coeff');
%plot(lags, c)

cm(:,k)=c;

end
[C,I] = max(max(abs(cm)));
mx=max(abs(cm));

IX=1:2500;
IX=IX(mx<thr);
AIc=AI_img; AIc(:,IX)=0;

%% calculate filters
dly=16;
 spk_mat=zeros(dly, length(AI_spk));
 AI_spkm=mean(AI_spk);
 for k=1:dly; spk_mat(k, 1:length(spk_mat)-k+1)=AI_spkm( k:length(AI_spk)); end
 AIfc=spk_mat*(AIc./sum(AI_spkm(:)));
 
 spk_mat=zeros(dly, length(AI_spk));
 AI_spkm=mean(AI_spk);
 for k=1:dly; spk_mat(k, 1:length(spk_mat)-k+1)=AI_spkm( k:length(AI_spk)); end
 AIf=spk_mat*(AI_img./sum(AI_spkm(:)));
 

  %% calculate projections
 
 prjz=AI_img*AIfc';
 prj=zeros(size(prjz));
 for k=1:dly; prj(k:end, k)= prjz(1:end-k+1,k); end 
 AIF=sum(prj,2);
 
 prjz=AI_img*AIf';
 prj=zeros(size(prjz));
 for k=1:dly; prj(k:end, k)= prjz(1:end-k+1,k); end 
 AIA=sum(prj,2);
 
 nbn=16;
[nAIF cAIF eAIF]=NLf082115(AIF, AI_SPK, nbn);
[nAIA cAIA eAIA]=NLf082115(AIA, AI_SPK, nbn); 
 
%%plot 
for k=1:16
     figure(1); subplot(4,4,k); imagesc(reshape(AIfc(k,:),50,50)); colormap(gray); 

end

   figure
     subplot(2,2,2)
    plot( AIF,   mean(AI_SPK), ' *', 'color', 'b')  
    hold on; plot( cAIF{1,2}, eAIF, '-rd'); title(['AIF ' num2str(thr) ])

         subplot(2,2,1)
    plot( AIA,   mean(AI_SPK), ' *', 'color', 'b')  
    hold on; plot( cAIA{1,2}, eAIA, '-rd'); title('AIA')
 
 