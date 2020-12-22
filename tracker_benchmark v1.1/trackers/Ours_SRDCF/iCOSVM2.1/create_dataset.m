A=[];
for i=1:9
img = strcat('face/cmu_000',int2str(i),'.pgm');
a=imread(img);
b=double(a);
g=reshape(b,19*19,1);
h=double(g);
A=[A h];
end

for i=10:99
img = strcat('face/cmu_00',int2str(i),'.pgm');
a=imread(img);
b=double(a);
g=reshape(b,19*19,1);
h=double(g);
A=[A h];
end

for i=100:471
img = strcat('face/cmu_0',int2str(i),'.pgm');
a=imread(img);
b=double(a);
g=reshape(b,19*19,1);
h=double(g);
A=[A h];
end

for i=1:9
img = strcat('non-face/cmu_000',int2str(i),'.pgm');
a=imread(img);
b=double(a);
g=reshape(b,19*19,1);
h=double(g);
A=[A h];
end

for i=10:99
img = strcat('non-face/cmu_00',int2str(i),'.pgm');
a=imread(img);
b=double(a);
g=reshape(b,19*19,1);
h=double(g);
A=[A h];
end

for i=100:999
img = strcat('non-face/cmu_0',int2str(i),'.pgm');
a=imread(img);
b=double(a);
g=reshape(b,19*19,1);
h=double(g);
A=[A h];
end

for i=1000:23572
img = strcat('non-face/cmu_',int2str(i),'.pgm');
a=imread(img);
b=double(a);
g=reshape(b,19*19,1);
h=double(g);
A=[A h];
end

Data = A;
save('test_face.mat','A');
save('test_face.dat','A','-ascii');
