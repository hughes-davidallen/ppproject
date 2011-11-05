% Import our input file as a 1D array
M = importdata('../thermal/src/output.txt', ',');
% Read first 3 values to get dimensions
x_size = M(1);
y_size = M(2);
z_size = M(3);

% allocate 3D array with desired dimensions
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

%Optionally print to console
%A

%generate variables required for visualization functions
x = 1:(x_size);
y = 1:(y_size);
z = 1:(z_size);

xmin = 1;
ymin = 1;
zmin = 1;

xmax = x_size;
ymax = y_size;
zmax = z_size;

%allow multiple planes to be displayed
hold on
 
%plane parallel to the x-axis
hx = slice(x,y,z,A,(xmax+1)/2,[],[]);
set(hx,'FaceColor','interp','EdgeColor','none')

%plane parallel to the z-axis
hz = slice(x,y,z,A,[],[],(zmax+1)/2);
set(hz,'FaceColor','interp','EdgeColor','none')
