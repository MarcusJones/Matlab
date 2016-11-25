function y=impederf(x,zz,om1,dper)
% 02-2005 abs(x)! 
j=sqrt(-1);
if dper==0
w=(sin(om1/2)./om1);   
g=w.*( zz-j*abs(x(1))*om1./(1+abs(x(2))*j*om1)-j*abs(x(3))*om1./(1+abs(x(4))*j*om1) );
else
%w=(sin(om1*dper/2)./om1).^2;
w=(sin(om1*dper/2)./om1);
%w=1;
%g=w.*(zz-((exp(-x(1)*j*om1))./((1+x(2)*j*om1).*(1+x(3)*j*om1))));
g=w.*(zz-(zz.^2).*(exp(abs(x(1))*j*om1)).*(1+abs(x(2))*j*om1-abs(x(3))*om1.^2));
end
y=sum(g.*g'.');
