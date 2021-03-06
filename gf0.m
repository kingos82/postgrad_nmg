function z=gf0(x, mt, vr)

[xi, yi] = meshgrid(1:length(mt));

if length(x)==4
A=x(1);
sx=x(2);
x0=x(3);
y0=x(4);


elseif length(x)==2;
    
A=x(1);
sx=x(2);
x0=vr(1);
y0=vr(2);


elseif length(x)==1;
    
A=x(1);
sx=vr(3);
x0=vr(1);
y0=vr(2);

end
sy=sx;   
    
    



xp=((xi-x0).^2)./(2.*sx.^2);
yp=((yi-y0).^2)./(2.*sy.^2);

g=A.*exp(-(xp+yp));%./(2.*pi.*sx.*sy)

z=sum((g(:)-mt(:)).^2);