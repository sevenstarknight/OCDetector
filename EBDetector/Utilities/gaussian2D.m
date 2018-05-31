%% 2D Gaussian filter
function h = gaussian2D(siz, std)

% create the grid of (x,y) values
siz = (siz-1)./2;
[x,y] = meshgrid(-siz(2):siz(2),-siz(1):siz(1));

% analytic function
h = exp(-(x.*x + y.*y)/(2*std*std));

% truncate very small values to zero
h(h<eps*max(h(:))) = 0;

% normalize filter to unit L1 energy 
sumh = sum(h(:));
if sumh ~= 0
    h = h/sumh;
end


end