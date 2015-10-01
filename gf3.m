function z=gf3(x, mt, ind)
A=x(1);
sx=ind(3);
sy=sx;

x0=ind(1);
y0=ind(2);


[xi, yi] = meshgrid(1:length(mt));


xp=((xi-x0).^2)./(2.*sx.^2);
yp=((yi-y0).^2)./(2.*sy.^2);

g=A.*exp(-(xp+yp));%./(2.*pi.*sx.*sy)

z=sum((g(:)-mt(:)).^2);