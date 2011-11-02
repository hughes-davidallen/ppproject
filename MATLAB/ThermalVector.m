% Import our input file as a 1D array
<<<<<<< HEAD
M = importdata('/home/tjr2126/4130/project/thermal/src/input.txt', ',');
=======
M = importdata('../thermal/src/output.txt', ',');
>>>>>>> 2cc910f657da890b4407501a7058d84ef1dd8471

% Read first 3 values to get dimensions
x_size = M(1);
y_size = M(2);
z_size = M(3);

A = zeros(x_size, y_size, z_size);
count = 4;

% read the rest into a 3d array of the given size
for k = 1 : (z_size)
    for j = 1 : (y_size)
        for i = 1 : (x_size)
            A(i,j,k) = M(count);
            count = count + 1;
        end
    end
end

A

x = 1:(x_size);
y = 1:(y_size);
z = 1:(z_size);

xmin = 1; 
ymin = 1; 
zmin = 1;

xmax = x_size;
ymax = y_size;
zmax = z_size;

hold on

<<<<<<< HEAD
%h = slice(A);
 
hx = slice(x,y,z,A,(xmax+1)/2,[],[]);
set(hx,'FaceColor','flat','EdgeColor','none')
 
hz = slice(x,y,z,A,[],[],(zmax+1)/2);
set(hz,'FaceColor','flat','EdgeColor','none')
=======
% h = slice(A);
 
hx = slice(x,y,z,A,(xmax+1)/2,[],[]);
set(hx,'FaceColor','interp','EdgeColor','none')

hz = slice(x,y,z,A,[],[],(zmax+1)/2);
set(hz,'FaceColor','interp','EdgeColor','none')
>>>>>>> 2cc910f657da890b4407501a7058d84ef1dd8471
