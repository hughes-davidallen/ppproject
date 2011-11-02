x = 10;
y = 10;
z = 10;

A = zeros(x,y,z);

%build first slice
for i = 1 : x
   for j = 1 : y
       if i > (x / 3) && i <= ((2*x) / 3) && j > (y / 3) && j <= ((2*y) / 3)
           A(i,j,1) = 100.0;
       end
   end
end
    
%copy first slice down through the rest
for k = 1 : z
    A(:,:,k) = A(:,:,1);
end

%print to file
fid = fopen('input_large2.txt', 'w');

fprintf(fid, '%d\n', x);
fprintf(fid, '%d\n', y);
fprintf(fid, '%d\n', z);

for k = 1 : (z)
    for j = 1 : (y)
        for i = 1 : (x)
            fprintf(fid, '%6.1f,', A(i,j,k));
        end
        
        fprintf(fid, '\n');
    end
    
    fprintf(fid, '\n');
end

fclose(fid);
