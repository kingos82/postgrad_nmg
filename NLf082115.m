function [N C err_mat_NL]=NLf082115(prj, spk, nbn)

[prjs, IXs] = sort(prj);
spkm=mean(spk);
spks=spkm(IXs);

bn=(max(prj)-min(prj))./nbn;

prjc=[bn.*floor(min(prjs./bn)):bn: bn.*ceil(max(prjs./bn))];
spkc=[min(spks):1./size(spk,1):max(spks)];

ctrs={spkc', prjc'};

[N, C]=hist3([spks' prjs], ctrs);

[r  c]=size(N);
N_prob=N./repmat(sum(N), r, 1);

[P_max, I_max_prob] = max(N_prob);

for k=1:length(P_max)
   ind=find(N_prob(:,k)==P_max(k));
   if  isempty(ind)==1
       cond_prob_NL(k)=spkc(spkc==0);
   elseif isempty(ind)~=1
       cond_prob_NL(k)=mean(spkc(ind));              
   end   
end

spk_inst=[min(spks):0.05:max(spks)];

for k=1:length(spk_inst)    
 err_mat(k,:)=sum(N_prob.*repmat(abs(spkc-spk_inst(k))',1,c));    
end

[P_min I_err_mat]=min(err_mat);

for k=1:length(P_min)
   ind=find(err_mat(:,k)==P_min(k)); 
   if  isempty(ind)==1
       err_mat_NL(k)=spk_inst(spk_inst==0);
   elseif isempty(ind)~=1
       err_mat_NL(k)=mean(spk_inst(ind));              
   end   
end

% figure
%     plot( NIAI_trn,   NSPK_trn, ' *', 'color', 'b')
%     hold on; plot( flt_ctr, err_mat_NL, '-rd');
%     hold on; plot( flt_ctr, cond_prob_NL, '-go');