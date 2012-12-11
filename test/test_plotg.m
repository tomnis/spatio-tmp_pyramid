
mean=0;
sigma=1;
x=-3:0.01:3;
fx=1 - (1/sqrt(2*pi)/sigma*exp(-(x-mean).^2/2/sigma/sigma));

plot(x,fx)
