%%% create speciallty cut filter around interest zone.

clear all
close all
clc

load('IM_SPK021.mat')
if exist('AI_SPK')==0; AI_SPK=AI3X3_SPK; AI_dat= AI3X3_dat; end
AI_img=double(AI_dat); AI_img=AI_img-repmat(mean(AI_img,2),1,2500);
NI_img=double(NI_dat); NI_img=NI_img-repmat(mean(NI_img,2),1,2500);
NI_spk=NI_SPK;
AI_spk=AI_SPK;
dly=16; p_sz=50;

%% NI filter
 spk_mat=zeros(dly, length(NI_spk));
 NI_spkm=mean(NI_spk);
 for k=1:dly; spk_mat(k, 1:length(spk_mat)-k+1)=NI_spkm( k:length(NI_spkm)); end
 NI_flt=spk_mat*(NI_img./sum(NI_spkm(:)));
 
 %% AI filter
 spk_mat=zeros(dly, length(AI_spk));
 AI_spkm=mean(AI_spk);
 for k=1:dly; spk_mat(k, 1:length(spk_mat)-k+1)=AI_spkm( k:length(AI_spk)); end
 AI_flt=spk_mat*(AI_img./sum(AI_spkm(:)));
 
 %% cut
 xyz=[28 26 20 1 16]; %AI 
 %xyz=[26 24 8 1 9]; %NI
 y=[xyz(1)-xyz(3):xyz(1)+xyz(3)]; x=[xyz(2)-xyz(3):xyz(2)+xyz(3)]; 
 m = zeros(50,50); m(x,y)=1; m=reshape(m, 1, []); m=repmat(m, 16,1);
 AIc=AI_flt.*m; AIc=AIc(xyz(4):xyz(5),:); 
 NIc=NI_flt.*m; NIc=NIc(xyz(4):xyz(5),:); 
 v=[xyz(4):xyz(5)]; dly=length(v);
%  
% %% fit Gaussian to filter
% %surf(reshape(AIc(3,:),50,50));
% sz=1:50;
% [C,I] = max(abs(AIc(3,:))); [row,col]=find(reshape([1:2500],50,50)==I);
% mt=reshape(AIc(3,:),50,50); %STA(sz, sz);
% 
% x0(1)=AIc(3,I);%%%amplitude
% x0(2)=col;
% x0(3)=row;
% x0(4)= 1;%sd
% 
% 
% outp = fminsearch(@(x) gf2(x,mt), x0)
% 
% A=outp(1);
% x1=outp(2);
% y1=outp(3);
% sx=outp(4);
% sy=sx;
% prmtz=[]; outpi=outp; AIf=[];
% for k=1:16
%     mtx=reshape(AIc(k,:),50,50);
%     outp = fminsearch(@(x) gf3(x,mtx,[x1 y1 sx]), A);
%     prmtz=[prmtz; outp];
%     A=outp(1); 
%     [xi, yi] = meshgrid(1:length(mtx));
%     xp=((xi-x1).^2)./(2.*sx.^2);
%     yp=((yi-y1).^2)./(2.*sy.^2);
%     n=A.*exp(-(xp+yp));%./(2.*pi.*sx.*sy)
%     AIf=[AIf; reshape(n,1,[])];
%     
%     
% end
% 
% 
% 
% [xi, yi] = meshgrid(1:length(mt));
% 
% xp=((xi-x1).^2)./(2.*sx.^2);
% yp=((yi-y1).^2)./(2.*sy.^2);
% 
% n=A.*exp(-(xp+yp));%./(2.*pi.*sx.*sy)
% 
% %n=x(1).*fspecial('gaussian', length(sz), x(2)) +x(3);
% subplot(2,2,1)
% surf(mt)
% title('data')
% 
% subplot(2,2,2)
% surf(reshape(AIf(3,:),50,50))
% title('fit')
% 
% subplot(2,2,3)
% surf(mt-reshape(AIf(3,:),50,50))
% title('data-fit')
% 
% subplot(2,2,4)
% n=reshape(AIf(3,:),50,50);
% plot(1:length(sz), [mt(round(y1),:); n(round(y1),:); mt(:,round(x1))'; n(:,round(x1))'])
% title('x section')

