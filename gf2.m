function z=gf2(x, mt)
A=x(1);
x0=x(2);
y0=x(3);
sx=x(4);
sy=sx;

[xi, yi] = meshgrid(1:length(mt));


xp=((xi-x0).^2)./(2.*sx.^2);
yp=((yi-y0).^2)./(2.*sy.^2);

g=A.*exp(-(xp+yp));%./(2.*pi.*sx.*sy)

z=sum((g(:)-mt(:)).^2);