%   %% projections from orginal filter estimation
% %  prjz=NI_img*NIc';
% %  prj=zeros(size(prjz));
% %  for k=1:dly; prj(k:end, k)= prjz(1:end-k+1,k); end 
% %  NIN=sum(prj,2);
% %  
% %  prjz=AI_img*NIc';
% %  prj=zeros(size(prjz));
% %  for k=1:dly; prj(k:end, k)= prjz(1:end-k+1,k); end 
% %  AIN=sum(prj,2);
% %  
% dly=8;
%  prjz=AI_img*AIf';
%  prj=zeros(size(prjz));
%  for k=1:dly; prj(k:end, k)= prjz(1:end-k+1,k); end 
%  AIA=sum(prj,2);
%  
%  prjz=NI_img*AIf';
%  prj=zeros(size(prjz));
%  for k=1:dly; prj(k:end, k)= prjz(1:end-k+1,k); end 
%  NIA=sum(prj,2);
%  
%  nbn=16;
% %[nNINI cNINI eNINI]=NLf082115(NIN, NI_SPK, nbn);
% [nAIAI cAIAI eAIAI]=NLf082115(AIA, AI_SPK, nbn);
% [nNIAI cNIAI eNIAI]=NLf082115(NIA, NI_SPK, nbn);
% %[nAINI cAINI eAINI]=NLf082115(AIN, AI_SPK, nbn);
%  figure(2)
%  
%     %subplot(2,2,1)
%     %plot( NIN,   mean(NI_SPK), ' *', 'color', 'b')  
%     %hold on; plot( cNINI{1,2}, eNINI, '-rd'); title('NINI')
%     
%     subplot(2,2,2)
%     plot( AIA,   mean(AI_SPK), ' *', 'color', 'b')  
%     hold on; plot( cAIAI{1,2}, eAIAI, '-rd'); title('AIAI')
%     
%     subplot(2,2,3)
%     plot( NIA,   mean(NI_SPK), ' *', 'color', 'b')  
%     hold on; plot( cNIAI{1,2}, eNIAI, '-rd'); title('NIAI')
%     
%     %subplot(2,2,4)
%     %plot( AIN,   mean(AI_SPK), ' *', 'color', 'b')  
%     %hold on; plot( cAINI{1,2}, eAINI, '-rd'); title('AINI')
% 
%    for k=1:16
%      figure(3); subplot(4,4,k); imagesc(reshape(AIf(k,:),p_sz,p_sz)); colormap(gray); 
%      title(['A=' num2str(prmtz(k),'%10.2f')])
%      figure(4); subplot(4,4,k); imagesc(reshape(AIc(k,:),p_sz,p_sz)); colormap(gray)
%      figure(5); subplot(4,4,k); imagesc(reshape(AI_flt(k,:),p_sz,p_sz)); colormap(gray)
%    end
%  
 
 
  % projections from orginal filter
 prjz=NI_img*NIc';
 prj=zeros(size(prjz));
 for k=1:dly; prj(k:end, k)= prjz(1:end-k+1,k); end 
 NIN=sum(prj,2);
 
 prjz=AI_img*NIc';
 prj=zeros(size(prjz));
 for k=1:dly; prj(k:end, k)= prjz(1:end-k+1,k); end 
 AIN=sum(prj,2);
 
 prjz=AI_img*AIc';
 prj=zeros(size(prjz));
 for k=1:dly; prj(k:end, k)= prjz(1:end-k+1,k); end 
 AIA=sum(prj,2);
 
 prjz=NI_img*AIc';
 prj=zeros(size(prjz));
 for k=1:dly; prj(k:end, k)= prjz(1:end-k+1,k); end 
 NIA=sum(prj,2);
 
 nbn=16;
[nNINI cNINI eNINI]=NLf082115(NIN, NI_SPK, nbn);
[nAIAI cAIAI eAIAI]=NLf082115(AIA, AI_SPK, nbn);
[nNIAI cNIAI eNIAI]=NLf082115(NIA, NI_SPK, nbn);
[nAINI cAINI eAINI]=NLf082115(AIN, AI_SPK, nbn);
 figure(1)
 
    subplot(2,2,1)
    plot( NIN,   mean(NI_SPK), ' *', 'color', 'b')  
    hold on; plot( cNINI{1,2}, eNINI, '-rd'); title('NINI')
    
    subplot(2,2,2)
    plot( AIA,   mean(AI_SPK), ' *', 'color', 'b')  
    hold on; plot( cAIAI{1,2}, eAIAI, '-rd'); title('AIAI')
    
    subplot(2,2,3)
    plot( NIA,   mean(NI_SPK), ' *', 'color', 'b')  
    hold on; plot( cNIAI{1,2}, eNIAI, '-rd'); title('NIAI')
    
    subplot(2,2,4)
    plot( AIN,   mean(AI_SPK), ' *', 'color', 'b')  
    hold on; plot( cAINI{1,2}, eAINI, '-rd'); title('AINI')
    
   for k=1:16
     figure(2); subplot(4,4,k); imagesc(reshape(AI_flt(k,:),p_sz,p_sz)); colormap(gray)
     if sum(k==v)>0.5
     figure(3); subplot(4,4,k); imagesc(reshape(AIc(k-v(1)+1,:),p_sz,p_sz)); colormap(gray)
     figure(4); subplot(4,4,k); imagesc(reshape(NIc(k-v(1)+1,:),p_sz,p_sz)); colormap(gray)
     end
   end
 
  
   